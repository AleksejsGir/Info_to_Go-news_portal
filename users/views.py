# users/views.py
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.views import LoginView, LogoutView
from django.http import HttpResponse
from django.shortcuts import redirect
from django.urls import reverse_lazy
from django.views.generic import CreateView, TemplateView
from allauth.account.views import ConfirmEmailView

from .forms import CustomAuthenticationForm, RegisterUserForm
from news.views import BaseMixin

# Оставляем существующие представления для обратной совместимости
class LoginUser(BaseMixin, LoginView):
    """
    Представление для входа пользователя в систему.
    Использует стандартное Django-представление LoginView с нашими настройками.
    """
    form_class = CustomAuthenticationForm
    template_name = 'users/login.html'
    redirect_field_name = 'next'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['hide_sidebar'] = True
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
    next_page = reverse_lazy('account_login')  # Перенаправляем на URL allauth

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

# Добавляем новое представление для django-allauth
class CustomConfirmEmailView(ConfirmEmailView):
    """
    Кастомное представление для обработки подтверждения email.
    Перенаправляет на страницу входа, если email уже подтвержден.
    """
    def get(self, *args, **kwargs):
        response = super().get(*args, **kwargs)
        # Проверяем, есть ли подтвержденные email у пользователя
        if hasattr(self, 'object') and self.object.emailaddress_set.filter(verified=True).exists():
            return redirect('account_login')  # Редирект на страницу входа
        return response  # Возвращаем стандартный ответ