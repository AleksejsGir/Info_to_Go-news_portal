# users/apps.py
from django.apps import AppConfig

class UsersConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'users'
    verbose_name = 'Пользователи'  # Отображаемое имя в админке

    def ready(self):
        """
        Метод вызывается при запуске приложения.
        Импортирует модуль сигналов для регистрации всех обработчиков сигналов.
        """
        import users.signals  # Импортируем сигналы