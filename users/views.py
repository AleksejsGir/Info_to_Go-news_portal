# users/views.py
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.views import LoginView
from django.http import HttpResponse
from django.shortcuts import redirect
from django.urls import reverse_lazy

from .forms import CustomAuthenticationForm
from news.views import BaseMixin


class LoginUser(BaseMixin, LoginView):
    """
    Представление для входа пользователя в систему.
    Использует стандартное Django-представление LoginView с нашими настройками.
    """
    form_class = CustomAuthenticationForm  # Используем нашу кастомную форму
    template_name = 'users/login.html'  # Путь к шаблону страницы входа
    redirect_field_name = 'next'  # Параметр для перенаправления после успешного входа

    def get_success_url(self):
        """Определяет URL для перенаправления после успешного входа"""
        # Проверяем, есть ли параметр 'next' в запросе
        next_url = self.request.POST.get('next', '')
        if next_url and next_url.strip():
            return next_url
        # Если параметра 'next' нет, перенаправляем в каталог новостей
        return reverse_lazy('news:catalog')


def logout_user(request):
    """
    Представление для выхода пользователя из системы.
    """
    logout(request)  # Выполняем выход
    return redirect('users:login')  # Перенаправляем на страницу входа


def sign_up(request):
    """
    Заглушка для представления регистрации (пока не реализовано).
    """
    return HttpResponse('Регистрация будет доступна в следующей версии!')