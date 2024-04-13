#!/bin/bash
REGION="eu-central-1"
env_file="/home/ubuntu/app.env"

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-agent-config
declare -A env_variables=(
  ["FLASK_CONFIG"]=$(aws ssm get-parameter --name /db/FLASK_CONFIG --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_USER"]=$(aws ssm get-parameter --name /db/MYSQL_USER --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_PASSWORD"]=$(aws ssm get-parameter --name /db/MYSQL_PASSWORD --region "$REGION" --query "Parameter.Value" --output text --with-decryption)
  ["MYSQL_DB"]=$(aws ssm get-parameter --name /db/MYSQL_DB --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_HOST"]=$(aws ssm get-parameter --name /db/MYSQL_HOST --region "$REGION" --query "Parameter.Value" --output text)
)

for key in "${!env_variables[@]}"; do
    value="${env_variables[$key]}"
    echo "$key=$value" >> "$env_file"
done

systemctl start app
