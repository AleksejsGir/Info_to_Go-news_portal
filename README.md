# Info_to_Go-news_portal (Портал Новостей на Django)

Это учебный проект новостного портала, разработанный на Python с использованием фреймворка Django и запущенный с помощью Docker. Проект создан в рамках обучения в онлайн-школе.

## Особенности

*   Регистрация и аутентификация пользователей (стандартная и через GitHub).
*   Создание, редактирование, удаление новостных статей.
*   Категории и теги для статей.
*   Лайки, избранное, комментарии (если реализовано).
*   Административная панель (Jazzmin).
*   Полностью контейнеризован с использованием Docker и Docker Compose.

## Технологии

*   **Backend:** Python, Django
*   **Frontend:** HTML, CSS, JavaScript (Bootstrap/шаблоны Django)
*   **База данных:** PostgreSQL
*   **Аутентификация:** Django Allauth (Email, GitHub OAuth)
*   **Админка:** Django Admin, Jazzmin
*   **Веб-сервер/Прокси:** Nginx
*   **WSGI сервер:** Gunicorn
*   **Контейнеризация:** Docker, Docker Compose

## Предварительные требования

*   [Docker](https://www.docker.com/get-started)
*   [Docker Compose](https://docs.docker.com/compose/install/) (обычно устанавливается вместе с Docker Desktop)
*   [Git](https://git-scm.com/)

## Установка и Запуск

1.  **Клонировать репозиторий:**
    ```bash
    git clone https://github.com/AleksejsGir/Info_to_Go-news_portal.git
    cd Info_to_Go-news_portal
    ```

2.  **Создать и настроить файл `.env`:**
    *   Скопируйте файл `.env.example` (если вы его создали и добавили в Git) или создайте `.env` вручную в корне проекта:
        ```bash
        cp .env.example .env
        ```
    *   **Отредактируйте `.env`**, указав ваши реальные значения для:
        *   `SECRET_KEY` (сгенерируйте новый надежный ключ!)
        *   `DEBUG` (`True` для разработки, `False` для production)
        *   `PG_PASSWORD` (пароль для БД)
        *   `EMAIL_...` (данные вашего SMTP-сервера, включая пароль приложения для Gmail)
        *   `CLIENT_ID`, `CLIENT_SECRET` (ваши учетные данные GitHub OAuth App)
        *   `DJANGO_SUPERUSER_PASSWORD` (пароль для суперпользователя)
        *   `DJANGO_ALLOWED_HOSTS` (для локального запуска достаточно `localhost,127.0.0.1,nginx`)
        *   `DJANGO_SITE_DOMAIN` (для локального запуска `localhost`)

3.  **Создать дамп локальной базы данных (если нужно перенести данные):**
    *   Убедитесь, что ваша локальная PostgreSQL запущена.
    *   Убедитесь, что файл `dump_db.sh` имеет права на выполнение (`chmod +x dump_db.sh`).
    *   Запустите скрипт:
        ```bash
        ./dump_db.sh
        ```
    *   Это создаст файл `postgresql/init-scripts/init.sql`. *(Примечание: не добавляйте этот файл в Git)*.

4.  **Собрать Docker-образы:**
    ```bash
    docker-compose build
    ```

5.  **Запустить контейнеры:**
    ```bash
    docker-compose up -d
    ```
    *При первом запуске будет создана база данных из `init.sql` (если он есть) и выполнены начальные настройки.*

6.  **Скопировать медиафайлы (если нужно перенести):**
    *   Убедитесь, что контейнеры запущены.
    *   Убедитесь, что файл `copy_media.sh` имеет права на выполнение (`chmod +x copy_media.sh`).
    *   Запустите скрипт:
        ```bash
        ./copy_media.sh
        ```
    *   *(Примечание: может потребоваться выполнить `docker exec -u root itg_django_web chown -R appuser:app /app/media` один раз после копирования, если возникнут проблемы с правами на запись).*

7.  **Открыть сайт:**
    Перейдите в браузере по адресу [http://localhost](http://localhost) (или [http://127.0.0.1](http://127.0.0.1)).

## Доступ к Админ-панели

*   URL: [http://localhost/admin/](http://localhost/admin/)
*   Логин/Пароль: Имя пользователя и пароль, указанные в переменных `DJANGO_SUPERUSER_USERNAME` и `DJANGO_SUPERUSER_PASSWORD` в файле `.env`.

## Выполнение Django команд

Для выполнения команд `manage.py` (например, `makemigrations`, `shell`, `changepassword`) используйте `docker exec`:

```bash
docker exec -it itg_django_web python manage.py <ваша_команда>