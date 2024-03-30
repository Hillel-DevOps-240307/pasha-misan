#!/bin/bash
apt update
apt install -y git python3-pip awscli mariadb-client default-libmysqlclient-dev build-essential pkg-config

script_path="/home/ubuntu/update_env.sh"
aws s3 cp s3://hw-3-bucket/update_env.sh $script_path
chmod +x $script_path
source $script_path

git clone https://github.com/saaverdo/flask-alb-app -b orm /home/ubuntu/flask-alb-app
cd /home/ubuntu/flask-alb-app || exit
pip install -r requirements.txt --no-cache-dir
gunicorn -b 0.0.0.0 appy:app
