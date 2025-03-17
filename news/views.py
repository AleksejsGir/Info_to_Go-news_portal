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
from django.urls import reverse_lazy

from .models import Article, Tag, Category, Like, Favorite
from .forms import ArticleForm, ArticleUploadForm
from django.contrib import messages

"""
Информация в шаблоны будет браться из базы данных
Но пока, мы сделаем переменные, куда будем записывать информацию, которая пойдет в 
контекст шаблона
"""
# Пример данных для новостей
info = {
    "users_count": 5,
    "news_count": 10,
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
}


# Создаем миксин для добавления навигационного меню во все представления
class MenuMixin:
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context.update({
            "users_count": 5,
            "news_count": 10,
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
            'categories_list': get_categories_with_count(),
        })
        return context


# Функция для получения данных о категориях с подсчетом новостей
def get_categories_with_count():
    return Category.objects.annotate(news_count=Count('article')).order_by('name')


# 1. Переписать about на TemplateView
class AboutView(MenuMixin, TemplateView):
    template_name = 'about.html'


# Также добавим представление для главной страницы
class MainView(MenuMixin, TemplateView):
    template_name = 'main.html'


# Представление для отображения всех новостей (каталог)
class CatalogListView(MenuMixin, ListView):
    template_name = 'news/catalog.html'
    context_object_name = 'news'
    paginate_by = 8

    def get_queryset(self):
        # Считаем параметры из GET-запроса
        sort = self.request.GET.get('sort', 'publication_date')  # по умолчанию сортируем по дате загрузки
        order = self.request.GET.get('order', 'desc')  # по умолчанию сортируем по убыванию

        # Проверяем дали ли мы разрешение на сортировку по этому полю
        valid_sort_fields = {'publication_date', 'views'}
        if sort not in valid_sort_fields:
            sort = 'publication_date'

        # Обрабатываем направление сортировки
        if order == 'asc':
            order_by = sort
        else:
            order_by = f'-{sort}'

        return Article.objects.select_related('category').prefetch_related('tags').order_by(order_by)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['news_count'] = self.get_queryset().count()
        return context


# 2. Переписать get_news_by_category на ListView
class CategoryNewsListView(MenuMixin, ListView):
    template_name = 'news/catalog.html'
    context_object_name = 'news'
    paginate_by = 8

    def get_queryset(self):
        self.category = get_object_or_404(Category, id=self.kwargs['category_id'])
        return Article.objects.select_related('category').prefetch_related('tags').filter(category=self.category)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['current_category'] = self.category
        context['news_count'] = self.get_queryset().count()
        return context


# 3. Переписать get_news_by_tag на ListView
class TagNewsListView(MenuMixin, ListView):
    template_name = 'news/catalog.html'
    context_object_name = 'news'
    paginate_by = 8

    def get_queryset(self):
        self.tag = get_object_or_404(Tag, id=self.kwargs['tag_id'])
        return Article.objects.select_related('category').prefetch_related('tags').filter(tags=self.tag)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['current_tag'] = self.tag
        context['news_count'] = self.get_queryset().count()
        return context


# 4. Переписать toggle_favorite на View
class ToggleFavoriteView(View):
    @method_decorator(csrf_protect)
    def post(self, request, article_id):
        try:
            # Получаем статью или возвращаем 404
            article = get_object_or_404(Article, id=article_id)

            # Получаем IP-адрес клиента
            ip_address = request.META.get('REMOTE_ADDR')

            # Проверяем существование в избранном
            favorite, created = Favorite.objects.get_or_create(
                article=article,
                ip_address=ip_address
            )

            # Инициализируем список избранных статей, если его нет
            if 'favorite_articles' not in request.session:
                request.session['favorite_articles'] = []

            # Если статья уже в избранном - удаляем
            if not created:
                favorite.delete()
                is_favorite = False
                # Удаляем из сессии
                if article.id in request.session['favorite_articles']:
                    request.session['favorite_articles'].remove(article.id)
                    request.session.modified = True
            else:
                is_favorite = True
                # Добавляем в сессию
                if article.id not in request.session['favorite_articles']:
                    request.session['favorite_articles'].append(article.id)
                    request.session.modified = True

            # Получаем актуальное количество добавлений в избранное
            favorites_count = article.favorites.count()

            return JsonResponse({
                'is_favorite': is_favorite,
                'favorites_count': favorites_count
            })

        except Exception as e:
            # Логируем возможные ошибки
            print(f"Ошибка при обработке добавления в избранное: {e}")
            return JsonResponse({'error': 'Произошла ошибка'}, status=400)


# 5. Переписать toggle_like на View
class ToggleLikeView(View):
    @method_decorator(csrf_protect)
    def post(self, request, article_id):
        try:
            # Получаем статью или возвращаем 404
            article = get_object_or_404(Article, id=article_id)

            # Получаем IP-адрес клиента
            ip_address = request.META.get('REMOTE_ADDR')

            # Проверяем существование лайка
            like, created = Like.objects.get_or_create(
                article=article,
                ip_address=ip_address
            )

            # Инициализируем список лайкнутых статей, если его нет
            if 'liked_articles' not in request.session:
                request.session['liked_articles'] = []

            # Если лайк уже существует - удаляем
            if not created:
                like.delete()
                liked = False

                # Удаляем из сессии, если статья была в списке лайкнутых
                if article.id in request.session['liked_articles']:
                    request.session['liked_articles'].remove(article.id)
                    request.session.modified = True
            else:
                liked = True

                # Добавляем в сессию, если статьи не было в списке лайкнутых
                if article.id not in request.session['liked_articles']:
                    request.session['liked_articles'].append(article.id)
                    request.session.modified = True

            # Получаем актуальное количество лайков
            likes_count = article.likes.count()

            return JsonResponse({
                'liked': liked,
                'likes_count': likes_count
            })

        except Exception as e:
            # Логируем возможные ошибки
            print(f"Ошибка при обработке лайка: {e}")
            return JsonResponse({'error': 'Произошла ошибка'}, status=400)


# 6. Переписать upload_json_view на FormView
class UploadJsonView(MenuMixin, FormView):
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
class SearchNewsView(MenuMixin, ListView):
    template_name = 'news/search_results.html'
    context_object_name = 'news'
    paginate_by = 8

    def get_queryset(self):
        query = self.request.GET.get('q', '')
        if not query:
            return Article.objects.none()

        # Создаем сложный запрос с использованием Q для поиска по заголовку и содержанию
        return Article.objects.select_related('category').prefetch_related('tags').filter(
            Q(title__icontains=query) | Q(content__icontains=query)
        )

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['query'] = self.request.GET.get('q', '')
        context['news_count'] = self.get_queryset().count()
        return context


# 8. Переписать favorites на ListView
class FavoriteNewsListView(MenuMixin, ListView):
    template_name = 'news/favorites.html'
    context_object_name = 'news'
    paginate_by = 8

    def get_queryset(self):
        # Получаем IP-адрес клиента
        ip_address = self.request.META.get('REMOTE_ADDR')

        # Получаем ID избранных статей
        favorite_articles = Favorite.objects.filter(
            ip_address=ip_address
        ).values_list('article_id', flat=True)

        # Получаем сами статьи
        return Article.objects.select_related('category').prefetch_related('tags').filter(
            id__in=favorite_articles
        )

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['news_count'] = self.get_queryset().count()
        context['is_favorites_page'] = True
        return context


# 9. Переписать get_detail_article_by_slag на DetailView
class ArticleDetailBySlugView(MenuMixin, DetailView):
    model = Article
    template_name = 'news/article_detail.html'
    context_object_name = 'article'
    slug_url_kwarg = 'title'  # Используем 'title' как аргумент URL для slug

    def get(self, request, *args, **kwargs):
        response = super().get(request, *args, **kwargs)
        # Увеличиваем количество просмотров
        article = self.get_object()
        article.views += 1
        article.save()

        return response


# Представление для детальной страницы статьи по ID
class ArticleDetailView(MenuMixin, DetailView):
    model = Article
    template_name = 'news/article_detail.html'
    context_object_name = 'article'
    pk_url_kwarg = 'article_id'

    def get(self, request, *args, **kwargs):
        response = super().get(request, *args, **kwargs)
        # Увеличиваем количество просмотров
        article = self.get_object()
        article.views += 1
        article.save()

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
class ArticleCreateView(MenuMixin, CreateView):
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
class ArticleUpdateView(MenuMixin, UpdateView):
    model = Article
    form_class = ArticleForm
    template_name = 'news/edit_article.html'
    pk_url_kwarg = 'article_id'  # URL-параметр, содержащий ID статьи

    def get_success_url(self):
        return reverse_lazy('news:detail_article_by_id', kwargs={'article_id': self.object.id})


# 12. Переписать article_delete на DeleteView
class ArticleDeleteView(MenuMixin, DeleteView):
    model = Article
    template_name = 'news/delete_article.html'
    success_url = reverse_lazy('news:catalog')
    pk_url_kwarg = 'article_id'  # URL-параметр, содержащий ID статьи


# Оставляем функцию catalog без изменений, так как она будет заменена CatalogListView
def catalog(request):
    return HttpResponse('Каталог новостей')


# Оставляем функцию get_categories без изменений, так как она может использоваться где-то еще
def get_categories(request):
    """
    Возвращает все категории для представления в каталоге
    """
    return HttpResponse('All categories')


def get_category_by_name(request, slug):
    return HttpResponse(f"Категория {slug}")


# Оставляем функции для работы с JSON без изменений, так как они более сложные
def edit_article_from_json(request):
    """
    Позволяет редактировать статьи из JSON, включая исправление отсутствующих обязательных полей
    """
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

    if request.method == 'POST':
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

    # Получаем категорию и теги для формы
    category_name = current_article.get('category', '')
    category = Category.objects.filter(name__iexact=category_name).first()
    article_tags = current_article.get('tags', [])

    context = {
        **info,
        'article': current_article,
        'current_index': current_index,
        'total_articles': total_articles,
        'categories': Category.objects.all(),
        'tags': Tag.objects.all(),
        'selected_category': category,
        'selected_tags': article_tags,
        'categories_list': get_categories_with_count(),
        'missing_fields': current_article_issues
    }

    return render(request, 'news/edit_article_from_json.html', context)


def save_articles_from_json(request):
    """
    Представление для сохранения всех отредактированных статей из JSON

    Логика:
    1. Получаем данные из сессии
    2. Сохраняем каждую статью в базу данных
    3. Очищаем сессию
    4. Перенаправляем на страницу каталога
    """
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


# # Эти функции сохраняем для обратной совместимости, чтобы не было ошибок
# def main(request):
#     return MainView.as_view()(request)
#
#
# def about(request):
#     return AboutView.as_view()(request)
#
#
# def get_all_news(request):
#     return CatalogListView.as_view()(request)
#
#
# def get_news_by_category(request, category_id):
#     return CategoryNewsListView.as_view()(request, category_id=category_id)
#
#
# def get_news_by_tag(request, tag_id):
#     return TagNewsListView.as_view()(request, tag_id=tag_id)
#
#
# def toggle_favorite(request, article_id):
#     return ToggleFavoriteView.as_view()(request, article_id=article_id)
#
#
# def toggle_like(request, article_id):
#     return ToggleLikeView.as_view()(request, article_id=article_id)
#
#
# def get_favorite_news(request):
#     return FavoriteNewsListView.as_view()(request)
#
#
# def get_detail_article_by_id(request, article_id):
#     return ArticleDetailView.as_view()(request, article_id=article_id)
#
#
# def get_detail_article_by_title(request, title):
#     return ArticleDetailBySlugView.as_view()(request, title=title)
#
#
# def search_news(request):
#     return SearchNewsView.as_view()(request)
#
#
# def add_article(request):
#     return ArticleCreateView.as_view()(request)
#
#
# def article_update(request, article_id):
#     return ArticleUpdateView.as_view()(request, article_id=article_id)
#
#
# def article_delete(request, article_id):
#     return ArticleDeleteView.as_view()(request, article_id=article_id)
#
#
# def upload_json_view(request):
#     return UploadJsonView.as_view()(request)