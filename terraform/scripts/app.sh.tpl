#!/bin/bash

export FLASK_CONFIG=mysql
export MYSQL_USER="admin"
export MYSQL_PASSWORD="Pa55WD"
export MYSQL_DB="flask_db"
export MYSQL_HOST=${db_private_ip}

cd /home/ubuntu/flask-alb-app
gunicorn -b 0.0.0.0 appy:app
