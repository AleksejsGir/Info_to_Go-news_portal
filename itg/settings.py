# settings.py
import os
from pathlib import Path
from dotenv import load_dotenv

# Загрузка переменных окружения
load_dotenv()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.getenv('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.getenv('DEBUG', 'False').lower() in ('true', '1')

ALLOWED_HOSTS = []
# LOGGING = {
#     'version': 1,
#     'disable_existing_loggers': False,
#     'handlers': {
#         'console': {
#             'class': 'logging.StreamHandler',
#         },
#     },
#     'root': {
#         'handlers': ['console'],
#         'level': 'DEBUG',
#     },
#     'loggers': {
#         'django': {
#             'handlers': ['console'],
#             'level': 'DEBUG',
#             'propagate': True,
#         },
#         'allauth': {
#             'handlers': ['console'],
#             'level': 'DEBUG',
#             'propagate': True,
#         },
#     },
# }
INTERNAL_IPS = [
    '127.0.0.1',
]

# Application definition

INSTALLED_APPS = [
    'jazzmin',

    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.sites',  # Добавлено для django-allauth

    # django-allauth
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'allauth.socialaccount.providers.github',  # Добавляем провайдер GitHub

    'django_extensions',
    'debug_toolbar',

    'news.apps.NewsConfig',  # Используйте NewsConfig вместо просто 'news'
    'users.apps.UsersConfig',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'debug_toolbar.middleware.DebugToolbarMiddleware',
    'allauth.account.middleware.AccountMiddleware',  # Добавлено для django-allauth
]

ROOT_URLCONF = 'itg.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            BASE_DIR / 'templates'
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'news.context_processors.global_context',
                'users.context_processors.user_context',
            ],
        },
    },
]

WSGI_APPLICATION = 'itg.wsgi.application'

# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('PG_NAME'),
        'USER': os.getenv('PG_USER'),
        'PASSWORD': os.getenv('PG_PASSWORD'),
        'HOST': os.getenv('PG_HOST'),
        'PORT': os.getenv('PG_PORT'),
    }
}

# Password validation
# https://docs.djangoproject.com/en/5.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/

LANGUAGE_CODE = 'ru-ru'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/

STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

# Настройки для медиафайлов
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Настройки сессий
SESSION_ENGINE = 'django.contrib.sessions.backends.db'
SESSION_COOKIE_AGE = 1209600  # 2 недели
SESSION_SAVE_EVERY_REQUEST = True

# Настройки django-allauth
SITE_ID = 1

AUTHENTICATION_BACKENDS = [
    'django.contrib.auth.backends.ModelBackend',  # Стандартный бэкенд
    'allauth.account.auth_backends.AuthenticationBackend',  # Бэкенд allauth
    'users.authentication.EmailAuthBackend',  # Кастомный бэкенд
]

# Настройка URL для перенаправления при попытке доступа к защищенным страницам
LOGIN_URL = 'account_login'  # Используем URL allauth
LOGIN_REDIRECT_URL = 'news:catalog'  # Перенаправление после входа
ACCOUNT_LOGOUT_REDIRECT_URL = 'account_login'  # Перенаправление после выхода

# Настройки allauth
ACCOUNT_EMAIL_REQUIRED = True  # Email обязателен при регистрации
ACCOUNT_EMAIL_VERIFICATION = "mandatory"  # Обязательная верификация email
ACCOUNT_AUTHENTICATION_METHOD = "email"  # Использовать email для аутентификации
ACCOUNT_USERNAME_REQUIRED = True  # Имя пользователя не обязательно
ACCOUNT_EMAIL_CONFIRMATION_EXPIRE_DAYS = 3  # Срок действия ссылки подтверждения
ACCOUNT_EMAIL_CONFIRMATION_HMAC = True  # Использовать HMAC для защиты
ACCOUNT_LOGIN_ON_EMAIL_CONFIRMATION = True  # Автовход после подтверждения email
ACCOUNT_EMAIL_SUBJECT_PREFIX = "[The Future Prism] "  # Префикс темы писем

SOCIALACCOUNT_PROVIDERS = {
    'github': {
        'SCOPE': ['user:email'],  # Запрашиваем доступ к email пользователя
        'AUTH_PARAMS': {'access_type': 'online'},
    }
}

# Кастомная форма регистрации
ACCOUNT_FORMS = {
    'login': 'users.forms.CustomAuthenticationForm',
    'signup': 'users.forms.CustomSignupForm',
    'reset_password': 'users.forms.CustomResetPasswordForm',
}

# Настройки для отправки email
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = os.getenv('EMAIL_HOST')
EMAIL_PORT = int(os.getenv('EMAIL_PORT', 587))
EMAIL_USE_TLS = os.getenv('EMAIL_USE_TLS', 'True') == 'True'
EMAIL_HOST_USER = os.getenv('EMAIL_HOST_USER')
EMAIL_HOST_PASSWORD = os.getenv('EMAIL_HOST_PASSWORD')
DEFAULT_FROM_EMAIL = os.getenv('DEFAULT_FROM_EMAIL')

# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Настройки Jazzmin

JAZZMIN_SETTINGS = {
    "site_title": "Info to Go Admin",  # Заголовок административной панели
    "site_header": "ITG: Admin",  # Заголовок окна браузера
    "site_brand": "Info to Go",  # Бренд сайта
    "welcome_sign": "Welcome to ITG: Admin",  # Приветственное сообщение
    "copyright": "ITG GmbH",  # Информация о копирайте
    "topmenu_links": [
        {"name": "Home", "url": "admin:index", "permissions": ["auth.view_user"]},
        # {"name": "Catalog", "url": "news:catalog", "new_window": True},
        {"name": "Support", "url": "https://google.com", "new_window": True},
    ],
    "usermenu_links": [
        {"name": "Support", "url": "https://github.com/farridav/django-jazzmin/issues", "new_window": True},
        {"model": "auth.user"}
    ],
    "show_sidebar": True,  # Показать боковую панель
    "navigation_expanded": True,  # Развернуть навигацию
    "hide_apps": [],  # Скрыть приложения
    "hide_models": [],  # Скрыть модели
    "default_icon_parents": "fas fa-chevron-circle-right",  # Иконка для родительских элементов
    "default_icon_children": "fas fa-circle",  # Иконка для дочерних элементов
    "related_modal_active": False,  # Включить модальные окна для связанных объектов
    "custom_css": None,  # Пользовательский CSS
    "custom_js": None,  # Пользовательский JS
    "use_google_fonts_cdn": True,  # Использовать Google Fonts CDN
    "show_ui_builder": False,  # Показать конструктор интерфейса
}

JAZZMIN_UI_TWEAKS = {
    "navbar_small_text": False,
    "footer_small_text": False,
    "body_small_text": True,
    "brand_small_text": False,
    "brand_colour": "navbar-secondary",
    "accent": "accent-pink",
    "navbar": "navbar-danger navbar-dark",
    "no_navbar_border": False,
    "navbar_fixed": True,
    "layout_boxed": False,
    "footer_fixed": False,
    "sidebar_fixed": True,
    "sidebar": "sidebar-light-primary",
    "sidebar_nav_small_text": False,
    "sidebar_disable_expand": False,
    "sidebar_nav_child_indent": False,
    "sidebar_nav_compact_style": True,
    "sidebar_nav_legacy_style": False,
    "sidebar_nav_flat_style": True,
    "theme": "default",
    "dark_mode_theme": "darkly",
    "button_classes": {
        "primary": "btn-primary",
        "secondary": "btn-secondary",
        "info": "btn-info",
        "warning": "btn-warning",
        "danger": "btn-danger",
        "success": "btn-success"
    }
}
