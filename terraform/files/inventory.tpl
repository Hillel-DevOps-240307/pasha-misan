[app]
%{ for name, ip in app_instances ~}
${name} ansible_host=${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/pasha/.ssh/aws/homework-key.pem
%{ endfor ~}

[all:vars]
rds_endpoint=${rds_endpoint}
db_name=${db_name}
db_master_user=${db_master_user}
db_master_password=${db_master_password}
