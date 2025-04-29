#!/bin/bash

# Путь к локальной директории media
LOCAL_MEDIA_DIR="./media"
# Имя сервиса из docker-compose.yml
SERVICE_NAME="web"

# Получаем ID запущенного контейнера сервиса 'web'
CONTAINER_ID=$(docker-compose ps -q ${SERVICE_NAME})

# Проверяем, получили ли мы ID
if [ -z "$CONTAINER_ID" ]; then
    echo "Контейнер для сервиса '${SERVICE_NAME}' не найден или не запущен! Убедитесь, что 'docker-compose up -d' выполнен."
    exit 1
fi
# Получаем имя контейнера по ID (для логов)
CONTAINER_NAME=$(docker ps --format '{{.Names}}' -f id=${CONTAINER_ID})
echo "Найден запущенный контейнер: ${CONTAINER_NAME} (ID: ${CONTAINER_ID})"

# Проверяем существование локальной директории media
if [ ! -d "$LOCAL_MEDIA_DIR" ]; then
    echo "Локальная директория $LOCAL_MEDIA_DIR не найдена!"
    exit 1
fi

# Проверяем, пуста ли директория
if [ -z "$(ls -A $LOCAL_MEDIA_DIR)" ]; then
   echo "Локальная директория $LOCAL_MEDIA_DIR пуста. Копирование не требуется."
   exit 0
fi

echo "Копирование медиа-файлов из $LOCAL_MEDIA_DIR в Docker-контейнер ${CONTAINER_NAME}..."
# Используем ID контейнера для копирования
docker cp "$LOCAL_MEDIA_DIR/." "${CONTAINER_ID}:/app/media/"

echo "Установка правильных прав доступа внутри контейнера..."
# Используем ID контейнера для выполнения команды
docker exec "$CONTAINER_ID" sh -c "chown -R appuser:app /app/media && chmod -R 755 /app/media"

echo "Медиа-файлы успешно скопированы и права установлены!"