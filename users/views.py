# Copyright 2024-2025 Aleksejs Giruckis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# users/views.py
from django.shortcuts import redirect, render
from django.urls import reverse_lazy
from django.views.generic import TemplateView, ListView, UpdateView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib import messages
from news.models import Article
from .forms import ProfileUpdateForm, UserUpdateForm
from .models import Profile, UserActivity
from .utils import record_user_activity


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


class UserActivityView(LoginRequiredMixin, ListView):
    """
    Представление для отображения истории действий пользователя.
    """
    template_name = 'users/profile_activity.html'
    context_object_name = 'user_actions'
    paginate_by = 10

    def get_queryset(self):
        return UserActivity.objects.filter(user=self.request.user).order_by('-timestamp')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['active_tab'] = 'activity'
        context['empty_activity'] = self.get_queryset().count() == 0
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

            # Добавляем запись о действии
            record_user_activity(
                user=request.user,
                action_type='edit_profile',
                description='Профиль был обновлен'
            )

            messages.success(request, 'Профиль успешно обновлен!')
            return redirect('users:profile')

        context = self.get_context_data()
        context['user_form'] = user_form
        context['profile_form'] = profile_form
        return render(request, self.template_name, context)


class ProfileFavoritesView(LoginRequiredMixin, ListView):
    """
    Представление для отображения избранных статей пользователя в профиле.
    """
    template_name = 'users/profile_favorites.html'
    context_object_name = 'favorites'
    paginate_by = 10

    def get_queryset(self):
        # Получаем ID избранных статей пользователя
        from news.models import Favorite, Article
        favorite_ids = Favorite.objects.filter(user=self.request.user).values_list('article_id', flat=True)
        # Возвращаем статьи с этими ID
        return Article.objects.filter(id__in=favorite_ids).order_by('-publication_date')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['active_tab'] = 'favorites'
        return context