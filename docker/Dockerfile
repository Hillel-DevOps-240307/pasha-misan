FROM python:3.9.19-alpine

RUN apk update && apk add --no-cache \
    git \
    py3-pip \
    mariadb-client \
    mariadb-connector-c-dev \
    gcc \
    musl-dev \
    libffi-dev \
    build-base \
    pkgconf

ENV FLASK_CONFIG=mysql
ENV MYSQL_USER="admin"
ENV MYSQL_PASSWORD="Pa55WD"
ENV MYSQL_DB="flask_db"
ENV MYSQL_HOST="db_server"

WORKDIR /app

RUN git clone https://github.com/saaverdo/flask-alb-app -b orm /app && \
    pip install --no-cache-dir -r /app/requirements.txt

ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8000", "appy:app"]
