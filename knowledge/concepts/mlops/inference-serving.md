---
title: "Inference Serving"
aliases: [model-serving]
tags: [mlops, deployment]
sources:
  - "raw/Containerization.md"
created: 2026-04-09
updated: 2026-04-09
---

# Inference Serving

Inference Serving — процесс предоставления доступа к обученной ML-модели через API для выполнения предсказаний в реальном времени или батчами.

## Специализированные серверы

Для промышленного использования (особенно с GPU) применяются готовые Docker-образы со специализированным ПО:
- **Triton Inference Server (NVIDIA):** Поддержка множества фреймворков, динамическое батчирование, конкурентное выполнение моделей.
- **TorchServe (PyTorch):** Официальный инструмент для моделей на PyTorch.
- **vLLM:** Оптимизированный сервер для инференса больших языковых моделей (LLM).
- **TFServing (TensorFlow):** Стандарт для моделей TensorFlow.

## Ключевые функции

- **Model Versioning:** Поддержка нескольких версий модели одновременно.
- **Dynamic Batching:** Объединение индивидуальных запросов в группы для более эффективного использования GPU.
- **Multi-model serving:** Запуск нескольких разных моделей на одном инстансе/GPU.
- **Metrics/Monitoring:** Встроенные эндпоинты для Prometheus (Latency, Throughput, GPU utilization).

## Связанные концепции

- [[concepts/devops/containerization]] - Способ доставки сервера.
- [[concepts/devops/kubernetes]] - Среда для масштабирования сервисов инференса.
- [[concepts/mlops/mlops]] - Инференс как финальная стадия жизненного цикла модели.

## Источники

- [[raw/Containerization.md]] - Список инструментов и специфика GPU.
