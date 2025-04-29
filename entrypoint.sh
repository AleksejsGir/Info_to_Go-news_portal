#!/bin/bash

# Ждем, пока база данных запустится
echo "Waiting for PostgreSQL..."
while ! nc -z $PG_HOST $PG_PORT; do
  sleep 0.1
done
echo "PostgreSQL started"

# Создаем admin пользователя
echo "Creating admin user if not exists..."
python create_admin.py

# Применяем миграции
echo "Applying migrations..."
python manage.py migrate

# Собираем статические файлы
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Запускаем Django сервер с Gunicorn
echo "Starting Gunicorn server..."
exec gunicorn itg.wsgi:application --bind 0.0.0.0:8000