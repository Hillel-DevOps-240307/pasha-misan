#!/bin/bash
mysql -e " CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'Pa55WD';
SELECT user FROM mysql.user;
create database flask_db;
grant ALL on flask_db.* to  'admin'@'%';
SHOW DATABASES;"
echo -e "[mysqld]\nbind-address = 0.0.0.0" | sudo tee -a /etc/mysql/my.cnf
sudo systemctl restart mysql.service
