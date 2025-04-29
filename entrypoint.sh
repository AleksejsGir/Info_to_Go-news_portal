#!/bin/bash

# Убрана команда chmod для media (делается в Dockerfile или copy_media.sh)
# Добавлен вызов migrate

# Выход при ошибке
set -e

echo "Waiting for PostgreSQL at $PG_HOST:$PG_PORT..."
while ! nc -z $PG_HOST $PG_PORT; do
  sleep 0.1
done
echo "PostgreSQL started"

# Применяем миграции (важно перед create_admin и collectstatic)
echo "Applying database migrations..."
python manage.py migrate --noinput

# Создаем admin пользователя и настраиваем Site/SocialApp
echo "Running initial setup script (create_admin.py)..."
python create_admin.py

# Собираем статические файлы
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear # Добавлен --clear

# Установка прав на медиа больше не нужна здесь, делается в Dockerfile и copy_media.sh
# echo "Setting permissions for media files..."
# if [ -d "/app/media" ]; then
#   chmod -R 755 /app/media
# fi

# Запускаем Django сервер с Gunicorn
echo "Starting Gunicorn server..."
# Указываем количество воркеров (пример: 2 * CPU + 1)
# Можно вынести в переменную окружения GUNICORN_WORKERS
exec gunicorn itg.wsgi:application --workers 3 --bind 0.0.0.0:8000