# users/auth_handlers.py
from django.dispatch import receiver
from django.contrib.auth.signals import user_logged_in, user_logged_out
from .utils import record_user_activity

@receiver(user_logged_in)
def log_user_login(sender, request, user, **kwargs):
    """
    Записывает событие входа пользователя в систему.
    """
    record_user_activity(
        user=user,
        action_type='login',
        description='Вход в систему'
    )

@receiver(user_logged_out)
def log_user_logout(sender, request, user, **kwargs):
    """
    Записывает событие выхода пользователя из системы.
    """
    if user:  # Проверяем, что у нас есть пользователь
        record_user_activity(
            user=user,
            action_type='logout',
            description='Выход из системы'
        )