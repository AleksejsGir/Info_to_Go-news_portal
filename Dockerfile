# Dockerfile

# Используем официальный образ Python
FROM python:3.11-slim

# Установка рабочей директории
WORKDIR /app

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    postgresql-client \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Установка зависимостей Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копирование проекта
COPY . .

# Создание директорий для статических и медиа файлов
RUN mkdir -p /app/staticfiles /app/media

# Настройка Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Открываем порт для Gunicorn
EXPOSE 8000

# Запуск через entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]