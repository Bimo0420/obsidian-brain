---
title: "Docker Compose"
aliases: [compose]
tags: [devops, local-dev, orchestration]
sources:
  - "raw/Containerization.md"
  - "raw/Docker Compose. Полное руководство.md"
  - "raw/Docker. Основные команды.md"
created: 2026-04-09
updated: 2026-04-09
---

# Docker Compose

**Docker Compose** — инструмент для декларативного описания и запуска многоконтейнерных приложений. Позволяет описать весь стек (API, БД, кэш, reverse proxy) в одном файле `docker-compose.yml` и управлять им как единым целым.

В MLOps чаще всего используется для быстрой разработки, создания MVP и локального тестирования пайплайнов перед развертыванием в Kubernetes.

## Основные характеристики

- **Декларативность**: Описание желаемого состояния системы в YAML-формате.
- **Изоляция проектов**: Использование имен директорий или параметра `-p` для предотвращения конфликтов между разными стеками на одном хосте.
- **Управление зависимостями**: Контроль порядка запуска сервисов с помощью `depends_on` и `healthcheck`.
- **Конфигурационные слои**: Возможность переопределения базовых настроек через файлы оверрайдов (`docker-compose.override.yml`, `docker-compose.prod.yml`).
- **Персистентность данных**: Поддержка именованных volumes и bind mounts для сохранения данных между перезапусками.

## Команды и примеры

### Типичная структура `docker-compose.yml`

```yaml
version: "3.9"

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    image: myapp:latest
    ports:
      - "8000:8000"
    environment:
      - ENV=production
    volumes:
      - ./app:/app
      - model_data:/models
    networks:
      - backend
    depends_on:
      db:
        condition: service_healthy
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

### Основные команды управления

| Группа | Команда | Описание |
| --- | --- | --- |
| **Управление** | `up -d --build` | Запуск стека в фоне с пересборкой. |
| | `down -v` | Полная остановка с удалением контейнеров и volumes. |
| | `stop` / `start` | Остановка и запуск без удаления. |
| | `restart [service]` | Перезапуск всех или одного сервиса. |
| **Сборка** | `build --no-cache` | Сборка образов без использования кэша. |
| | `pull` / `push` | Загрузка/отправка образов в registry. |
| **Отладка** | `ps` | Статус всех сервисов в текущем проекте. |
| | `logs -f --tail 100` | Просмотр последних 100 строк логов в реальном времени. |
| | `exec [service] bash` | Вход в запущенный контейнер. |
| | `run --rm [service] cmd` | Запуск временного контейнера для разовой команды. |
| | `stats` | Мониторинг потребления ресурсов в реальном времени. |
| | `cp [service]:/path ./` | Копирование файлов из контейнера. |

### Работа с переменными окружения

Compose автоматически читает `.env` файл. Приоритет переопределения (от высокого к низкому):
1. `docker compose run -e VAR=val`
2. Переменные оболочки (shell variables)
3. `.env` файл
4. Раздел `environment` в YML

### Политики перезапуска (`restart`)

- `unless-stopped`: Перезапуск всегда, кроме ручной остановки (**рекомендовано для Prod**).
- `always`: Всегда перезапускать, даже если контейнер был остановлен вручную.
- `on-failure`: Перезапуск только при ошибках (exit code != 0).
- `no`: Не перезапускать (по умолчанию).

## Связанные концепции

- [[concepts/devops/containerization]] - Базовая технология изоляции.
- [[concepts/devops/kubernetes]] - Оркестрация для высоконагруженных продакшн-сред.
- [[concepts/mlops/inference-serving]] - Использование Compose для локального тестирования серверов предсказаний.

## Источники

- [[raw/Containerization.md]] - Общие сведения о контейнеризации.
- [[raw/Docker Compose. Полное руководство.md]] - Подробный разбор команд, синтаксиса и механик Healthcheck.
