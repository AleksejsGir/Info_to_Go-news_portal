# news/views.py
from users.utils import record_user_activity
from django.contrib.auth.mixins import LoginRequiredMixin # это встроенный миксин в Django!!!!
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, get_object_or_404, redirect
from django.db.models import Count, Q
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_protect
from django.utils.decorators import method_decorator
from django.views.generic import (
    ListView, DetailView, TemplateView, View,
    FormView, CreateView, UpdateView, DeleteView
)
from django.urls import reverse_lazy

from .models import Article, Tag, Category, Like, Favorite
from .forms import ArticleForm, ArticleUploadForm
from django.contrib import messages
from django.contrib.auth import get_user_model
from .forms import ArticleForm, ArticleUploadForm, CommentForm

# Класс для получения данных о категориях
class CategoryService:
    @staticmethod
    def get_categories_with_count():
        return Category.objects.annotate(news_count=Count('article')).order_by('name')


# Удаляем BaseMixin, так как теперь используем контекстный процессор


# 14. Выносим общую логику списка статей в отдельный класс
class BaseArticleListView(ListView):
    """
    Базовый класс для всех представлений, отображающих списки статей.
    Содержит общую логику и настройки для дочерних классов.
    """
    model = Article
    context_object_name = 'news'
    paginate_by = 8

    def get_queryset(self):
        """
        Базовая реализация получения статей с оптимизацией запросов
        и дополнительной поддержкой сортировки
        """
        # Получаем параметры сортировки из GET-запроса
        sort = self.request.GET.get('sort', 'publication_date')
        order = self.request.GET.get('order', 'desc')

        # Используем метод сортировки из модели
        return Article.objects.sort_by(sort, order)

    def get_context_data(self, **kwargs):
        """
        Добавляет в контекст количество статей в текущей выборке
        и параметры текущей сортировки для сохранения при пагинации
        """
        context = super().get_context_data(**kwargs)
        context.update({
            'news_count': self.get_queryset().count(),
            'current_sort': self.request.GET.get('sort', 'publication_date'),
            'current_order': self.request.GET.get('order', 'desc')
        })
        return context


# 1. Переписать about на TemplateView
class AboutView(TemplateView):
    template_name = 'about.html'


# Также добавим представление для главной страницы
class MainView(TemplateView):
    template_name = 'main.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        # Получаем актуальные данные для главной страницы
        context['featured_articles'] = Article.objects.filter(
            is_active=True
        ).order_by('-publication_date')[:5]

        context['latest_articles'] = Article.objects.filter(
            is_active=True
        ).order_by('-publication_date')[:6]

        context['most_viewed_articles'] = Article.objects.filter(
            is_active=True
        ).order_by('-views')[:4]

        # Получаем статьи по категориям
        popular_categories = Category.objects.annotate(
            articles_count=Count('article')
        ).order_by('-articles_count')[:4]

        category_articles = {}
        for category in popular_categories:
            articles = Article.objects.filter(
                category=category,
                is_active=True
            ).order_by('-publication_date')[:3]
            category_articles[category] = articles

        context['category_articles'] = category_articles
        context['users_count'] = get_user_model().objects.count()

        return context


# Представление для отображения всех новостей (каталог)
class CatalogListView(BaseArticleListView):
    """
    Отображает каталог всех новостей с сортировкой
    Вся логика сортировки уже в базовом классе!
    """
    template_name = 'news/catalog.html'


# 2. Переписать get_news_by_category на ListView
class CategoryNewsListView(BaseArticleListView):
    template_name = 'news/catalog.html'

    def get_queryset(self):
        self.category = get_object_or_404(Category, id=self.kwargs['category_id'])
        # Получаем базовый queryset и применяем фильтр по категории
        queryset = super().get_queryset()
        return queryset.by_category(self.category)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['current_category'] = self.category
        return context


# 3. Переписать get_news_by_tag на ListView
class TagNewsListView(BaseArticleListView):
    template_name = 'news/catalog.html'

    def get_queryset(self):
        self.tag = get_object_or_404(Tag, id=self.kwargs['tag_id'])
        # Получаем базовый queryset и применяем фильтр по тегу
        queryset = super().get_queryset()
        return queryset.by_tag(self.tag)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['current_tag'] = self.tag
        return context


# 15. Выносим повторяющийся код toggle-логики в отдельный класс
# Обновление класса BaseToggleView
class BaseToggleView(LoginRequiredMixin, View):
    """
    Базовый класс для представлений с логикой переключения состояния (лайки, избранное)
    Доступно только авторизованным пользователям
    """
    model = None
    response_field = None
    count_field = None
    toggle_method = None

    def post(self, request, article_id):
        try:
            # Получаем статью или возвращаем 404
            article = get_object_or_404(Article, id=article_id)

            # Используем метод модели для переключения состояния
            method = getattr(article, self.toggle_method)
            is_active, count = method(request.user)

            # Определяем тип действия и описание в зависимости от метода
            if self.toggle_method == 'toggle_like':
                action_type = 'like_article'
                action_description = f'{"Добавлен" if is_active else "Удален"} лайк к статье "{article.title}"'
            else:  # toggle_favorite
                action_type = 'favorite_article'
                action_description = f'{"Добавлена статья в избранное" if is_active else "Удалена статья из избранного"}: "{article.title}"'

            # Записываем действие в историю
            record_user_activity(
                user=request.user,
                action_type=action_type,
                description=action_description,
                related_object_id=article.id
            )

            # Формируем ответ
            response_data = {
                self.response_field: is_active,
                self.count_field: count
            }

            return JsonResponse(response_data)

        except Exception as e:
            # Логируем возможные ошибки
            print(f"Ошибка при обработке toggle: {e}")
            return JsonResponse({'error': str(e)}, status=400)


# 4. Переписать toggle_favorite на View
class ToggleFavoriteView(BaseToggleView):
    model = Favorite
    session_key = 'favorite_articles'
    response_field = 'is_favorite'
    count_field = 'favorites_count'
    related_name = 'favorites'
    toggle_method = 'toggle_favorite'


# 5. Переписать toggle_like на View
class ToggleLikeView(BaseToggleView):
    model = Like
    session_key = 'liked_articles'
    response_field = 'liked'
    count_field = 'likes_count'
    related_name = 'likes'
    toggle_method = 'toggle_like'


# 6. Переписать upload_json_view на FormView
class UploadJsonView(LoginRequiredMixin, FormView):
    template_name = 'news/upload_json.html'
    form_class = ArticleUploadForm
    success_url = reverse_lazy('news:edit_article_from_json')

    def form_valid(self, form):
        # Получаем данные, которые мы сохранили в форме
        json_data = form.json_data
        validation_results = form.validation_results

        # Сохраняем список статей с проблемами в сессии
        if hasattr(form, 'articles_with_issues'):
            self.request.session['articles_with_issues'] = form.articles_with_issues

        # Проверяем, есть ли новые категории или теги
        has_new_items = validation_results['new_categories'] or validation_results['new_tags']

        # Если есть новые элементы и пользователь не подтвердил их создание,
        # показываем предупреждение
        if has_new_items and 'confirm' not in self.request.POST:
            return self.render_to_response(self.get_context_data(
                form=form,
                validation_results=validation_results
            ))

        # Создаем новые категории и теги
        self._create_new_categories_and_tags(validation_results)

        # Сохраняем данные в сессии для потокового редактирования
        self.request.session['json_articles'] = json_data
        self.request.session['current_article_index'] = 0
        self.request.session['total_articles'] = len(json_data)

        return super().form_valid(form)

    def _create_new_categories_and_tags(self, validation_results):
        """Создает новые категории и теги на основе результатов валидации"""
        # Создаем новые категории, если есть
        for category_name in validation_results['new_categories']:
            Category.objects.get_or_create(name=category_name)

        # Создаем новые теги, если есть
        for tag_name in validation_results['new_tags']:
            Tag.objects.get_or_create(name=tag_name)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if 'validation_results' in kwargs:
            context['validation_results'] = kwargs['validation_results']
        return context


# 7. Переписать search_news на ListView
class SearchNewsView(BaseArticleListView):
    template_name = 'news/search_results.html'

    def get_queryset(self):
        query = self.request.GET.get('q', '')
        # Используем метод поиска из модели
        return Article.objects.search(query)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['query'] = self.request.GET.get('q', '')
        return context


# 8. Переписать favorites на ListView
# Обновление класса FavoriteNewsListView
class FavoriteNewsListView(LoginRequiredMixin, BaseArticleListView):
    template_name = 'news/favorites.html'

    def get_queryset(self):
        # Получаем избранные статьи для текущего пользователя
        favorite_articles = Favorite.objects.get_favorites_for_user(self.request.user)

        # Получаем базовый queryset с сортировкой и применяем фильтр
        return super().get_queryset().filter(id__in=favorite_articles)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['is_favorites_page'] = True
        return context


# Базовый класс для детального просмотра статей
class BaseArticleDetailView(DetailView):
    """
    Базовый класс для детального просмотра статьи с инкрементом счетчика просмотров
    """
    model = Article
    template_name = 'news/article_detail.html'
    context_object_name = 'article'

    def get(self, request, *args, **kwargs):
        response = super().get(request, *args, **kwargs)
        article = self.get_object()

        # Увеличиваем просмотры только для новых посещений
        self._track_article_view(request, article)

        return response

    def _track_article_view(self, request, article):
        """Отслеживает просмотр статьи и обновляет счетчик при необходимости"""
        # Инициализация списка просмотренных статей в сессии
        if 'viewed_articles' not in request.session:
            request.session['viewed_articles'] = []

        # Получаем список просмотренных статей
        viewed_articles = request.session['viewed_articles']

        # Увеличиваем счетчик только если статья еще не просматривалась
        if article.id not in viewed_articles:
            article.increment_views()
            # Добавляем ID статьи в список просмотренных
            viewed_articles.append(article.id)
            request.session.modified = True


# 9. Переписать get_detail_article_by_slag на DetailView
class ArticleDetailBySlugView(BaseArticleDetailView):
    slug_url_kwarg = 'title'  # Используем 'title' как аргумент URL для slug


# Представление для детальной страницы статьи по ID
# Обновление класса ArticleDetailView
class ArticleDetailView(BaseArticleDetailView):
    pk_url_kwarg = 'article_id'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        article = self.get_object()

        # Добавляем комментарии в контекст
        context['comments'] = article.comments.all()

        # Добавляем форму комментария для авторизованных пользователей
        if self.request.user.is_authenticated:
            context['comment_form'] = CommentForm()

        # Добавляем информацию о лайке и избранном для текущего пользователя
        if self.request.user.is_authenticated:
            context['is_liked'] = article.is_liked_by_user(self.request.user)
            context['is_favorite'] = article.is_favorite_for_user(self.request.user)
        else:
            context['is_liked'] = False
            context['is_favorite'] = False

        return context

    def post(self, request, *args, **kwargs):
        # Проверяем, авторизован ли пользователь
        if not request.user.is_authenticated:
            messages.error(request, 'Для добавления комментария необходимо авторизоваться')
            return redirect('users:login')

        # Получаем статью
        article = self.get_object()

        # Создаем экземпляр формы с данными из запроса
        form = CommentForm(request.POST)

        if form.is_valid():
            # Создаем комментарий, но не сохраняем его пока
            comment = form.save(commit=False)
            comment.article = article
            comment.user = request.user
            comment.save()

            # Записываем действие в историю активности
            record_user_activity(
                user=request.user,
                action_type='add_comment',
                description=f'Добавлен комментарий к статье "{article.title}"',
                related_object_id=article.id
            )

            messages.success(request, 'Комментарий успешно добавлен')
        else:
            messages.error(request, 'Ошибка при добавлении комментария')

        # Перенаправляем обратно на страницу статьи
        return redirect('news:detail_article_by_id', article_id=article.id)


# 10. Переписать add_article на CreateView
class ArticleCreateView(LoginRequiredMixin, CreateView):
    model = Article
    form_class = ArticleForm
    template_name = 'news/add_article.html'
    redirect_field_name = 'next'

    def form_valid(self, form):
        # Извлекаем валидированные данные из формы
        article = form.save(commit=False)
        article.views = 0

        # Если пользователь не модератор/админ, ставим статус "не проверено"
        if self.request.user.is_superuser or self.request.user.groups.filter(name="Moderator").exists():
            article.status = Article.Status.CHECKED
        else:
            article.status = Article.Status.UNCHECKED

        # Добавляем текущего пользователя как автора
        article.author = self.request.user

        article.save()
        form.save_m2m()  # Сохраняем теги (many-to-many отношения)

        # Добавляем запись о создании статьи в историю действий
        record_user_activity(
            user=self.request.user,
            action_type='create_article',
            description=f'Создана статья "{article.title}"',
            related_object_id=article.id
        )

        return redirect('news:detail_article_by_id', article_id=article.id)


class ArticleUpdateView(LoginRequiredMixin, UpdateView):
    model = Article
    form_class = ArticleForm
    template_name = 'news/edit_article.html'
    pk_url_kwarg = 'article_id'
    redirect_field_name = 'next'

    def get_queryset(self):
        """
        Ограничивает доступ к редактированию статей.
        Admin и Moderator могут редактировать любые статьи,
        обычные пользователи - только свои.
        """
        qs = super().get_queryset()
        # Администратор и модератор могут редактировать все статьи
        if self.request.user.is_superuser or self.request.user.groups.filter(name="Moderator").exists():
            return qs
        # Обычный пользователь - только свои статьи
        return qs.filter(author=self.request.user)

    def form_valid(self, form):
        response = super().form_valid(form)

        # Добавляем запись о редактировании статьи в историю действий
        record_user_activity(
            user=self.request.user,
            action_type='edit_article',
            description=f'Отредактирована статья "{self.object.title}"',
            related_object_id=self.object.id
        )

        return response

    def get_success_url(self):
        return reverse_lazy('news:detail_article_by_id', kwargs={'article_id': self.object.id})


class ArticleDeleteView(LoginRequiredMixin, DeleteView):
    model = Article
    template_name = 'news/delete_article.html'
    success_url = reverse_lazy('news:catalog')
    pk_url_kwarg = 'article_id'
    redirect_field_name = 'next'

    def get_queryset(self):
        """
        Ограничивает доступ к удалению статей.
        Admin и Moderator могут удалять любые статьи,
        обычные пользователи - только свои.
        """
        qs = super().get_queryset()
        # Администратор и модератор могут удалять все статьи
        if self.request.user.is_superuser or self.request.user.groups.filter(name="Moderator").exists():
            return qs
        # Обычный пользователь - только свои статьи
        return qs.filter(author=self.request.user)

    def delete(self, request, *args, **kwargs):
        # Получаем статью до ее удаления, чтобы сохранить информацию
        article = self.get_object()
        article_title = article.title
        article_id = article.id

        # Вызываем родительский метод delete для выполнения удаления
        response = super().delete(request, *args, **kwargs)

        # Записываем действие об удалении статьи в историю действий
        record_user_activity(
            user=request.user,
            action_type='delete_article',
            description=f'Удалена статья "{article_title}"',
            related_object_id=article_id
        )

        return response


# 13. Преобразуем функцию edit_article_from_json в класс
class EditArticleFromJsonView(LoginRequiredMixin, View):
    def get(self, request):
        # Проверяем наличие данных в сессии
        if 'json_articles' not in request.session:
            messages.error(request, 'Сначала загрузите JSON-файл с новостями')
            return redirect('news:upload_json')

        # Получаем все необходимые данные из сессии
        session_data = self._get_session_data(request)

        # Проверяем, не закончился ли список статей
        if session_data['current_index'] >= session_data['total_articles']:
            messages.success(request, 'Все статьи отредактированы')
            return redirect('news:save_articles_from_json')

        # Подготавливаем контекст для шаблона
        context = self._prepare_context(request, session_data)

        return render(request, 'news/edit_article_from_json.html', context)

    def post(self, request):
        # Проверяем наличие данных в сессии
        if 'json_articles' not in request.session:
            messages.error(request, 'Сначала загрузите JSON-файл с новостями')
            return redirect('news:upload_json')

        # Получаем все необходимые данные из сессии
        session_data = self._get_session_data(request)

        # Получаем текущую статью и обновляем её данные
        current_article = session_data['json_articles'][session_data['current_index']]
        self._update_article_data(request, current_article)

        # Обновляем сессию
        session_data['json_articles'][session_data['current_index']] = current_article
        request.session['json_articles'] = session_data['json_articles']

        # Проверяем и обновляем статус проблем
        self._update_issues_status(request, current_article, session_data)

        # Обрабатываем кнопки навигации
        return self._handle_navigation(request)

    def _get_session_data(self, request):
        """Извлекает и возвращает все необходимые данные из сессии"""
        return {
            'json_articles': request.session['json_articles'],
            'current_index': request.session['current_article_index'],
            'total_articles': request.session['total_articles'],
            'articles_with_issues': request.session.get('articles_with_issues', [])
        }

    def _prepare_context(self, request, session_data):
        """Подготавливает контекст для шаблона"""
        # Получаем текущую статью
        current_article = session_data['json_articles'][session_data['current_index']]

        # Определяем проблемы с текущей статьей, если есть
        current_article_issues = self._get_article_issues(
            session_data['current_index'],
            session_data['articles_with_issues']
        )

        # Получаем категорию и теги
        category_name = current_article.get('category', '')
        category = Category.objects.filter(name__iexact=category_name).first()
        article_tags = current_article.get('tags', [])

        # Формируем контекст
        return {
            'article': current_article,
            'current_index': session_data['current_index'],
            'total_articles': session_data['total_articles'],
            'categories': Category.objects.all(),
            'tags': Tag.objects.all(),
            'selected_category': category,
            'selected_tags': article_tags,
            'categories_list': CategoryService.get_categories_with_count(),
            'missing_fields': current_article_issues
        }

    def _update_article_data(self, request, article):
        """Обновляет данные статьи из POST-запроса"""
        article['title'] = request.POST.get('title', '')
        article['content'] = request.POST.get('content', '')
        article['category'] = request.POST.get('category', '')

        # Обрабатываем теги
        selected_tags = []
        for tag in Tag.objects.all():
            if f'tag_{tag.id}' in request.POST:
                selected_tags.append(tag.name)
        article['tags'] = selected_tags

    def _update_issues_status(self, request, article, session_data):
        """Проверяет и обновляет статус проблем для статьи"""
        current_index = session_data['current_index']
        articles_with_issues = session_data['articles_with_issues']

        # Получаем текущие проблемы
        current_article_issues = self._get_article_issues(current_index, articles_with_issues)

        if current_article_issues:
            # Проверяем, остались ли еще проблемы
            still_missing = []
            if not article['title']:
                still_missing.append('title')
            if not article['content']:
                still_missing.append('content')

            # Обновляем список проблем
            if not still_missing:
                # Удаляем эту статью из списка проблем
                request.session['articles_with_issues'] = [
                    issue for issue in articles_with_issues
                    if issue['index'] != current_index
                ]
            elif still_missing != current_article_issues:
                # Обновляем отсутствующие поля
                for issue in articles_with_issues:
                    if issue['index'] == current_index:
                        issue['missing_fields'] = still_missing
                        break
                request.session['articles_with_issues'] = articles_with_issues

    def _get_article_issues(self, current_index, articles_with_issues):
        """Находит проблемы для текущей статьи"""
        for article_issue in articles_with_issues:
            if article_issue['index'] == current_index:
                return article_issue['missing_fields']
        return None

    def _handle_navigation(self, request):
        """Обрабатывает навигационные кнопки формы"""
        if 'next_article' in request.POST:
            request.session['current_article_index'] += 1
            return redirect('news:edit_article_from_json')
        elif 'save_all' in request.POST:
            return redirect('news:save_articles_from_json')

        # По умолчанию остаемся на текущей странице
        return redirect('news:edit_article_from_json')


# 14. Преобразуем функцию save_articles_from_json в класс
class SaveArticlesFromJsonView(LoginRequiredMixin, View):
    def get(self, request):
        if 'json_articles' not in request.session:
            messages.error(request, 'Нет данных для сохранения')
            return redirect('news:catalog')

        # Проверяем, есть ли нерешенные проблемы
        articles_with_issues = request.session.get('articles_with_issues', [])
        if articles_with_issues:
            # Перенаправляем на первую статью с проблемами
            first_issue_index = articles_with_issues[0]['index']
            request.session['current_article_index'] = first_issue_index
            messages.error(request, 'Есть статьи с незаполненными обязательными полями')
            return redirect('news:edit_article_from_json')

        # Получаем данные из сессии
        json_articles = request.session['json_articles']

        # Сохраняем статьи
        saved_articles = self._save_articles(json_articles)

        # Очищаем сессию
        self._clear_session(request)

        # Отображаем сообщение об успешном импорте
        messages.success(request, f'Успешно сохранено {saved_articles} статей')
        return redirect('news:catalog')

    def _save_articles(self, json_articles):
        """Сохраняет статьи из JSON в базу данных, пропуская дубликаты."""
        saved_articles = 0
        existing_titles = set(Article.objects.values_list('title', flat=True))

        for article_data in json_articles:
            try:
                # Пропускаем статьи с отсутствующими обязательными полями или дубликатами
                if not article_data.get('title') or not article_data.get('content') or article_data['title'] in existing_titles:
                    continue

                # Создаем новую статью
                article = Article(
                    title=article_data['title'],
                    content=article_data['content'],
                    views=0,
                    status=Article.Status.UNCHECKED
                )

                # Добавляем категорию
                category_name = article_data.get('category', '')
                if category_name:
                    category = Category.objects.filter(name__iexact=category_name).first()
                    if category:
                        article.category = category
                    else:
                        article.category = Category.objects.first()
                else:
                    article.category = Category.objects.first()

                # Сохраняем статью
                article.save()

                # Добавляем теги
                for tag_name in article_data.get('tags', []):
                    tag = Tag.objects.filter(name__iexact=tag_name).first()
                    if tag:
                        article.tags.add(tag)

                saved_articles += 1
                existing_titles.add(article_data['title'])  # Добавляем сохраненную статью в набор существующих

            except Exception as e:
                # Если что-то пошло не так, логируем ошибку
                print(f"Ошибка при сохранении статьи: {e}")
                continue

        return saved_articles

    def _clear_session(self, request):
        """Очищает сессию от данных JSON"""
        session_keys = [
            'json_articles',
            'current_article_index',
            'total_articles',
            'articles_with_issues'
        ]

        for key in session_keys:
            if key in request.session:
                del request.session[key]