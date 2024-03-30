#!/bin/bash
REGION="eu-central-1"
environment_file="/etc/bash.bashrc"

declare -A env_variables=(
  ["FLASK_CONFIG"]=$(aws ssm get-parameter --name /db/FLASK_CONFIG --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_USER"]=$(aws ssm get-parameter --name /db/MYSQL_USER --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_PASSWORD"]=$(aws ssm get-parameter --name /db/MYSQL_PASSWORD --region "$REGION" --query "Parameter.Value" --output text --with-decryption)
  ["MYSQL_DB"]=$(aws ssm get-parameter --name /db/MYSQL_DB --region "$REGION" --query "Parameter.Value" --output text)
  ["MYSQL_HOST"]=$(aws ssm get-parameter --name /db/MYSQL_HOST --region "$REGION" --query "Parameter.Value" --output text)
)

for key in "${!env_variables[@]}"; do
  value="${env_variables[$key]}"
  if grep -q "export $key=" "$environment_file"; then
      sed -i "s/^export $key=.*/export $key=\"$value\"/" "$environment_file"
  else
      echo "export $key=\"$value\"" >> "$environment_file"
  fi
  export "$key=$value"
done

source "$environment_file"
