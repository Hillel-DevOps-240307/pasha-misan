#!/bin/bash
internal_ip=$(hostname -I | awk '{print $1}')
aws ssm put-parameter --name "/db/MYSQL_HOST" --value "$internal_ip" --type "String" --overwrite --region eu-central-1
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-agent-config
