#!/bin/bash

SSH_CONFIG_FILE=~/.ssh/aws/config

instance_info=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" | jq -r '.Reservations[].Instances[]')

public_ip_front=$(echo "$instance_info" | jq -r 'select(.Tags[] | .Key == "Name" and .Value == "homework-front-server") | .PublicIpAddress')
private_ip_db=$(echo "$instance_info" | jq -r 'select(.Tags[] | .Key == "Name" and .Value == "homework-db-server") | .PrivateIpAddress')

if [ -n "$public_ip_front" ]; then
    sed -i "/^host aws-web$/,/^$/ s/HostName [0-9.]\+/HostName $public_ip_front/" "$SSH_CONFIG_FILE"
fi

if [ -n "$private_ip_db" ]; then
    sed -i "/^host db-host$/,/^$/ s/HostName [0-9.]\+/HostName $private_ip_db/" "$SSH_CONFIG_FILE"
fi
