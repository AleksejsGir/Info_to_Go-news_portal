# news/urls.py
from django.urls import path
from . import views

app_name = 'news'  # Пространство имён 'news'

# Маршруты с префиксом /news/
urlpatterns = [
    # Существующие маршруты
    path('catalog/', views.get_all_news, name='catalog'),
    path('catalog/<int:article_id>/', views.get_detail_article_by_id, name='detail_article_by_id'),
    path('catalog/category/<int:category_id>/', views.get_news_by_category, name='news_by_category'),
    path('catalog/tag/<int:tag_id>/', views.get_news_by_tag, name='news_by_tag'),
    path('catalog/<slug:title>/', views.get_detail_article_by_title, name='detail_article_by_title'),

    # Новый маршрут для поиска новостей
    path('search/', views.search_news, name='search_news'),
]