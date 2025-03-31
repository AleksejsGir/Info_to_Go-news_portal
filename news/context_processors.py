# news/context_processors.py
from django.contrib.auth import get_user_model
from django.core.cache import cache
from .models import Article, Category

def global_context(request):
    """
    Возвращает словарь с глобальным контекстом для всех шаблонов.
    - users_count: количество пользователей
    - news_count: количество статей
    - categories_list: список категорий (кэшируется на 15 минут)
    - menu: навигационное меню
    """
    return {
        "users_count": get_user_model().objects.count(),
        "news_count": Article.objects.count(),
        "categories_list": cache.get_or_set("categories", list(Category.objects.all()), 60 * 15),
        "menu": [
            {"title": "Главная", "url": "/", "url_name": "index"},
            {"title": "О проекте", "url": "/about/", "url_name": "about"},
            {"title": "Каталог", "url": "/news/catalog/", "url_name": "news:catalog"},
            # При необходимости добавьте другие пункты меню
        ],
    }