#!/bin/bash
apt update
apt install -y git python3-pip awscli mariadb-client default-libmysqlclient-dev build-essential pkg-config

REGION="eu-central-1"

export FLASK_CONFIG=$(aws ssm get-parameter \
                        --name /db/FLASK_CONFIG \
                        --region "$REGION" \
                        --query "Parameter.Value" \
                        --output text
                    )
export MYSQL_USER="$(aws ssm get-parameter \
                       --name /db/MYSQL_USER \
                       --region "$REGION" \
                       --query "Parameter.Value" \
                       --output text
                   )"
export MYSQL_PASSWORD="$(aws ssm get-parameter \
                           --name /db/MYSQL_PASSWORD \
                           --region "$REGION" \
                           --query "Parameter.Value" \
                           --output text \
                           --with-decryption
                       )"
export MYSQL_DB="$(aws ssm get-parameter \
                     --name /db/MYSQL_DB \
                     --region "$REGION" \
                     --query "Parameter.Value" \
                     --output text
                 )"
export MYSQL_HOST="$(aws ssm get-parameter \
                       --name /db/MYSQL_HOST \
                       --region "$REGION" \
                       --query "Parameter.Value" \
                       --output text
                   )"

git clone https://github.com/saaverdo/flask-alb-app -b orm /home/ubuntu/flask-alb-app
cd /home/ubuntu/flask-alb-app || exit
pip install -r requirements.txt --no-cache-dir
gunicorn -b 0.0.0.0 appy:app
