---
title: "Dockerfile"
aliases: [docker сборка, инструкции dockerfile]
tags: [devops, docker, build]
sources:
  - "raw/Docker. Основные команды.md"
created: 2026-04-09
updated: 2026-04-09
---

# Dockerfile

**Dockerfile** — это текстовый файл, содержащий последовательность команд (инструкций), которые Docker использует для автоматической сборки образа. Каждая инструкция создает новый слой в образе.

## Основные инструкции

| Инструкция | Описание |
| --- | --- |
| `FROM` | Задает базовый (родительский) образ. |
| `WORKDIR` | Устанавливает рабочую директорию для последующих команд. |
| `COPY` / `ADD` | Копирует файлы с хоста в образ. |
| `RUN` | Выполняет команду в процессе сборки (создает новый слой). |
| `ENV` | Устанавливает переменные окружения. |
| `EXPOSE` | Документирует порты, которые приложение слушает внутри контейнера. |
| `VOLUME` | Создает точку монтирования для внешних томов. |
| `ENTRYPOINT` | Настраивает контейнер для запуска как исполняемый файл (трудно переопределить). |
| `CMD` | Команда по умолчанию или аргументы для `ENTRYPOINT` (легко переопределить). |

## Пример Dockerfile для ML

```dockerfile
FROM nvidia/cuda:12.1-runtime-ubuntu22.04
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
ENV MODEL_PATH=/app/models
EXPOSE 8000
CMD ["python", "main.py"]
```

## Разница ENTRYPOINT vs CMD

- **ENTRYPOINT:** Главная команда контейнера. Например, `ENTRYPOINT ["python"]`.
- **CMD:** Параметры для команды по умолчанию. Например, `CMD ["main.py"]`.
При запуске `docker run image script.py` команда `CMD` будет заменена на `script.py`, и выполнится `python script.py`.

## Связанные концепции

- [[docker-images]] - Результат сборки Dockerfile.
- [[concepts/devops/containerization]] - Методология использования Dockerfile.

## Источники

- [[raw/Docker. Основные команды.md]] - Шпаргалка по основным командам Docker.
