# users/views.py
from django.shortcuts import redirect, render
from django.urls import reverse_lazy
from django.views.generic import TemplateView, ListView, UpdateView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib import messages
from news.models import Article
from .forms import ProfileUpdateForm, UserUpdateForm
from .models import Profile


class ProfileView(LoginRequiredMixin, TemplateView):
    """
    Представление для отображения информации о пользователе.
    """
    template_name = 'users/profile.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['active_tab'] = 'profile'

        # Проверяем и создаем профиль, если его нет
        profile, created = Profile.objects.get_or_create(user=self.request.user)

        return context


class UserArticlesView(LoginRequiredMixin, ListView):
    """
    Представление для отображения статей пользователя.
    """
    template_name = 'users/profile_articles.html'
    context_object_name = 'articles'
    paginate_by = 10

    def get_queryset(self):
        return Article.objects.filter(author=self.request.user).order_by('-publication_date')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['active_tab'] = 'articles'
        return context


class UserActivityView(LoginRequiredMixin, TemplateView):
    """
    Представление для отображения истории действий пользователя.
    Используется заглушка вместо реальной истории действий.
    """
    template_name = 'users/profile_activity.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['active_tab'] = 'activity'
        # Всегда передаем empty_activity = True, так как это заглушка
        context['empty_activity'] = True
        return context


class ProfileUpdateView(LoginRequiredMixin, TemplateView):
    """
    Представление для обновления профиля пользователя.
    """
    template_name = 'users/profile_update.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['active_tab'] = 'profile'

        # Проверяем и создаем профиль, если его нет
        profile, created = Profile.objects.get_or_create(user=self.request.user)

        context['user_form'] = UserUpdateForm(instance=self.request.user)
        context['profile_form'] = ProfileUpdateForm(instance=profile)
        return context

    def post(self, request, *args, **kwargs):
        # Проверяем и создаем профиль, если его нет
        profile, created = Profile.objects.get_or_create(user=request.user)

        user_form = UserUpdateForm(request.POST, instance=request.user)
        profile_form = ProfileUpdateForm(
            request.POST,
            request.FILES,
            instance=profile
        )

        if user_form.is_valid() and profile_form.is_valid():
            user_form.save()
            profile_form.save()
            messages.success(request, 'Профиль успешно обновлен!')
            return redirect('users:profile')

        context = self.get_context_data()
        context['user_form'] = user_form
        context['profile_form'] = profile_form
        return render(request, self.template_name, context)