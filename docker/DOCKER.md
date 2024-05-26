### Встановлення лінтеру

```
wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
sudo mv hadolint-Linux-x86_64 /usr/local/bin/hadolint
sudo +x /lusr/local/bin/hadolint

```

### Cтворення Dockerfile та перевірка його лінтером

```
hadolint Dockerfile
```

### Збірка docker image

```
docker build -t flask-app -f Dockerfile .
```

### Запуск контейнеру з бд

```
docker run -d --rm --name mariadb \
  -e MARIADB_ROOT_PASSWORD=superpass \
  -v $(pwd)/init_db:/docker-entrypoint-initdb.d \
  -v db_volume:/var/lib/mysql \
  mariadb

```

### Запуск додатку

```
docker run -d --rm --name app -p 8000:8000 --link mariadb:db_server flask-app
```

### Логін на dockerhub

```
docker login -u pashamisan
```

### Тегування образу

```
docker tag flask-app:latest pashamisan/flask-app:1.0
```

### Push на dockerhub

```
docker push pashamisan/flask-app:1.0
```

## Критерій успішності

```
curl -I http://localhost:8000/ | tee output/curl.txt
```

> [Вивід](output/curl.txt)

Посилання на репозиторій

https://hub.docker.com/repository/docker/pashamisan/flask-app/general
