Контейнеризация — фундаментальная практика современного MLOps, которая решает главную проблему воспроизводимости: модель работает одинаково на ноутбуке дата-сайентиста, в CI/CD-пайплайне и на продакшн-сервере. Контейнер упаковывает приложение вместе с зависимостями, конфигурацией и системными библиотеками в изолированный исполняемый образ.[](https://www.clarifai.com/blog/mlops-best-practices)

## Зачем это нужно в ML

ML-проекты страдают от «dependency hell» острее, чем обычный софт: конфликты версий CUDA, torch, numpy, несовместимость системных библиотек и зависимость от аппаратного окружения — всё это убивает воспроизводимость экспериментов и деплоя.

Ключевые проблемы, которые решает контейнеризация:
- **Воспроизводимость** — одинаковое окружение на любой машине: dev, staging, production
- **Изоляция** — разные версии Python, CUDA, фреймворков в разных контейнерах без конфликтов​
- **Портируемость** — один образ работает локально, на GCP, AWS, bare-metal
- **Версионирование окружения** — образ привязан к конкретному состоянию кода + зависимостей, как DVC для данных[](https://mws.ru/blog/chto-takoe-ml-ops/)​

## [[Docker. Основные команды]]: базовый инструмент
Docker — стандарт де-факто для сборки образов. В ML-контексте Dockerfile описывает: базовый образ (например, `nvidia/cuda`), установку зависимостей, копирование кода модели и команду запуска inference-сервиса.[](https://github.com/AlexIoannides/kubernetes-mlops)​

**Важные практики Docker в MLOps:**
- Использовать multi-stage builds — отдельный образ для обучения (тяжёлый) и для inference (лёгкий)
- Не хранить данные и веса моделей внутри образа — монтировать через **Volumes**​
- Фиксировать теги образов (`model:v1.2.3`), не использовать `latest` в проде
- Задавать `imagePullPolicy: Always` для Kubernetes-деплоя[](https://dev.to/aman_nkh/my-first-mlops-project-from-model-training-to-kubernetes-deployment-pni)​

## Docker Compose: локальная оркестрация
Для локальной разработки и MVP Docker Compose позволяет поднять весь стек одной командой. В типичном MLOps-проекте это: inference API + база данных + observability + reverse proxy.​

## Kubernetes: production-оркестрация
Kubernetes (кубер) — следующий уровень после Docker Compose, используется когда нужны масштабирование, отказоустойчивость и управление нагрузкой.[](https://texple.com/building-a-scalable-mlops-pipeline-on-kubernetes/)​

|Возможность|Описание|
|---|---|
|**Horizontal Pod Autoscaling**|Авто-масштабирование по CPU/GPU-нагрузке [](https://texple.com/building-a-scalable-mlops-pipeline-on-kubernetes/)​|
|**Rolling Updates**|Zero-downtime деплой новых версий моделей [](https://www.testmuai.com/blog/devops-best-practices/)​|
|**Canary Deployments**|Постепенный роллаут: сначала 10% трафика на новую версию [](https://www.theaiservicescompany.com/blog/machine-learning-operations-mlops-complete-guide-2025)​|
|**Persistent Volumes**|Хранение весов моделей и данных вне контейнера [](https://texple.com/building-a-scalable-mlops-pipeline-on-kubernetes/)​|
|**Resource Limits**|Ограничение GPU/CPU/RAM на pod уровне [](https://www.linkedin.com/pulse/building-end-to-end-mlops-pipeline-from-model-training-ashmit-sinha-r0edf)​|
Для ML-специфичных задач поверх K8s ставят **Kubeflow** — управление пайплайнами обучения, гиперпараметрической оптимизацией и serving.

## CI/CD и контейнеры
В MLOps-пайплайне контейнеризация интегрируется с CI/CD: при пуше кода GitHub Actions (или GitLab CI) автоматически собирает Docker-образ, прогоняет тесты и пушит в registry.
```text

# GitLab CI пример
build:
  stage: build
  script:
    - docker build -t ml-model:$CI_COMMIT_SHA .
    - docker push registry/ml-model:$CI_COMMIT_SHA

```

Тренд 2025–2026 — **GitOps** (ArgoCD/Flux): конфигурация K8s-кластера хранится в Git, изменения в репо автоматически синхронизируются с кластером. Команды, использующие GitOps для app и model deployments, сокращают циклы переобучения на 50%.

## Специфика ML: GPU-контейнеры
Для GPU-workloads нужны дополнительные настройки:
- Базовый образ: `nvidia/cuda` или `pytorch/pytorch:*-cuda*`
- На хосте: **NVIDIA Container Toolkit** (`nvidia-docker2`) для проброса GPU в контейнер
- В K8s: **NVIDIA Device Plugin** для allocation GPU как ресурса (`nvidia.com/gpu: 1`)
- Для inference: специализированные серверы — **Triton Inference Server**, **TorchServe**, **vLLM** — часто поставляются как готовые Docker-образы[](https://www.theaiservicescompany.com/blog/machine-learning-operations-mlops-complete-guide-2025)

## Ключевые инструменты
| Слой                   | Инструменты                                                              |
| ---------------------- | ------------------------------------------------------------------------ |
| Сборка образов         | Docker, Buildah, Kaniko                                                  |
| Локальная оркестрация  | Docker Compose                                                           |
| Production-оркестрация | Kubernetes, K3s (lightweight)                                            |
| ML-пайплайны на K8s    | Kubeflow, Argo Workflows                                                 |
| Registry               | Docker Hub, GCR, GHCR, Harbor                                            |
| GitOps                 | ArgoCD, Flux                                                             |
| Service Mesh           | Istio, Linkerd [](https://www.testmuai.com/blog/devops-best-practices/)​ |

## Антипаттерны
- Хранить секреты и API-ключи прямо в Dockerfile или образе
- Запускать контейнер от `root` без необходимости
- Использовать тег `latest` в production — нет трассируемости версий
- Класть веса моделей (гигабайты) внутрь образа — раздувает registry и замедляет деплой
- Игнорировать `resource limits` в K8s — один ML-job может съесть все ресурсы ноды