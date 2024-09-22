[app]
%{ for name, ip in app_instances ~}
${name} ansible_host=${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/pasha/.ssh/aws/homework-key.pem
%{ endfor ~}
