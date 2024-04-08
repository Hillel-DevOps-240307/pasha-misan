#!/bin/bash
chmod +x /home/ubuntu/backup.sh
mv /tmp/backup.service /etc/systemd/system/backup.service
mv /tmp/backup.timer /etc/systemd/system/backup.timer

mysql -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'Pa55WD';
          SELECT user FROM mysql.user;
          CREATE DATABASE IF NOT EXISTS flask_db;
          GRANT ALL ON flask_db.* TO 'admin'@'%';
          SHOW DATABASES;"

echo -e "[mysqld]\nbind-address = 0.0.0.0" | tee -a /etc/mysql/my.cnf

systemctl restart mysql.service
systemctl enable --now backup.timer
