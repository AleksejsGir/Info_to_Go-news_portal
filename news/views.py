from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, get_object_or_404
from django.db.models import Count, Q
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_protect

from .models import Article, Tag, Category, Like  # Добавляем импорт модели Like

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


@csrf_protect  # Защита от межсайтовой подделки запросов
@require_POST  # Разрешаем только POST-запросы
def toggle_like(request, article_id):
    """
    Обработчик для добавления/удаления лайка

    Логика:
    1. Получаем статью по ID
    2. Определяем IP-адрес пользователя
    3. Проверяем существование лайка
    4. Добавляем или удаляем лайк
    5. Возвращаем JSON с результатом
    """
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


# Функция для получения данных о категориях с подсчетом новостей
def get_categories_with_count():
    return Category.objects.annotate(news_count=Count('article')).order_by('name')


def main(request):
    """
    Представление рендерит шаблон main.html
    """
    # Используем синтаксис, с распаковкой словаря
    context = {**info, 'categories_list': get_categories_with_count()}
    return render(request, 'main.html', context=context)


def about(request):
    """Представление рендерит шаблон about.html"""
    context = {**info, 'categories_list': get_categories_with_count()}
    return render(request, 'about.html', context=context)


def catalog(request):
    return HttpResponse('Каталог новостей')


def get_categories(request):
    """
    Возвращает все категории для представления в каталоге
    """
    return HttpResponse('All categories')


def get_news_by_category(request, category_id):
    """
    Возвращает новости по категории для представления в каталоге
    """
    # Получаем категорию по ID
    category = get_object_or_404(Category, id=category_id)

    # Фильтруем статьи по категории
    articles = Article.objects.select_related('category').prefetch_related('tags').filter(category=category)

    # Добавляем пагинацию - 15 новостей на странице
    paginator = Paginator(articles, 12)
    page = request.GET.get('page')

    try:
        paginated_news = paginator.page(page)
    except PageNotAnInteger:
        # Если параметр page не является числом, выводим первую страницу
        paginated_news = paginator.page(1)
    except EmptyPage:
        # Если страница выходит за пределы доступных, выводим последнюю
        paginated_news = paginator.page(paginator.num_pages)

    # Используем синтаксис для создания контекста
    context = {**info,
               'news': paginated_news,
               'news_count': len(articles),  # len() вместо count()
               'current_category': category,
               'categories_list': get_categories_with_count(),
               }

    return render(request, 'news/catalog.html', context=context)


def get_news_by_tag(request, tag_id):
    """
    Возвращает новости по тегу для представления в каталоге
    """
    # Получаем тег по ID
    tag = get_object_or_404(Tag, id=tag_id)

    # Фильтруем статьи по тегу
    articles = Article.objects.select_related('category').prefetch_related('tags').filter(tags=tag)

    # Добавляем пагинацию - 15 новостей на странице
    paginator = Paginator(articles, 12)
    page = request.GET.get('page')

    try:
        paginated_news = paginator.page(page)
    except PageNotAnInteger:
        # Если параметр page не является числом, выводим первую страницу
        paginated_news = paginator.page(1)
    except EmptyPage:
        # Если страница выходит за пределы доступных, выводим последнюю
        paginated_news = paginator.page(paginator.num_pages)

    # Используем синтаксис для создания контекста
    context = {**info,
               'news': paginated_news,
               'news_count': len(articles),
               'current_tag': tag,
               'categories_list': get_categories_with_count(),
               }

    return render(request, 'news/catalog.html', context=context)


def get_category_by_name(request, slug):
    return HttpResponse(f"Категория {slug}")


def get_all_news(request):
    """Функция для отображения страницы "Каталог"
    будет возвращать рендер шаблона /templates/news/catalog.html
    - **`sort`** - ключ для указания типа сортировки с возможными значениями: `publication_date`, `views`.
    - **`order`** - опциональный ключ для указания направления сортировки с возможными значениями: `asc`, `desc`. По умолчанию `desc`.
    1. Сортировка по дате добавления в убывающем порядке (по умолчанию): `/news/catalog/`
    2. Сортировка по количеству просмотров в убывающем порядке: `/news/catalog/?sort=views`
    3. Сортировка по количеству просмотров в возрастающем порядке: `/news/catalog/?sort=views&order=asc`
    4. Сортировка по дате добавления в возрастающем порядке: `/news/catalog/?sort=publication_date&order=asc`
    """
    # считаем параметры из GET-запроса
    sort = request.GET.get('sort', 'publication_date')  # по умолчанию сортируем по дате загрузки
    order = request.GET.get('order', 'desc')  # по умолчанию сортируем по убыванию

    # Проверяем дали ли мы разрешение на сортировку по этому полю
    valid_sort_fields = {'publication_date', 'views'}
    if sort not in valid_sort_fields:
        sort = 'publication_date'

    # Обрабатываем направление сортировки
    if order == 'asc':
        order_by = sort
    else:
        order_by = f'-{sort}'

    articles = Article.objects.select_related('category').prefetch_related('tags').order_by(order_by)

    # Добавляем пагинацию - 12 новостей на странице
    paginator = Paginator(articles, 12)
    page = request.GET.get('page')

    try:
        paginated_news = paginator.page(page)
    except PageNotAnInteger:
        # Если параметр page не является числом, выводим первую страницу
        paginated_news = paginator.page(1)
    except EmptyPage:
        # Если страница выходит за пределы доступных, выводим последнюю
        paginated_news = paginator.page(paginator.num_pages)

    context = {**info,
               'news': paginated_news,
               'news_count': len(articles),
               'categories_list': get_categories_with_count(),
               }

    return render(request, 'news/catalog.html', context=context)


def get_detail_article_by_id(request, article_id):
    """
    Возвращает детальную информацию по новости для представления
    с увеличением счетчика просмотров

    Логика работы:
    1. Получаем статью по ID
    2. Увеличиваем количество просмотров на 1
    3. Сохраняем изменения в базе данных
    4. Передаем статью в контекст шаблона
    """
    # Получаем статью по ID
    article = get_object_or_404(Article, id=article_id)

    # Увеличиваем количество просмотров
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

    # Формируем контекст для шаблона
    context = {**info,
               'article': article,
               'categories_list': get_categories_with_count(),
               }

    return render(request, 'news/article_detail.html', context=context)


def get_detail_article_by_title(request, title):
    """
    Возвращает детальную информацию по новости для представления
    """
    article = get_object_or_404(Article, slug=title)
    context = {**info,
               'article': article,
               'categories_list': get_categories_with_count(),
               }
    return render(request, 'news/article_detail.html', context=context)


def search_news(request):
    """
    Представление для поиска новостей по заголовку и содержанию.

    Параметры:
    - Принимает GET-запрос с параметром 'q' для поиска
    - Использует Q-объект для поиска по заголовку и содержанию
    - Применяет постраничную навигацию (12 новостей на странице)
    """
    # Получаем поисковый запрос из GET-параметров
    query = request.GET.get('q', '')

    # Если запрос пустой, возвращаем пустой список
    if not query:
        context = {**info,
                   'news': [],
                   'query': query,
                   'categories_list': get_categories_with_count(),
                   'news_count': 0}
        return render(request, 'news/search_results.html', context)

    # Создаем сложный запрос с использованием Q для поиска по заголовку и содержанию
    articles = Article.objects.select_related('category').prefetch_related('tags').filter(
        Q(title__icontains=query) | Q(content__icontains=query)
    )

    paginator = Paginator(articles, 12)
    page = request.GET.get('page')

    try:
        paginated_news = paginator.page(page)
    except PageNotAnInteger:
        # Если параметр page не является числом, выводим первую страницу
        paginated_news = paginator.page(1)
    except EmptyPage:
        # Если страница выходит за пределы доступных, выводим последнюю
        paginated_news = paginator.page(paginator.num_pages)

    # Формируем контекст для шаблона
    context = {**info,
               'news': paginated_news,
               'query': query,
               'news_count': len(articles),
               'categories_list': get_categories_with_count(),
               }

    return render(request, 'news/search_results.html', context)