# Copyright 2024-2025 Aleksejs Giruckis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    # Добавим переменные для базы данных по умолчанию
    PG_HOST=db \
    PG_PORT=5432 \
    # Добавим переменную для настроек Django
    DJANGO_SETTINGS_MODULE=itg.settings

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    netcat-traditional \
    gettext \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# Рекомендуется использовать --no-cache-dir
RUN pip install --no-cache-dir -r requirements.txt

# Копирование проекта ПОСЛЕ установки зависимостей
COPY . .

# Создание директорий для статических и медиа файлов
# Права лучше назначать после копирования и перед сменой пользователя
RUN mkdir -p /app/staticfiles /app/media

# Копирование entrypoint.sh и установка прав
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Создаем пользователя и группу appuser:app
RUN addgroup --system app && adduser --system --ingroup app --no-create-home appuser

# Назначаем права на все приложение и папки static/media
RUN chown -R appuser:app /app

# Переключаемся на пользователя
USER appuser

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]