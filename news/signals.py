# news/signals.py
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.core.cache import cache
from .models import Category

@receiver([post_save, post_delete], sender=Category)
def clear_category_cache(sender, instance, **kwargs):
    """
    Сигнал, который срабатывает при создании или удалении категории.
    Очищает кэш категорий, чтобы в следующий раз данные были актуальными.
    """
    print(f"[SIGNAL] Сброс кэша категорий. Категория: {instance.name if hasattr(instance, 'name') else 'удалена'}")
    cache.delete("categories")