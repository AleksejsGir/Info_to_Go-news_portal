# news/urls.py
from django.urls import path
from . import views

app_name = 'news'  # Пространство имён 'news'

urlpatterns = [
    # Существующие маршруты
    path('catalog/', views.get_all_news, name='catalog'),
    path('catalog/<int:article_id>/', views.get_detail_article_by_id, name='detail_article_by_id'),
    path('catalog/category/<int:category_id>/', views.get_news_by_category, name='news_by_category'),
    path('catalog/tag/<int:tag_id>/', views.get_news_by_tag, name='news_by_tag'),
    path('catalog/<slug:title>/', views.get_detail_article_by_title, name='detail_article_by_title'),
    path('search/', views.search_news, name='search_news'),

    # Существующие маршруты для лайков и избранного
    path('toggle_like/<int:article_id>/', views.toggle_like, name='toggle_like'),
    path('toggle_favorite/<int:article_id>/', views.toggle_favorite, name='toggle_favorite'),
    path('favorites/', views.get_favorite_news, name='favorite_news'),

    # Маршрут для добавления статьи
    path('add/', views.add_article, name='add_article'),

    # Новые маршруты для редактирования и удаления статей
    path('edit/<int:article_id>/', views.article_update, name='article_update'),
    path('delete/<int:article_id>/', views.article_delete, name='article_delete'),

    # Маршруты для загрузки JSON
    path('upload_json/', views.upload_json_view, name='upload_json'),
    path('edit_json_article/', views.edit_article_from_json, name='edit_article_from_json'),
    path('save_json_articles/', views.save_articles_from_json, name='save_articles_from_json'),
]