Опис
--------------

Доступно два оточення, а саме [prod](environments/prod) та [stage](environments/stage).

Кожне оточення містить в собі папку group_vars зі змінними відповідно до кожної групи хостів, та inventory файл для
свого оточення.

Приклад запуску
--------------

- для prod оточення

```
ansible-playbook -i environments/prod/inventory --ask-vault-pass deploy.yml
```

- для stage оточення

```
ansible-playbook -i environments/stage/inventory --ask-vault-pass deploy.yml
```

** vault пароль для демонстарції роботи - '12345'
