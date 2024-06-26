[Unit]
Description=Simple app
After=network.target

[Service]
User=ubuntu
Group=ubuntu
Environment="FLASK_CONFIG={{ flask_config }}"
Environment="MYSQL_USER={{ mysql_user }}"
Environment="MYSQL_PASSWORD={{ mysql_password }}"
Environment="MYSQL_DB={{ mysql_db }}"
Environment="MYSQL_HOST=${mysql_host}"
WorkingDirectory=/home/ubuntu/flask-alb-app
ExecStart=gunicorn -b 0.0.0.0:8000 appy:app
Restart=no

[Install]
WantedBy=multi-user.target
