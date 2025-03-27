# users/urls.py
from django.urls import path
from . import views
from allauth.account.views import LoginView, LogoutView, SignupView

app_name = 'users'  # Сохраняем пространство имен для обратной совместимости

urlpatterns = [
    # Ссылки на существующие URL-адреса с использованием наших представлений (для обратной совместимости)
    path('login/', views.LoginUser.as_view(), name='login'),
    path('logout/', views.LogoutUser.as_view(), name='logout'),
    path('signup/', views.RegisterUser.as_view(), name='signup'),
    path('register_done/', views.RegisterDoneView.as_view(), name='register_done'),

    # Добавляем маршрут для перехвата подтверждения email
    path('confirm-email/<str:key>/', views.CustomConfirmEmailView.as_view(), name='confirm_email'),
]