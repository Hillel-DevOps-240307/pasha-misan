APP role
=========

Роль розгортає необхідні пакети для роботи додатку flask-alb-app.

Role Variables
--------------

```
prepare_host_packages:
  - git
  - python3-pip
  - ...
```
Список пакетів до інсталювання.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: servers
      roles:
         - app
