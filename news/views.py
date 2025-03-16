from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, get_object_or_404, redirect
from django.db.models import Count, Q
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_protect

from .models import Article, Tag, Category, Like, Favorite  # Добавляем импорт модели Like

from .forms import ArticleForm

from django.contrib import messages
from .forms import ArticleUploadForm

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
                    05.03.2025
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


@csrf_protect  # Защита от межсайтовой подделки запросов
@require_POST  # Разрешаем только POST-запросы
def toggle_favorite(request, article_id):
    """
                    06.03.2025
    Обработчик для добавления/удаления статьи из избранного

    Логика:
    1. Получаем статью по ID
    2. Определяем IP-адрес пользователя
    3. Проверяем существование статьи в избранном
    4. Добавляем или удаляем из избранного
    5. Возвращаем JSON с результатом
    """
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

            # Удаляем из сессии, если статья была в списке избранных
            if article.id in request.session['favorite_articles']:
                request.session['favorite_articles'].remove(article.id)
                request.session.modified = True
        else:
            is_favorite = True

            # Добавляем в сессию, если статьи не было в списке избранных
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


def get_favorite_news(request):
    """
                    06.03.2025
    Представление для отображения избранных новостей пользователя

    Логика:
    1. Получаем IP-адрес пользователя
    2. Фильтруем избранные статьи по IP
    3. Возвращаем страницу с избранными статьями
    """
    # Получаем IP-адрес клиента
    ip_address = request.META.get('REMOTE_ADDR')

    # Получаем ID избранных статей
    favorite_articles = Favorite.objects.filter(
        ip_address=ip_address
    ).values_list('article_id', flat=True)

    # Получаем сами статьи
    articles = Article.objects.select_related('category').prefetch_related('tags').filter(
        id__in=favorite_articles
    )

    # Добавляем пагинацию - 9 новостей на странице
    paginator = Paginator(articles, 8)
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
               'is_favorites_page': True,
               }

    return render(request, 'news/favorites.html', context=context)


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

    # Добавляем пагинацию - 9 новостей на странице
    paginator = Paginator(articles, 8)
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

    # Добавляем пагинацию - 9 новостей на странице
    paginator = Paginator(articles, 8)
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

    # Добавляем пагинацию - 9 новостей на странице
    paginator = Paginator(articles, 8)
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

    paginator = Paginator(articles, 8)
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


def add_article(request):
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():
            # Извлекаем валидированные данные
            title = form.cleaned_data['title']
            content = form.cleaned_data['content']
            category = form.cleaned_data['category']
            tags = form.cleaned_data['tags']

            # Создаем объект статьи
            article = Article(
                title=title,
                content=content,
                category=category,
                views=0,
                status=Article.Status.UNCHECKED
            )

            # Сохраняем статью
            article.save()

            # Добавляем теги к статье
            article.tags.set(tags)

            return redirect('news:detail_article_by_id', article_id=article.id)
    else:
        form = ArticleForm()

    context = {
        **info,
        'form': form,
        'categories_list': get_categories_with_count(),
    }

    return render(request, 'news/add_article.html', context=context)


def article_update(request, article_id):
    # Получаем статью или возвращаем 404
    article = get_object_or_404(Article, id=article_id)

    if request.method == 'POST':
        # Создаем форму с данными из POST-запроса и FILES
        form = ArticleForm(request.POST, request.FILES, instance=article)
        if form.is_valid():
            # Сохраняем изменения
            form.save()
            return redirect('news:detail_article_by_id', article_id=article.id)
    else:
        # Создаем форму с текущими данными статьи
        form = ArticleForm(instance=article)

    context = {
        **info,
        'form': form,
        'article': article,
        'categories_list': get_categories_with_count(),
    }
    return render(request, 'news/edit_article.html', context)


def article_delete(request, article_id):
    # Получаем статью или возвращаем 404
    article = get_object_or_404(Article, id=article_id)

    if request.method == 'POST':
        # Удаляем статью
        article.delete()
        return redirect('news:catalog')

    context = {
        **info,
        'article': article,
        'categories_list': get_categories_with_count(),
    }
    return render(request, 'news/delete_article.html', context)


def upload_json_view(request):
    """
    Представление для загрузки JSON-файла с новостями

    Логика:
    1. Если GET-запрос - отображаем форму
    2. Если POST-запрос - обрабатываем форму:
       - Валидируем JSON-файл
       - Если есть новые категории/теги, показываем предупреждение
       - Если пользователь подтверждает создание новых категорий/тегов,
         сохраняем JSON-данные в сессии и перенаправляем на редактирование
    """
    if request.method == 'POST':
        form = ArticleUploadForm(request.POST, request.FILES)

        if form.is_valid():
            # Получаем данные, которые мы сохранили в форме
            json_data = form.json_data
            validation_results = form.validation_results

            # Сохраняем список статей с проблемами в сессии
            if hasattr(form, 'articles_with_issues'):
                request.session['articles_with_issues'] = form.articles_with_issues

            # Проверяем, есть ли новые категории или теги
            has_new_items = validation_results['new_categories'] or validation_results['new_tags']

            # Если есть новые элементы и пользователь не подтвердил их создание,
            # показываем предупреждение
            if has_new_items and 'confirm' not in request.POST:
                context = {
                    **info,
                    'form': form,
                    'validation_results': validation_results,
                    'categories_list': get_categories_with_count(),
                }
                return render(request, 'news/upload_json.html', context)

            # Если пользователь подтвердил или нет новых элементов, сохраняем данные в сессии

            # Создаем новые категории, если есть
            for category_name in validation_results['new_categories']:
                Category.objects.get_or_create(name=category_name)

            # Создаем новые теги, если есть
            for tag_name in validation_results['new_tags']:
                Tag.objects.get_or_create(name=tag_name)

            # Сохраняем данные в сессии для потокового редактирования
            request.session['json_articles'] = json_data
            request.session['current_article_index'] = 0
            request.session['total_articles'] = len(json_data)

            # Перенаправляем на редактирование первой статьи
            return redirect('news:edit_article_from_json')

    else:
        form = ArticleUploadForm()

    context = {
        **info,
        'form': form,
        'categories_list': get_categories_with_count(),
    }

    return render(request, 'news/upload_json.html', context)


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