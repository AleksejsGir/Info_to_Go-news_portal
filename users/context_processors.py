# users/context_processors.py
from django.contrib.auth import get_user_model
from allauth.socialaccount.models import SocialApp


def user_context(request):
    """
    Возвращает контекст, связанный с пользователями и аутентификацией.

    Включает:
    - is_authentication_page: определяет, находится ли пользователь на странице аутентификации
    - available_social_providers: список доступных методов социальной аутентификации
    - hide_sidebar: скрывать ли боковую панель с категориями (True для страниц аутентификации)
    """
    # Определяем, находится ли пользователь на странице аутентификации
    auth_paths = [
        '/accounts/login/',
        '/accounts/signup/',
        '/accounts/password/reset/',
        '/accounts/confirm-email/',
        '/accounts/password/reset/key/',  # Добавлен путь для страницы сброса пароля
        '/accounts/email/',  # Добавлен путь для страницы управления email
        '/accounts/password/change/',  # Путь для страницы изменения пароля
        '/accounts/password/change/done/',  # Путь для страницы успешного изменения пароля
        '/accounts/github/login/'
    ]

    is_auth_page = any(request.path.startswith(path) for path in auth_paths)

    # Получаем доступные социальные провайдеры (если они настроены)
    social_providers = SocialApp.objects.values_list('provider', flat=True)

    return {
        'is_authentication_page': is_auth_page,
        'hide_sidebar': is_auth_page,     # Добавлена эта строка - скрывать сайдбар на страницах аутентификации
        'available_social_providers': list(social_providers),
        'auth_menu': [
            {"title": "Вход", "url": "/accounts/login/", "url_name": "account_login", "logged_out_only": True},
            {"title": "Регистрация", "url": "/accounts/signup/", "url_name": "account_signup", "logged_out_only": True},
            {"title": "Выход", "url": "/accounts/logout/", "url_name": "account_logout", "logged_in_only": True},
        ]
    }
