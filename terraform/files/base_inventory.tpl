[app]
${app_instance_name} ansible_host=${app_instance_ip} ansible_user=ubuntu

[db]
${db_instance_name} ansible_host=${db_instance_ip} ansible_user=ubuntu
