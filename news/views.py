# news/views.py
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
from django.views.generic.base import ContextMixin
from django.urls import reverse_lazy

from .models import Article, Tag, Category, Like, Favorite
from .forms import ArticleForm, ArticleUploadForm
from django.contrib import messages


# Класс для получения данных о категориях
class CategoryService:
    @staticmethod
    def get_categories_with_count():
        return Category.objects.annotate(news_count=Count('article')).order_by('name')


# Создаем миксин для добавления навигационного меню во все представления
class BaseMixin(ContextMixin):
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context.update({
            "users_count": 5,
            "news_count": Article.objects.count(),  # Используем метод count вместо len(all())
            "menu": [
                {"title": "Главная",
                 "url": "/",
                 "url_name": "index"},
                {"title": "О проекте",
                 "url": "/about/",
                 "url_name": "about"},
                {"title": "Каталог",
                 "url": "/news/catalog/",
                 "url_name": "news:catalog"},  # Обновлено для использования пространства имён
            ],
            'categories_list': CategoryService.get_categories_with_count(),
        })
        return context


# 14. Выносим общую логику списка статей в отдельный класс
class BaseArticleListView(BaseMixin, ListView):
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
        """
        return Article.objects.select_related('category').prefetch_related('tags')

    def get_context_data(self, **kwargs):
        """
        Добавляет в контекст количество статей в текущей выборке
        """
        context = super().get_context_data(**kwargs)
        context['news_count'] = self.get_queryset().count()
        return context


# 1. Переписать about на TemplateView
class AboutView(BaseMixin, TemplateView):
    template_name = 'about.html'


# Также добавим представление для главной страницы
class MainView(BaseMixin, TemplateView):
    template_name = 'main.html'


# Представление для отображения всех новостей (каталог)
class CatalogListView(BaseArticleListView):
    template_name = 'news/catalog.html'

    def get_queryset(self):
        # Считаем параметры из GET-запроса
        sort = self.request.GET.get('sort', 'publication_date')
        order = self.request.GET.get('order', 'desc')

        # Проверяем дали ли мы разрешение на сортировку по этому полю
        valid_sort_fields = {'publication_date', 'views'}
        if sort not in valid_sort_fields:
            sort = 'publication_date'

        # Обрабатываем направление сортировки
        if order == 'asc':
            order_by = sort
        else:
            order_by = f'-{sort}'

        return super().get_queryset().order_by(order_by)


# 2. Переписать get_news_by_category на ListView
class CategoryNewsListView(BaseArticleListView):
    template_name = 'news/catalog.html'

    def get_queryset(self):
        self.category = get_object_or_404(Category, id=self.kwargs['category_id'])
        return super().get_queryset().filter(category=self.category)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['current_category'] = self.category
        return context


# 3. Переписать get_news_by_tag на ListView
class TagNewsListView(BaseArticleListView):
    template_name = 'news/catalog.html'

    def get_queryset(self):
        self.tag = get_object_or_404(Tag, id=self.kwargs['tag_id'])
        return super().get_queryset().filter(tags=self.tag)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['current_tag'] = self.tag
        return context


# 15. Выносим повторяющийся код toggle-логики в отдельный класс
class BaseToggleView(View):
    """
    Базовый класс для представлений с логикой переключения состояния (лайки, избранное)
    """
    model = None  # Модель для работы (Like или Favorite)
    session_key = None  # Ключ в сессии ('liked_articles' или 'favorite_articles')
    response_field = None  # Название поля в JSON-ответе ('liked' или 'is_favorite')
    count_field = None  # Название поля для счетчика в JSON-ответе ('likes_count' или 'favorites_count')
    related_name = None  # Имя связи в модели Article ('likes' или 'favorites')

    @method_decorator(csrf_protect)
    def post(self, request, article_id):
        try:
            # Получаем статью или возвращаем 404
            article = get_object_or_404(Article, id=article_id)

            # Получаем IP-адрес клиента
            ip_address = request.META.get('REMOTE_ADDR')

            # Проверяем существование записи
            obj, created = self.model.objects.get_or_create(
                article=article,
                ip_address=ip_address
            )

            # Инициализируем список в сессии, если его нет
            if self.session_key not in request.session:
                request.session[self.session_key] = []

            # Если запись уже существует - удаляем
            if not created:
                obj.delete()
                is_active = False
                # Удаляем из сессии
                if article.id in request.session[self.session_key]:
                    request.session[self.session_key].remove(article.id)
                    request.session.modified = True
            else:
                is_active = True
                # Добавляем в сессию
                if article.id not in request.session[self.session_key]:
                    request.session[self.session_key].append(article.id)
                    request.session.modified = True

            # Получаем актуальное количество
            count = getattr(article, self.related_name).count()

            # Формируем ответ
            response_data = {
                self.response_field: is_active,
                self.count_field: count
            }

            return JsonResponse(response_data)

        except Exception as e:
            # Логируем возможные ошибки
            print(f"Ошибка при обработке toggle: {e}")
            return JsonResponse({'error': 'Произошла ошибка'}, status=400)


# 4. Переписать toggle_favorite на View
class ToggleFavoriteView(BaseToggleView):
    model = Favorite
    session_key = 'favorite_articles'
    response_field = 'is_favorite'
    count_field = 'favorites_count'
    related_name = 'favorites'


# 5. Переписать toggle_like на View
class ToggleLikeView(BaseToggleView):
    model = Like
    session_key = 'liked_articles'
    response_field = 'liked'
    count_field = 'likes_count'
    related_name = 'likes'


# 6. Переписать upload_json_view на FormView
class UploadJsonView(BaseMixin, FormView):
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

        # Создаем новые категории, если есть
        for category_name in validation_results['new_categories']:
            Category.objects.get_or_create(name=category_name)

        # Создаем новые теги, если есть
        for tag_name in validation_results['new_tags']:
            Tag.objects.get_or_create(name=tag_name)

        # Сохраняем данные в сессии для потокового редактирования
        self.request.session['json_articles'] = json_data
        self.request.session['current_article_index'] = 0
        self.request.session['total_articles'] = len(json_data)

        return super().form_valid(form)

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
        if not query:
            return Article.objects.none()

        # Создаем сложный запрос с использованием Q для поиска по заголовку и содержанию
        return super().get_queryset().filter(
            Q(title__icontains=query) | Q(content__icontains=query)
        )

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['query'] = self.request.GET.get('q', '')
        return context


# 8. Переписать favorites на ListView
class FavoriteNewsListView(BaseArticleListView):
    template_name = 'news/favorites.html'

    def get_queryset(self):
        # Получаем IP-адрес клиента
        ip_address = self.request.META.get('REMOTE_ADDR')

        # Получаем ID избранных статей
        favorite_articles = Favorite.objects.filter(
            ip_address=ip_address
        ).values_list('article_id', flat=True)

        # Получаем сами статьи
        return super().get_queryset().filter(id__in=favorite_articles)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['is_favorites_page'] = True
        return context


# Базовый класс для детального просмотра статей
class BaseArticleDetailView(BaseMixin, DetailView):
    """
    Базовый класс для детального просмотра статьи с инкрементом счетчика просмотров
    """
    model = Article
    template_name = 'news/article_detail.html'
    context_object_name = 'article'

    def get(self, request, *args, **kwargs):
        response = super().get(request, *args, **kwargs)
        # Увеличиваем количество просмотров
        article = self.get_object()
        article.views += 1
        article.save(update_fields=['views'])  # Оптимизация - обновляем только нужное поле
        return response


# 9. Переписать get_detail_article_by_slag на DetailView
class ArticleDetailBySlugView(BaseArticleDetailView):
    slug_url_kwarg = 'title'  # Используем 'title' как аргумент URL для slug


# Представление для детальной страницы статьи по ID
class ArticleDetailView(BaseArticleDetailView):
    pk_url_kwarg = 'article_id'

    def get(self, request, *args, **kwargs):
        response = super().get(request, *args, **kwargs)
        article = self.get_object()

        # Получаем IP-адрес клиента
        ip_address = request.META.get('REMOTE_ADDR')

        # Проверяем, лайкнул ли текущий IP эту статью
        is_liked = Like.objects.filter(article=article, ip_address=ip_address).exists()

        # Инициализируем список лайкнутых статей в сессии, если его нет
        if 'liked_articles' not in request.session:
            request.session['liked_articles'] = []

        # Обновляем список лайкнутых статей в сессии
        liked_articles = request.session['liked_articles']
        if is_liked and article.id not in liked_articles:
            liked_articles.append(article.id)
            request.session['liked_articles'] = liked_articles
            request.session.modified = True
        elif not is_liked and article.id in liked_articles:
            liked_articles.remove(article.id)
            request.session['liked_articles'] = liked_articles
            request.session.modified = True

        return response


# 10. Переписать add_article на CreateView
class ArticleCreateView(BaseMixin, CreateView):
    model = Article
    form_class = ArticleForm
    template_name = 'news/add_article.html'

    def form_valid(self, form):
        # Извлекаем валидированные данные из формы
        article = form.save(commit=False)
        article.views = 0
        article.status = Article.Status.UNCHECKED
        article.save()
        form.save_m2m()  # Сохраняем теги (many-to-many отношения)

        return redirect('news:detail_article_by_id', article_id=article.id)


# 11. Переписать article_update на UpdateView
class ArticleUpdateView(BaseMixin, UpdateView):
    model = Article
    form_class = ArticleForm
    template_name = 'news/edit_article.html'
    pk_url_kwarg = 'article_id'  # URL-параметр, содержащий ID статьи

    def get_success_url(self):
        return reverse_lazy('news:detail_article_by_id', kwargs={'article_id': self.object.id})


# 12. Переписать article_delete на DeleteView
class ArticleDeleteView(BaseMixin, DeleteView):
    model = Article
    template_name = 'news/delete_article.html'
    success_url = reverse_lazy('news:catalog')
    pk_url_kwarg = 'article_id'  # URL-параметр, содержащий ID статьи


# 13. Преобразуем функцию edit_article_from_json в класс
class EditArticleFromJsonView(BaseMixin, View):
    def get(self, request):
        # Проверяем, есть ли данные в сессии
        if 'json_articles' not in request.session:
            messages.error(request, 'Сначала загрузите JSON-файл с новостями')
            return redirect('news:upload_json')

        # Получаем данные из сессии
        json_articles = request.session['json_articles']
        current_index = request.session['current_article_index']
        total_articles = request.session['total_articles']

        # Получаем список проблем, если он доступен
        articles_with_issues = request.session.get('articles_with_issues', [])

        # Проверяем, не закончили ли мы
        if current_index >= total_articles:
            messages.success(request, 'Все статьи отредактированы')
            return redirect('news:save_articles_from_json')

        # Получаем текущую статью
        current_article = json_articles[current_index]

        # Проверяем, есть ли у текущей статьи проблемы
        current_article_issues = None
        for article_issue in articles_with_issues:
            if article_issue['index'] == current_index:
                current_article_issues = article_issue['missing_fields']
                break

        # Получаем категорию и теги для формы
        category_name = current_article.get('category', '')
        category = Category.objects.filter(name__iexact=category_name).first()
        article_tags = current_article.get('tags', [])

        context = {
            'article': current_article,
            'current_index': current_index,
            'total_articles': total_articles,
            'categories': Category.objects.all(),
            'tags': Tag.objects.all(),
            'selected_category': category,
            'selected_tags': article_tags,
            'categories_list': CategoryService.get_categories_with_count(),
            'missing_fields': current_article_issues
        }

        return render(request, 'news/edit_article_from_json.html', context)

    def post(self, request):
        # Проверяем, есть ли данные в сессии
        if 'json_articles' not in request.session:
            messages.error(request, 'Сначала загрузите JSON-файл с новостями')
            return redirect('news:upload_json')

        # Получаем данные из сессии
        json_articles = request.session['json_articles']
        current_index = request.session['current_article_index']
        total_articles = request.session['total_articles']

        # Получаем список проблем, если он доступен
        articles_with_issues = request.session.get('articles_with_issues', [])

        # Получаем текущую статью
        current_article = json_articles[current_index]

        # Проверяем, есть ли у текущей статьи проблемы
        current_article_issues = None
        for article_issue in articles_with_issues:
            if article_issue['index'] == current_index:
                current_article_issues = article_issue['missing_fields']
                break

        # Обрабатываем отправку формы
        # Обновляем данные статьи в сессии
        current_article['title'] = request.POST.get('title', '')
        current_article['content'] = request.POST.get('content', '')
        current_article['category'] = request.POST.get('category', '')

        # Обрабатываем теги
        selected_tags = []
        for tag in Tag.objects.all():
            if f'tag_{tag.id}' in request.POST:
                selected_tags.append(tag.name)
        current_article['tags'] = selected_tags

        # Обновляем сессию
        json_articles[current_index] = current_article
        request.session['json_articles'] = json_articles

        # Если у этой статьи были проблемы, проверяем, исправлены ли они
        if current_article_issues:
            still_missing = []
            if not current_article['title']:
                still_missing.append('title')
            if not current_article['content']:
                still_missing.append('content')

            # Если проблемы исправлены, обновляем список статей с проблемами
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

        # Обрабатываем кнопки навигации
        if 'next_article' in request.POST:
            request.session['current_article_index'] = current_index + 1
            return redirect('news:edit_article_from_json')
        elif 'save_all' in request.POST:
            return redirect('news:save_articles_from_json')

        # По умолчанию остаемся на текущей странице
        return redirect('news:edit_article_from_json')


# 14. Преобразуем функцию save_articles_from_json в класс
class SaveArticlesFromJsonView(View):
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
        saved_articles = 0

        for article_data in json_articles:
            try:
                # Пропускаем статьи с отсутствующими обязательными полями
                if not article_data.get('title') or not article_data.get('content'):
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

            except Exception as e:
                # Если что-то пошло не так, логируем ошибку
                print(f"Ошибка при сохранении статьи: {e}")
                continue

        # Очищаем сессию
        if 'json_articles' in request.session:
            del request.session['json_articles']
        if 'current_article_index' in request.session:
            del request.session['current_article_index']
        if 'total_articles' in request.session:
            del request.session['total_articles']
        if 'articles_with_issues' in request.session:
            del request.session['articles_with_issues']

        # Отображаем сообщение об успешном импорте
        messages.success(request, f'Успешно сохранено {saved_articles} статей')
        return redirect('news:catalog')