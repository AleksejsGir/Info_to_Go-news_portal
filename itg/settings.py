# settings.py
import os
from pathlib import Path
from dotenv import load_dotenv

# Загрузка переменных окружения из .env файла (полезно для локального запуска)
load_dotenv()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.getenv('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
# Читаем DEBUG из окружения, по умолчанию False
DEBUG = os.getenv('DEBUG', 'False').lower() in ('true', '1', 'yes')

# Читаем ALLOWED_HOSTS из окружения, разделяем по запятой
ALLOWED_HOSTS_STR = os.getenv('DJANGO_ALLOWED_HOSTS', '127.0.0.1,localhost')
ALLOWED_HOSTS = [host.strip() for host in ALLOWED_HOSTS_STR.split(',') if host.strip()]

# Настройки Debug Toolbar (работает только если DEBUG=True)
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
    'debug_toolbar.middleware.DebugToolbarMiddleware', # Должен быть как можно раньше, но после кодировок/сессий
    'allauth.account.middleware.AccountMiddleware',  # Добавлено для django-allauth
]

ROOT_URLCONF = 'itg.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            BASE_DIR / 'templates',
            # Уточните, нужен ли BASE_DIR здесь, обычно только BASE_DIR / 'templates'
            # BASE_DIR, 'news/templates' # <-- Это выглядит некорректно, news/templates должно искаться автоматически через APP_DIRS=True
        ],
        'APP_DIRS': True, # Искать шаблоны внутри папок templates приложений
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request', # Обязателен для allauth и админки
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'news.context_processors.global_context', # Ваши контекст-процессоры
                'users.context_processors.user_context',
            ],
        },
    },
]

WSGI_APPLICATION = 'itg.wsgi.application'

# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases
# Параметры читаются из переменных окружения (PG_NAME, PG_USER, PG_PASSWORD, PG_HOST, PG_PORT)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('PG_NAME'),
        'USER': os.getenv('PG_USER'),
        'PASSWORD': os.getenv('PG_PASSWORD'),
        'HOST': os.getenv('PG_HOST'), # В Docker будет 'db'
        'PORT': os.getenv('PG_PORT'),
    }
}

# Password validation
# https://docs.djangoproject.com/en/5.1/ref/settings/#auth-password-validators
AUTH_PASSWORD_VALIDATORS = [
    { 'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator', },
    { 'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator', },
    { 'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator', },
    { 'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator', },
]

# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/
LANGUAGE_CODE = 'ru-ru'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True # Рекомендуется оставить True для работы с часовыми поясами

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/

# URL для статических файлов (читается из .env, по умолчанию /static/)
STATIC_URL = os.getenv('STATIC_URL', '/static/')
# Абсолютный путь к папке, КУДА collectstatic будет собирать все файлы для развертывания
# (читается из .env, в Docker будет /app/staticfiles)
STATIC_ROOT = os.getenv('STATIC_ROOT', BASE_DIR / 'staticfiles')

# Список папок, ГДЕ искать дополнительные статические файлы (помимо статики приложений)
# Если у вас нет общей папки 'static' в корне проекта или она не нужна,
# закомментируйте или удалите этот параметр, чтобы избежать предупреждения W004.
# STATICFILES_DIRS = [
#     BASE_DIR / 'static', # <-- Закомментировано для исправления W004
# ]

# Настройки для медиафайлов (загружаемых пользователями)
# URL для медиафайлов (читается из .env, по умолчанию /media/)
MEDIA_URL = os.getenv('MEDIA_URL', '/media/')
# Абсолютный путь к папке, ГДЕ хранятся медиафайлы
# (читается из .env, в Docker будет /app/media)
MEDIA_ROOT = os.getenv('MEDIA_ROOT', BASE_DIR / 'media')

# Настройки сессий
SESSION_ENGINE = 'django.contrib.sessions.backends.db'
SESSION_COOKIE_AGE = 1209600  # 2 недели в секундах
SESSION_SAVE_EVERY_REQUEST = True # Сохранять сессию при каждом запросе


# Настройки django-allauth
SITE_ID = 1

AUTHENTICATION_BACKENDS = [
    'django.contrib.auth.backends.ModelBackend',          # Стандартный бэкенд Django
    'allauth.account.auth_backends.AuthenticationBackend', # Бэкенд allauth
    'users.authentication.EmailAuthBackend',              # Ваш кастомный бэкенд (оставьте, если нужен)
]

# Настройка URL для перенаправления
LOGIN_URL = 'account_login'           # Имя URL-шаблона для страницы входа allauth
LOGIN_REDIRECT_URL = 'news:catalog'   # Куда перенаправлять после успешного входа
ACCOUNT_LOGOUT_REDIRECT_URL = 'account_login' # Куда перенаправлять после выхода

# --- Актуальные настройки Allauth ---
ACCOUNT_ADAPTER = 'allauth.account.adapter.DefaultAccountAdapter'
ACCOUNT_AUTHENTICATION_METHOD = 'email' # ('username' | 'email' | 'username_email') - Выберите ваш основной метод входа
ACCOUNT_EMAIL_REQUIRED = True           # Email обязателен
ACCOUNT_EMAIL_VERIFICATION = 'mandatory' # ('mandatory' | 'optional' | 'none') - Верификация email
ACCOUNT_USERNAME_REQUIRED = True        # Username обязателен (установите False, если вход только по email)
# ACCOUNT_SIGNUP_PASSWORD_ENTER_TWICE = True # Требовать ввод пароля дважды при регистрации (по умолчанию True)
# ACCOUNT_SESSION_REMEMBER = None # Управляет сессией "запомнить меня" (None=спросить, True=всегда, False=никогда)
# ACCOUNT_UNIQUE_EMAIL = True # Требовать уникальные email (по умолчанию True)

# --- Остальные общие настройки allauth  ---
ACCOUNT_USERNAME_MIN_LENGTH = 4 # Минимальная длина username
ACCOUNT_EMAIL_CONFIRMATION_EXPIRE_DAYS = 3 # Срок действия ссылки подтверждения
ACCOUNT_EMAIL_CONFIRMATION_HMAC = True     # Использовать HMAC для защиты ссылок
ACCOUNT_LOGIN_ON_EMAIL_CONFIRMATION = True # Входить автоматически после подтверждения email
ACCOUNT_EMAIL_SUBJECT_PREFIX = "[New Portal] " # Префикс для тем писем allauth

# Настройки провайдеров социальных сетей
SOCIALACCOUNT_ADAPTER = 'allauth.socialaccount.adapter.DefaultSocialAccountAdapter'
SOCIALACCOUNT_PROVIDERS = {
    'github': {
        'SCOPE': ['user:email'], # Запрашиваемые права у GitHub
        'AUTH_PARAMS': {'access_type': 'online'},
        # Client ID и Secret теперь настраиваются через админку (SocialApp)
        # или через скрипт create_admin.py
    }
}

# Указание кастомных форм (оставьте как есть, если они у вас используются)
ACCOUNT_FORMS = {
    'login': 'users.forms.CustomAuthenticationForm',
    'signup': 'users.forms.CustomSignupForm',
    'reset_password': 'users.forms.CustomResetPasswordForm',
}

# Настройки для отправки email (читаются из .env)
EMAIL_BACKEND = os.getenv('EMAIL_BACKEND', 'django.core.mail.backends.console.EmailBackend') # По умолчанию вывод в консоль
EMAIL_HOST = os.getenv('EMAIL_HOST')
EMAIL_PORT = int(os.getenv('EMAIL_PORT', 587)) # Порт SMTP
EMAIL_USE_TLS = os.getenv('EMAIL_USE_TLS', 'True').lower() in ('true', '1', 'yes') # Использовать TLS
EMAIL_HOST_USER = os.getenv('EMAIL_HOST_USER') # Логин SMTP
EMAIL_HOST_PASSWORD = os.getenv('EMAIL_HOST_PASSWORD') # Пароль SMTP
DEFAULT_FROM_EMAIL = os.getenv('DEFAULT_FROM_EMAIL', 'webmaster@localhost') # Email отправителя по умолчанию

# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Настройки Jazzmin
JAZZMIN_SETTINGS = {
    "site_title": "Info to Go Admin",
    "site_header": "ITG: Admin",
    "site_brand": "Info to Go",
    "welcome_sign": "Welcome to ITG: Admin",
    "copyright": "ITG GmbH",
    "topmenu_links": [
        {"name": "Home", "url": "admin:index", "permissions": ["auth.view_user"]},
        {"name": "Support", "url": "https://google.com", "new_window": True},
    ],
    "usermenu_links": [
        {"name": "Support", "url": "https://github.com/farridav/django-jazzmin/issues", "new_window": True},
        {"model": "auth.user"}
    ],
    "show_sidebar": True,
    "navigation_expanded": True,
    "hide_apps": [],
    "hide_models": [],
    "default_icon_parents": "fas fa-chevron-circle-right",
    "default_icon_children": "fas fa-circle",
    "related_modal_active": False,
    "custom_css": None,
    "custom_js": None,
    "use_google_fonts_cdn": True,
    "show_ui_builder": False,
    "icons": {
        "news.Article": "fas fa-newspaper",
        "news.Category": "fas fa-folder",
        "news.Tag": "fas fa-tag",
        "auth.user": "fas fa-user",
        "auth.Group": "fas fa-users",
    },
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
