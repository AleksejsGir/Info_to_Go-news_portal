#!/usr/bin/env python
import os
import django

# Устанавливаем модуль настроек Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'itg.settings')
# Вызываем настройку Django ПЕРЕД импортом моделей
django.setup()

# --- Импорты моделей ПОСЛЕ django.setup() ---
from django.contrib.auth import get_user_model
from django.contrib.sites.models import Site
from allauth.socialaccount.models import SocialApp
# ---------------------------------------------

User = get_user_model()

# --- 1. Создание суперпользователя ---
# Читаем параметры из переменных окружения или используем значения по умолчанию
username = os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin')
email = os.environ.get('DJANGO_SUPERUSER_EMAIL', 'admin@example.com')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD', '')

# Проверяем наличие обязательного пароля
if not password:
    print("Warning: DJANGO_SUPERUSER_PASSWORD not set. Cannot create superuser.")
else:
    # Создаем суперпользователя, если он не существует
    if not User.objects.filter(username=username).exists():
        try:
            print(f"Creating superuser '{username}'...")
            User.objects.create_superuser(username=username, email=email, password=password)
            print(f"Superuser '{username}' created successfully.")
        except Exception as e:
            print(f"Error creating superuser '{username}': {e}")
    else:
        print(f"Superuser '{username}' already exists.")

# --- 2. Настройка Site с ID=1 ---
# Читаем домен и имя сайта из переменных окружения
# По умолчанию используем 'localhost', так как Nginx слушает порт 80
site_domain = os.environ.get("DJANGO_SITE_DOMAIN", "localhost")
site_name = os.environ.get("DJANGO_SITE_NAME", site_domain) # Имя сайта по умолчанию как домен

try:
    # Получаем или создаем объект Site с ID=1
    site, created = Site.objects.get_or_create(id=1, defaults={
        'domain': site_domain, # Используем переменную
        'name': site_name      # Используем переменную
    })

    # Если сайт уже существовал, проверяем и обновляем его данные при необходимости
    if not created:
        if site.domain != site_domain or site.name != site_name:
            site.domain = site_domain
            site.name = site_name
            site.save()
            print(f"Updated Site id=1: domain='{site_domain}', name='{site_name}'")
        else:
            print(f"Site id=1 already configured: domain='{site_domain}', name='{site_name}'")
    # Если сайт только что создан
    else:
        print(f"Created Site id=1: domain='{site_domain}', name='{site_name}'")

except Exception as e:
    print(f"Error configuring Site id=1: {e}")


# --- 3. Создание SocialApp для GitHub ---
# Читаем Client ID и Secret из переменных окружения
client_id = os.environ.get('CLIENT_ID')
client_secret = os.environ.get('CLIENT_SECRET')

# Проверяем, что ID и секрет заданы
if client_id and client_secret:
    try:
        # Получаем текущий сайт (должен существовать после шага 2)
        current_site = Site.objects.get(id=1)

        # Проверяем, существует ли уже приложение GitHub с таким client_id
        social_app, created = SocialApp.objects.get_or_create(
            provider='github',
            client_id=client_id,
            defaults={
                'name': 'GitHub', # Имя приложения для отображения
                'secret': client_secret,
            }
        )

        if created:
            print(f"Creating SocialApp for GitHub (client_id={client_id[:5]}...)...")
            # Привязываем новое приложение к нашему сайту
            social_app.sites.add(current_site)
            social_app.save()
            print(f"SocialApp for GitHub created and linked to site id=1.")
        else:
            print(f"SocialApp for GitHub (client_id={client_id[:5]}...) already exists.")
            # Дополнительно проверим и обновим секрет, если он изменился
            if social_app.secret != client_secret:
                 social_app.secret = client_secret
                 social_app.save()
                 print("Updated secret for existing GitHub SocialApp.")
            # Проверим, привязано ли приложение к нашему сайту
            if not social_app.sites.filter(id=current_site.id).exists():
                 social_app.sites.add(current_site)
                 print(f"Linked existing SocialApp for GitHub to site id=1.")

    except Site.DoesNotExist:
        print("Error: Cannot create/link SocialApp because Site with id=1 does not exist.")
    except Exception as e:
        print(f"Error creating/configuring SocialApp for GitHub: {e}")
# Если ID или секрет не заданы в .env
else:
    print("Warning: CLIENT_ID or CLIENT_SECRET not set in environment variables. GitHub OAuth setup skipped.")

# <!-- AI-TODO: Исправленный create_admin.py: читает домен сайта из DJANGO_SITE_DOMAIN, создает суперюзера и настраивает SocialApp GitHub. -->