# news/urls.py
from django.urls import path
from . import views

app_name = 'news'  # Пространство имён 'news'

urlpatterns = [
    # Обновленные маршруты с CBV
    path('catalog/', views.CatalogListView.as_view(), name='catalog'),
    path('catalog/<int:article_id>/', views.ArticleDetailView.as_view(), name='detail_article_by_id'),
    path('catalog/category/<int:category_id>/', views.CategoryNewsListView.as_view(), name='news_by_category'),
    path('catalog/tag/<int:tag_id>/', views.TagNewsListView.as_view(), name='news_by_tag'),
    path('catalog/<slug:title>/', views.ArticleDetailBySlugView.as_view(), name='detail_article_by_title'),
    path('search/', views.SearchNewsView.as_view(), name='search_news'),

    # Маршруты для лайков и избранного
    path('toggle_like/<int:article_id>/', views.ToggleLikeView.as_view(), name='toggle_like'),
    path('toggle_favorite/<int:article_id>/', views.ToggleFavoriteView.as_view(), name='toggle_favorite'),
    path('favorites/', views.FavoriteNewsListView.as_view(), name='favorite_news'),
    path('comment/like/<int:comment_id>/', views.CommentLikeView.as_view(), name='comment_like'),

    # Маршрут для добавления статьи
    path('add/', views.ArticleCreateView.as_view(), name='add_article'),

    # Маршруты для редактирования и удаления статей
    path('edit/<int:article_id>/', views.ArticleUpdateView.as_view(), name='article_update'),
    path('delete/<int:article_id>/', views.ArticleDeleteView.as_view(), name='article_delete'),

    # Маршруты для загрузки JSON
    path('upload_json/', views.UploadJsonView.as_view(), name='upload_json'),
    path('edit_json_article/', views.EditArticleFromJsonView.as_view(), name='edit_article_from_json'),
    path('save_json_articles/', views.SaveArticlesFromJsonView.as_view(), name='save_articles_from_json'),
]