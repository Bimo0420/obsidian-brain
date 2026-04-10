**Docker Compose** — инструмент для декларативного описания и запуска многоконтейнерных приложений. Весь стек (API, БД, кэш, reverse proxy) описывается в одном файле `docker-compose.yml` и поднимается одной командой.

## Структура `docker-compose.yml`
```text
version: "3.9"  # версия синтаксиса Compose

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    image: myapp:latest
    container_name: api
    ports:
      - "8000:8000"
    environment:
      - ENV=production
    env_file:
      - .env
    volumes:
      - ./app:/app           # bind mount
      - model_data:/models   # named volume
    networks:
      - backend
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 4g
          cpus: "2"
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - pg_data:/var/lib/postgresql/data
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  pg_data:
  model_data:

networks:
  backend:
    driver: bridge
```

## Основные команды
### Управление стеком
|Команда|Описание|
|---|---|
|`docker compose up -d`|Запустить все сервисы в фоне [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose up -d --build`|Запустить с пересборкой образов [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose up -d service`|Запустить только один конкретный сервис [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose down`|Остановить и удалить контейнеры + сети [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose down -v`|То же + удалить все volumes [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose down --rmi all`|То же + удалить все образы [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose stop`|Остановить контейнеры без удаления [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose start`|Запустить остановленные контейнеры [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose restart`|Перезапустить все сервисы [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose restart service`|Перезапустить один сервис [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose pause`|Заморозить контейнеры (SIGPAUSE) [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose unpause`|Разморозить контейнеры [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
### Сборка образов
|Команда|Описание|
|---|---|
|`docker compose build`|Собрать все образы [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose build service`|Собрать образ конкретного сервиса [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose build --no-cache`|Собрать без кэша [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose pull`|Обновить образы из registry [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose push`|Отправить образы в registry [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
### Мониторинг и отладка
|Команда|Описание|
|---|---|
|`docker compose ps`|Статус всех сервисов [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose logs -f`|Логи всех сервисов в реальном времени [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose logs -f service`|Логи конкретного сервиса [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose logs --tail 100`|Последние 100 строк логов [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose top`|Процессы внутри каждого контейнера [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose stats`|Потребление ресурсов в реальном времени [](https://habr.com/ru/articles/913978/)​|
|`docker compose events`|Поток событий (запуск, остановка, рестарт) [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)|
### Выполнение команд
|Команда|Описание|
|---|---|
|`docker compose exec service bash`|Войти в запущенный контейнер [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose exec service python manage.py migrate`|Выполнить команду в запущенном сервисе [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose run --rm service pytest`|Запустить одноразовый контейнер и удалить его [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose run -p 8001:8000 service`|Запустить с другим маппингом портов [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose cp service:/app/logs ./logs`|Скопировать файлы из контейнера [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
## Несколько файлов Compose: override

Compose поддерживает слоёную конфигурацию — базовый файл переопределяется оверрайдами.[](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​

```bash

# По умолчанию Compose читает оба файла и мёржит их:
# docker-compose.yml + docker-compose.override.yml

# Явное указание файлов:
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Типичная структура:
# docker-compose.yml       — базовая конфигурация
# docker-compose.override.yml  — dev (bind mounts, debug порты)
# docker-compose.prod.yml  — prod (resource limits, restart policies)
```

### Переменные окружения
```bash

# .env файл в корне проекта — читается автоматически
POSTGRES_PASSWORD=secret
API_PORT=8000
MODEL_TAG=v1.2.3
```

```text

# Использование в docker-compose.yml
services:
  api:
    image: myapp:${MODEL_TAG}
    ports:
      - "${API_PORT}:8000"
```

Приоритет переопределения (от высокого к низкому): `docker compose run -e VAR=val` → переменные оболочки → `.env` файл → `environment:` в yml.

## Healthcheck и depends_on
`depends_on` по умолчанию ждёт только **запуска** контейнера, не его готовности. Чтобы ждать реальной готовности сервиса — нужен `healthcheck` + `condition`.[](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​

```text
services:
  app:
    depends_on:
      db:
        condition: service_healthy   # ждать healthy статуса
      redis:
        condition: service_started   # просто запуска

  db:
    image: postgres:16
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
```

## Политики перезапуска
 `restart`/ `restart_policy`

| Политика         | Поведение                                                                                                                                         |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `no`             | Не перезапускать (по умолчанию) [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​                                                     |
| `always`         | Всегда перезапускать, даже при ручной остановке [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​                                     |
| `unless-stopped` | Перезапускать, кроме случаев ручной остановки — **рекомендуется для продакшна** [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​ |
| `on-failure`     | Только при ненулевом exit code [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​                                                      |
| `on-failure:3`   | Не более 3 попыток перезапуска [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​                                                      |
## Именование и изоляция проектов
По умолчанию Compose использует имя директории как имя проекта — это префикс для контейнеров, сетей и volumes.
```bash

# Задать имя проекта явно (исключает конфликты при нескольких стеках)
docker compose -p myproject up -d

# Через переменную окружения
COMPOSE_PROJECT_NAME=myproject docker compose up -d

# Список всех проектов
docker compose ls
```

## Типичный рабочий процесс
```bash

# 1. Первый запуск (сборка + старт)
docker compose up -d --build

# 2. Смотрим логи при старте
docker compose logs -f

# 3. Обновили код — пересобрать только нужный сервис
docker compose build api && docker compose up -d api

# 4. Отладка внутри сервиса
docker compose exec api bash

# 5. Сбросить всё до чистого состояния (включая данные!)
docker compose down -v && docker compose up -d --build
```

**Важно:** `docker compose down -v` удаляет все именованные volumes — используй осторожно в продакшене, это уничтожит данные БД и других сервисов с персистентным хранилищем.