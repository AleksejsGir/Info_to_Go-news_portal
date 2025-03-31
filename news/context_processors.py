# news/context_processors.py
from django.contrib.auth import get_user_model
from django.core.cache import cache
from .models import Article, Category

from django.db.models import Count

def global_context(request):
    return {
        "users_count": get_user_model().objects.count(),
        "news_count": Article.objects.count(),
        "categories_list": cache.get_or_set(
            "categories",
            list(Category.objects.annotate(news_count=Count('article')).order_by('name')),
            60 * 15
        ),
        "menu": [
            {"title": "Главная", "url": "/", "url_name": "index"},
            {"title": "О проекте", "url": "/about/", "url_name": "about"},
            {"title": "Каталог", "url": "/news/catalog/", "url_name": "news:catalog"},
        ],
    }