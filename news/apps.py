# news/apps.py
from django.apps import AppConfig

class NewsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'news'
    verbose_name = 'Новость'
    verbose_name_plural = 'Новости'  # Отображаемое имя в админке

    def ready(self):
        """
        Метод вызывается при запуске приложения.
        Импортирует модуль сигналов, чтобы зарегистрировать все сигналы.
        """
        import news.signals  # Импортируем сигналы