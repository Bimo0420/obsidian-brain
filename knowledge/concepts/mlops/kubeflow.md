---
title: "Kubeflow"
aliases: []
tags: [mlops, orchestration, kubernetes]
sources:
  - "raw/Containerization.md"
created: 2026-04-09
updated: 2026-04-09
---

# Kubeflow

Kubeflow — это cloud-native платформа с открытым исходным кодом, предназначенная для развертывания пайплайнов машинного обучения на Kubernetes.

## Основные задачи

- **Kubeflow Pipelines:** Управление сложными графами обучения (DAG).
- **Katib:** Автоматизация подбора гиперпараметров.
- **Notebooks:** Запуск Jupyter Notebooks в изолированных контейнерах.
- **Model Serving:** Интеграция с инструментами типа KFServing (KServe) для деплоя моделей.

## Почему это важно

Kubeflow объединяет возможности Kubernetes с нуждами Data Science, позволяя абстрагироваться от инфраструктуры и сосредоточиться на моделях, при этом сохраняя все преимущества контейнерной оркестрации (масштабируемость, GPU-allocation).

## Связанные концепции

- [[concepts/devops/kubernetes]] - Базовая платформа.
- [[concepts/mlops/mlops]] - Основной стек для реализации практик MLOps.

## Источники

- [[raw/Containerization.md]] - Упоминание как надстройки над K8s для ML-задач.
