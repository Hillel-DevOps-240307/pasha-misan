#!/bin/bash
apt update
apt install -y mariadb-server awscli

internal_ip=$(hostname -I | awk '{print $1}')
aws ssm put-parameter --name "/db/MYSQL_HOST" --value "$internal_ip" --type "String" --overwrite --region eu-central-1

script_path="/home/ubuntu/init.sh"
aws s3 cp s3://hw-3-bucket/init.sh $script_path
chmod +x $script_path
$script_path
