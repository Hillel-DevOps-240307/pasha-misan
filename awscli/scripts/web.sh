#!/bin/bash
apt update
apt install -y git python3-pip awscli mariadb-client default-libmysqlclient-dev build-essential pkg-config

export FLASK_CONFIG=mysql
export MYSQL_USER="admin"
export MYSQL_PASSWORD="Pa55WD"
export MYSQL_DB="flask_db"
# приватна ip адреса db інстанса
export MYSQL_HOST="192.168.0.125"

git clone https://github.com/saaverdo/flask-alb-app -b orm /home/ubuntu/flask-alb-app
cd /home/ubuntu/flask-alb-app || exit
pip install -r requirements.txt --no-cache-dir
gunicorn -b 0.0.0.0 appy:app
