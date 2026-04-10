---
title: "Kubernetes"
aliases: [k8s, кубер]
tags: [devops, orchestration, mlops]
sources:
  - "raw/Containerization.md"
created: 2026-04-09
updated: 2026-04-09
---

# Kubernetes

Kubernetes — платформа оркестрации контейнеров промышленного уровня, используемая в MLOps для масштабирования, обеспечения отказоустойчивости и управления нагрузкой ML-сервисов.

## Ключевые возможности в ML

| Возможность | Описание |
| ----------- | -------- |
| **Horizontal Pod Autoscaling** | Авто-масштабирование по CPU/GPU-нагрузке. |
| **Rolling Updates** | Zero-downtime деплой новых версий моделей. |
| **Canary Deployments** | Постепенный роллаут (например, сначала 10% трафика на новую модель). |
| **Persistent Volumes** | Хранение весов моделей и данных вне жизненного цикла контейнера. |
| **Resource Limits** | Жесткое ограничение ресурсов (GPU/CPU/RAM) на уровне Pod. |

## ML-специфичные расширения

- **Kubeflow:** Платформа для управления пайплайнами обучения и деплоя поверх K8s.
- **NVIDIA Device Plugin:** Позволяет K8s выделять GPU как ресурс.
- **Seldon / BentoML:** Инструменты для продвинутого Serving (развертывания) моделей.

## Связанные концепции

- [[concepts/devops/containerization]] - Базовая единица (контейнер).
- [[concepts/mlops/kubeflow]] - Оркестрация ML-пайплайнов.
- [[concepts/devops/gitops]] - Современный подход к управлению кластером.

## Источники

- [[raw/Containerization.md]] - Руководство по контейнеризации и оркестрации.
