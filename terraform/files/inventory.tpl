[app]
%{ for name, ip in app_instances ~}
${name} ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}

[db]
${db_instance_name} ansible_host=${db_instance_ip} ansible_user=ubuntu
