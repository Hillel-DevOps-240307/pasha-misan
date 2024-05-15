#!/bin/bash
REGION="eu-central-1"
env_file="/home/ubuntu/app.env"

declare -A env_variables=(
  ["FLASK_CONFIG"]=$(aws ssm get-parameter --name /db/FLASK_CONFIG --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_USER"]=$(aws ssm get-parameter --name /db/MYSQL_USER --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_PASSWORD"]=$(aws ssm get-parameter --name /db/MYSQL_PASSWORD --region "$REGION" --query "Parameter.Value" --output text --with-decryption)
  ["MYSQL_DB"]=$(aws ssm get-parameter --name /db/MYSQL_DB --region "$REGION" --query "Parameter.Value" --output text)
)

for key in "${!env_variables[@]}"; do
    value="${env_variables[$key]}"
    echo "$key=$value" >> "$env_file"
done
