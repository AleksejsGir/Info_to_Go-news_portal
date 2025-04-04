# users/urls.py
from django.urls import path
from . import views

app_name = 'users'

urlpatterns = [
    # Страницы профиля
    path('profile/', views.ProfileView.as_view(), name='profile'),
    path('profile/articles/', views.UserArticlesView.as_view(), name='profile_articles'),
    path('profile/activity/', views.UserActivityView.as_view(), name='profile_activity'),
    path('profile/update/', views.ProfileUpdateView.as_view(), name='profile_update'),
]