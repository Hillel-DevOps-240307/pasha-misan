#!/bin/bash
mv /tmp/app.service /etc/systemd/system/app.service

cd /home/ubuntu/flask-alb-app
pip install -r requirements.txt --no-cache-dir
