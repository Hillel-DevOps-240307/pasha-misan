DB role
=========

Роль розгортає необхідні пакети та налаштовує бд для роботи додатку flask-alb-app.

Role Variables
--------------

```
mysql_user: "user"
```

Ім'я юзера для бд.

```
mysql_password: "password"
```

Пароль юзера для бд.

```
mysql_db: "db_name"
```

Назва бд.

```
prepare_host_packages:
  - mariadb-server
  - python3-pip
  - ...
```

Список пакетів до інсталювання.

Example Playbook
----------------

    - hosts: servers
      roles:
         - db
