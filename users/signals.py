# users/signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth import get_user_model
from allauth.account.models import EmailAddress
from django.utils import timezone

User = get_user_model()


@receiver(post_save, sender=EmailAddress)
def update_verified_status(sender, instance, created, **kwargs):
    """
    Сигнал, срабатывающий после сохранения объекта EmailAddress.
    Обновляет все email-адреса пользователя как подтвержденные,
    если текущий адрес был верифицирован.
    """
    if not created and instance.verified:
        # Вывод отладочной информации
        print(f"[SIGNAL] Email подтвержден: {instance.email}")

        # Обновляем все email пользователя, кроме текущего
        EmailAddress.objects.filter(user=instance.user) \
            .exclude(pk=instance.pk) \
            .update(verified=True)

        # Обновляем дату последнего входа для пользователя
        user = instance.user
        user.last_login = timezone.now()
        user.save(update_fields=['last_login'])


@receiver(post_save, sender=User)
def user_created_handler(sender, instance, created, **kwargs):
    """
    Обрабатывает создание нового пользователя.
    Можно добавить дополнительные действия при регистрации.
    """
    if created:
        print(f"[SIGNAL] Создан новый пользователь: {instance.username or instance.email}")
        # Здесь можно добавить инициализацию профиля пользователя
        # или другие действия, которые должны выполняться при регистрации