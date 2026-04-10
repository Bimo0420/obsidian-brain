**Docker** — инструмент контейнеризации, который упаковывает приложение и все его зависимости
в изолированный образ, запускаемый одинаково на любой машине.

## Образы (Images)
Образ — неизменяемый шаблон, из которого создаётся контейнер.[](https://1cloud.ru/help/docker/docker_image_work)​

|Команда|Описание|
|---|---|
|`docker build -t name:tag .`|Собрать образ из Dockerfile в текущей директории [](https://timeweb.com/ru/community/articles/osnovnye-komandy-docker)​|
|`docker pull nginx:latest`|Скачать образ из registry (DockerHub) [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker push user/image:tag`|Отправить образ в registry [](https://1cloud.ru/help/docker/docker_image_work)​|
|`docker images`|Показать все образы на хосте [](https://timeweb.com/ru/community/articles/osnovnye-komandy-docker)​|
|`docker rmi image:tag`|Удалить образ [](https://timeweb.com/ru/community/articles/osnovnye-komandy-docker)​|
|`docker image prune -a`|Удалить все неиспользуемые образы [](https://habr.com/ru/articles/913978/)​|
|`docker history image:tag`|Показать слои образа [](https://timeweb.com/ru/community/articles/osnovnye-komandy-docker)​|
|`docker inspect image:tag`|Подробная информация об образе [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
## Контейнеры (Containers)
Контейнер — запущенный экземпляр образа.[](https://1cloud.ru/help/docker/docker_container)​

|Команда|Описание|
|---|---|
|`docker run -d -p 8080:80 --name myapp nginx`|Создать и запустить контейнер в фоне [](https://1cloud.ru/help/docker/docker_container)​|
|`docker run -it ubuntu /bin/bash`|Запустить контейнер в интерактивном режиме [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker ps`|Показать запущенные контейнеры [](http://dockerrtd.readthedocs.io/text/01-docker/041_chapter4.html)​|
|`docker ps -a`|Показать все контейнеры (включая остановленные) [](http://dockerrtd.readthedocs.io/text/01-docker/041_chapter4.html)​|
|`docker stop <id/name>`|Остановить контейнер (graceful) [](https://1cloud.ru/help/docker/docker_container)​|
|`docker kill <id/name>`|Принудительно остановить контейнер [](https://habr.com/ru/companies/ruvds/articles/440660/)​|
|`docker start <id/name>`|Запустить остановленный контейнер [](http://dockerrtd.readthedocs.io/text/01-docker/041_chapter4.html)​|
|`docker restart <id/name>`|Перезапустить контейнер [](https://1cloud.ru/help/docker/docker_container)​|
|`docker rm <id/name>`|Удалить остановленный контейнер [](https://timeweb.com/ru/community/articles/osnovnye-komandy-docker)​|
|`docker rm -f <id/name>`|Принудительно удалить контейнер [](https://wiki.merionet.ru/articles/26-samyx-izvestnyx-komand-docker-s-primerami)​|
|`docker container prune`|Удалить все остановленные контейнеры [](https://habr.com/ru/articles/913978/)​|
### Взаимодействие с контейнером
|Команда|Описание|
|---|---|
|`docker exec -it <id> /bin/bash`|Войти в запущенный контейнер [](http://dockerrtd.readthedocs.io/text/01-docker/041_chapter4.html)​|
|`docker logs -f <id/name>`|Следить за логами в реальном времени [](https://habr.com/ru/companies/ruvds/articles/440660/)​|
|`docker logs --tail 100 <id>`|Последние 100 строк логов [](https://wiki.merionet.ru/articles/26-samyx-izvestnyx-komand-docker-s-primerami)​|
|`docker inspect <id/name>`|Полная информация о контейнере (IP, env, volumes) [](https://timeweb.com/ru/community/articles/osnovnye-komandy-docker)​|
|`docker stats`|Мониторинг ресурсов всех контейнеров в реальном времени [](https://habr.com/ru/articles/913978/)​|
|`docker top <id/name>`|Процессы внутри контейнера [](https://wiki.merionet.ru/articles/26-samyx-izvestnyx-komand-docker-s-primerami)​|
|`docker cp ./file <id>:/app/`|Скопировать файл с хоста в контейнер [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker cp <id>:/app/file .`|Скопировать файл из контейнера на хост [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
### Флаги `docker run`
```bash

docker run \
  -d \                        # detached (фоновый режим)
  -p 8080:80 \                # маппинг портов host:container
  -v ./data:/app/data \       # bind mount (папка с хоста)
  -v model_vol:/app/models \  # named volume
  --env-file .env \           # переменные окружения из файла
  -e API_KEY=secret \         # одна переменная окружения
  --name myapp \              # имя контейнера
  --network my-net \          # сеть
  --restart unless-stopped \  # политика перезапуска
  --gpus all \                # пробросить все GPU (NVIDIA)
  --memory 4g \               # лимит RAM
  --cpus 2 \                  # лимит CPU
  image:tag

```

## Тома (Volumes)
Volumes — механизм персистентного хранения данных вне контейнера.[](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​

|Команда|Описание|
|---|---|
|`docker volume create myvolume`|Создать именованный том [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker volume ls`|Список всех томов [](https://habr.com/ru/articles/913978/)​|
|`docker volume inspect myvolume`|Подробная информация + путь на хосте [](https://habr.com/ru/articles/913978/)​|
|`docker volume rm myvolume`|Удалить том [](https://habr.com/ru/articles/913978/)​|
|`docker volume prune`|Удалить все неиспользуемые тома [](https://habr.com/ru/articles/913978/)​|
## Сети (Networks)

|Команда|Описание|
|---|---|
|`docker network create mynet`|Создать сеть [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker network ls`|Список всех сетей [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker network inspect mynet`|Подробная информация о сети [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker network connect mynet <id>`|Подключить контейнер к сети [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker network disconnect mynet <id>`|Отключить контейнер от сети [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
|`docker network rm mynet`|Удалить сеть [](https://www.linuxshop.ru/articles/a26710824-osnovnye_komandy_dlya_docker)​|
## Docker Compose

|Команда|Описание|
|---|---|
|`docker compose up -d`|Поднять все сервисы в фоне [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose up -d --build`|Поднять с пересборкой образов [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose down`|Остановить и удалить контейнеры [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose down -v`|То же + удалить volumes [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose stop`|Остановить без удаления [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose restart`|Перезапустить все сервисы [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose logs -f`|Логи всех сервисов в реальном времени [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose logs -f service`|Логи конкретного сервиса [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose ps`|Состояние всех сервисов [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose exec service bash`|Войти в сервис [](https://dockerhosting.ru/blog/komandy-docker-shpargalka/)​|
|`docker compose pull`|Обновить образы из registry [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
|`docker compose build`|Пересобрать образы [](https://timeweb.cloud/tutorials/docker/komandy-docker-spisok)​|
## Глобальная очистка

```bash

# Удалить всё неиспользуемое (образы, контейнеры, сети, кеш)
docker system prune -a --volumes
# Показать занятое место
docker system df
```

`# Удалить всё неиспользуемое (образы, контейнеры, сети, кеш) docker system prune -a --volumes # Показать занятое место docker system df`

## Dockerfile: ключевые инструкции
```text

FROM nvidia/cuda:12.1-runtime-ubuntu22.04   # базовый образ
WORKDIR /app                                 # рабочая директория
COPY requirements.txt .                      # копировать файл
RUN pip install -r requirements.txt          # выполнить команду при сборке
ENV MODEL_PATH=/app/models                   # переменная окружения
EXPOSE 8000                                  # документировать порт
VOLUME ["/app/data"]                         # точка монтирования
ENTRYPOINT ["python"]                        # фиксированная точка входа
CMD ["main.py"]                              # аргументы по умолчанию
```

**Разница `ENTRYPOINT` vs `CMD`:** `ENTRYPOINT` — что запускать (нельзя переопределить без `--entrypoint`), `CMD` — аргументы по умолчанию (легко переопределяются при `docker run`). Вместе: `python main.py`.