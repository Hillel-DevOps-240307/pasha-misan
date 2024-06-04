#!/bin/bash

export FLASK_CONFIG=mysql
export MYSQL_USER="admin"
export MYSQL_PASSWORD="Pa55WD"
export MYSQL_DB="${db_name}"
export MYSQL_HOST=${db_host}

cd /home/ubuntu/flask-alb-app
gunicorn -b 0.0.0.0 appy:app
