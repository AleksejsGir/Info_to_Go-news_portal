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


# users/models.py
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Profile(models.Model):
    """
    Модель профиля пользователя с расширенными данными.
    Связана с моделью User через OneToOneField.
    """
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='profile',
        verbose_name='Пользователь'
    )
    avatar = models.ImageField(
        upload_to='avatars/%Y/%m/%d/',
        blank=True,
        null=True,
        verbose_name='Аватар'
    )
    bio = models.TextField(
        max_length=500,
        blank=True,
        verbose_name='О себе'
    )

    class Meta:
        verbose_name = 'Профиль'
        verbose_name_plural = 'Профили'

    def __str__(self):
        return f"Профиль пользователя {self.user.username}"


class UserActivity(models.Model):
    """
    Модель для отслеживания действий пользователя.
    """
    ACTION_TYPES = (
        ('login', 'Вход в систему'),
        ('logout', 'Выход из системы'),
        ('create_article', 'Создание статьи'),
        ('edit_article', 'Редактирование статьи'),
        ('delete_article', 'Удаление статьи'),
        ('like_article', 'Лайк статьи'),
        ('favorite_article', 'Добавление в избранное'),
        ('edit_profile', 'Редактирование профиля'),
    )

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='activities')
    action_type = models.CharField(max_length=20, choices=ACTION_TYPES)
    description = models.CharField(max_length=255, blank=True)
    related_object_id = models.PositiveIntegerField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Активность пользователя'
        verbose_name_plural = 'Активности пользователей'
        ordering = ['-timestamp']

    def __str__(self):
        return f"{self.user.username} - {self.get_action_type_display()} - {self.timestamp}"