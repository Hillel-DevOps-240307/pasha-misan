## Intro

- `BUCKET_NAME`
- `INIT_SCRIPT_NAME`

---

## Налаштування S3 bucket

### 1. Створення S3 bucket

```
aws s3 mb s3://"$BUCKET_NAME" \
    | tee output/hw_3/create_bucket.txt
```

> [Вивід](output/hw_3/create_bucket.txt)

### 2. Додавання тегу для створеного bucket

```
aws s3api put-bucket-tagging \
    --bucket "$BUCKET_NAME" \
    --tagging 'TagSet=[{Key=task,Value=3}]'
```

> Команда нічого не повертає.

### 3. Запис init скрипту для бд

```
aws s3 cp scripts/db.sh s3://"$BUCKET_NAME"/"$INIT_SCRIPT_NAME" \
    | tee output/hw_3/cp_bucket.txt
```

> [Вивід](output/hw_3/cp_bucket.txt)

### 4. Додавання тегу для записаного файлу

```
aws s3api put-object-tagging \
    --bucket "$BUCKET_NAME" \
    --key "$INIT_SCRIPT_NAME" \
    --tagging "TagSet=[{Key=task,Value=3}]"
```

> Команда нічого не повертає.

## Додавання параметрів до ssm

- FLASK_CONFIG

```
aws ssm put-parameter \
    --name "FLASK_CONFIG" \
    --value "mysql" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_USER

```
aws ssm put-parameter \
    --name "MYSQL_USER" \
    --value "admin" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_PASSWORD

```
aws ssm put-parameter \
    --name "MYSQL_PASSWORD" \
    --value "Pa55WD" \
    --type SecureString \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_DB

```
aws ssm put-parameter \
    --name "MYSQL_DB" \
    --value "flask_db" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_HOST

```
aws ssm put-parameter \
    --name "MYSQL_HOST" \
    --value "127.0.0.1" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

> [Сукупний вивід](output/hw_3/create_params.txt)
