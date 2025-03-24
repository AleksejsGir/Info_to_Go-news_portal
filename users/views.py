# users/views.py
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.views import LoginView, LogoutView
from django.http import HttpResponse
from django.shortcuts import redirect
from django.urls import reverse_lazy
from django.views.generic import CreateView, TemplateView

from .forms import CustomAuthenticationForm, RegisterUserForm
from news.views import BaseMixin


class LoginUser(BaseMixin, LoginView):
    """
    Представление для входа пользователя в систему.
    Использует стандартное Django-представление LoginView с нашими настройками.
    """
    form_class = CustomAuthenticationForm  # Используем нашу кастомную форму
    template_name = 'users/login.html'  # Путь к шаблону страницы входа
    redirect_field_name = 'next'  # Параметр для перенаправления после успешного входа

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['hide_sidebar'] = True  # Скрываем сайдбар
        return context

    def get_success_url(self):
        """Определяет URL для перенаправления после успешного входа"""
        # Проверяем, есть ли параметр 'next' в запросе
        next_url = self.request.POST.get('next', '')
        if next_url and next_url.strip():
            return next_url
        # Если параметра 'next' нет, перенаправляем в каталог новостей
        return reverse_lazy('news:catalog')


class LogoutUser(LogoutView):
    """
    Представление для выхода пользователя из системы.
    Использует стандартное Django-представление LogoutView с указанием страницы перенаправления.
    """
    next_page = reverse_lazy('users:login')


class RegisterUser(CreateView):
    """
    Представление для регистрации новых пользователей.
    """
    form_class = RegisterUserForm
    template_name = 'users/register.html'
    success_url = reverse_lazy('users:register_done')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context.update({
            'title': 'Регистрация',
            'hide_sidebar': True
        })
        return context


class RegisterDoneView(BaseMixin, TemplateView):
    """
    Представление для отображения страницы успешной регистрации.
    """
    template_name = 'users/register_done.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['title'] = 'Регистрация завершена'
        context['hide_sidebar'] = True
        return context