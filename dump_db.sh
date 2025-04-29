#!/bin/bash

# Настройки для подключения к ЛОКАЛЬНОЙ базе данных
# Прочитаем из .env, если он есть, или используем дефолты
if [ -f .env ]; then
    # Исправленная строка для экспорта: убирает комментарии и пустые строки
    export $(grep -v '^#' .env | sed 's/#.*//' | grep -v '^[[:space:]]*$' | xargs)
fi

LOCAL_PG_USER=${PG_USER:-postgres} # Дефолт postgres
LOCAL_PG_PASSWORD=${PG_PASSWORD:-admin} # Дефолт admin
LOCAL_PG_DB=${PG_NAME:-alek_db} # Дефолт alek_db
LOCAL_PG_HOST=${PG_HOST:-localhost} # Дефолт localhost
LOCAL_PG_PORT=${PG_PORT:-5432} # Дефолт 5432

# Директория для скриптов инициализации PostgreSQL
INIT_SCRIPT_DIR="./postgresql/init-scripts"
OUTPUT_FILE="${INIT_SCRIPT_DIR}/init.sql"

# Создаем директорию, если она не существует
mkdir -p "$INIT_SCRIPT_DIR"

# Создаем дамп базы данных в формате SQL
echo "Creating database dump from local DB ${LOCAL_PG_DB} on ${LOCAL_PG_HOST}:${LOCAL_PG_PORT}..."
# Используем PGPASSWORD для передачи пароля
export PGPASSWORD=$LOCAL_PG_PASSWORD
pg_dump -U "$LOCAL_PG_USER" -h "$LOCAL_PG_HOST" -p "$LOCAL_PG_PORT" -d "$LOCAL_PG_DB" --clean --if-exists -F p > "$OUTPUT_FILE"
# Сбрасываем переменную пароля
unset PGPASSWORD

# Проверяем, успешно ли создан дамп
if [ $? -eq 0 ]; then
    echo "Database dump created successfully in ${OUTPUT_FILE}"
else
    echo "Error creating database dump. Check connection parameters and PostgreSQL server status."
    # Очищаем файл в случае ошибки, чтобы Docker не пытался выполнить неполный дамп
    > "$OUTPUT_FILE"
    exit 1
fi