# users/signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from allauth.account.models import EmailAddress


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