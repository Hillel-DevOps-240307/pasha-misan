## Intro

- `BUCKET_NAME`
- `INIT_SCRIPT_NAME`
- `ACCOUNT_ID`
- `READ_DB_PARAMS_POLICY_NAME`
- `GET_INIT_POLICY_NAME`
- `UPDATE_HOST_PARAM_POLICY_NAME`
- `APP_ROLE_NAME`
- `DB_ROLE_NAME`
- `APP_PROFILE_NAME`
- `DB_PROFILE_NAME`
- `AMI_ID`
- `SG_APP_ID`
- `SG_DB_ID`
- `APP_SUBNET_ID`
- `DB_SUBNET_ID`

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

> [Скрипт](scripts/db.sh) взяв з попередньої домашки

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
    --name "/db/FLASK_CONFIG" \
    --value "mysql" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_USER

```
aws ssm put-parameter \
    --name "/db/MYSQL_USER" \
    --value "admin" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_PASSWORD

```
aws ssm put-parameter \
    --name "/db/MYSQL_PASSWORD" \
    --value "Pa55WD" \
    --type SecureString \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_DB

```
aws ssm put-parameter \
    --name "/db/MYSQL_DB" \
    --value "flask_db" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

- MYSQL_HOST

```
aws ssm put-parameter \
    --name "/db/MYSQL_HOST" \
    --value "127.0.0.1" \
    --type String \
    --tags "Key=task,Value=3" \
    | tee -a output/hw_3/create_params.txt
```

> [Сукупний вивід](output/hw_3/create_params.txt)

## Створення політик

### 1. Створення політики отримання доступу до параметрів пов'язаних з бд

```
aws iam create-policy \
    --policy-name "$READ_DB_PARAMS_POLICY_NAME" \
    --policy-document file://policies/read_ssm_db_params.json \
    --tags Key=task,Value=3 \
    | tee output/hw_3/create_db_params_policy.json
```

> [Вивід](output/hw_3/create_db_params_policy.json)

### 2. Створення політики отримання доступу до init скрипту бд

```
aws iam create-policy \
    --policy-name "$GET_INIT_POLICY_NAME" \
    --policy-document file://policies/get_init_script.json \
    --tags Key=task,Value=3 \
    | tee output/hw_3/create_init_script_policy.json
```
> [Вивід](output/hw_3/create_init_script_policy.json)


### 3. Створення політики оновлення внутрішньої адреси бд

```
aws iam create-policy \
    --policy-name "$UPDATE_HOST_PARAM_POLICY_NAME" \
    --policy-document file://policies/update_host_param.json \
    --tags Key=task,Value=3 \
    | tee output/hw_3/create_host_update_policy.json
```

> [Вивід](output/hw_3/create_host_update_policy.json)

## Налаштування ролей

### 1. Створення ролі для `APP`

```
aws iam create-role \
    --role-name "$APP_ROLE_NAME" \
    --assume-role-policy-document file://policies/role.json \
    --tags Key=task,Value=3 \
    | tee output/hw_3/create_app_role.json
```

> [Вивід](output/hw_3/create_app_role.json)

### 2. Створення ролі для `DB`

```
aws iam create-role \
    --role-name "$DB_ROLE_NAME" \
    --assume-role-policy-document file://policies/role.json \
    --tags Key=task,Value=3 \
    | tee output/hw_3/create_db_role.json
```

> [Вивід](output/hw_3/create_db_role.json)

### 3. Приєднання політики до ролі для `APP`

```
aws iam attach-role-policy \
    --role-name "$APP_ROLE_NAME" \
    --policy-arn arn:aws:iam::"$ACCOUNT_ID":policy/"$READ_DB_PARAMS_POLICY_NAME"
```

> Команда нічого не повертає.

### 4. Приєднання політик до ролі для `DB`

```
aws iam attach-role-policy \
    --role-name "$DB_ROLE_NAME" \
    --policy-arn arn:aws:iam::"$ACCOUNT_ID":policy/"$GET_INIT_POLICY_NAME"
```

> Команда нічого не повертає.

```
aws iam attach-role-policy \
    --role-name "$DB_ROLE_NAME" \
    --policy-arn arn:aws:iam::"$ACCOUNT_ID":policy/"$UPDATE_HOST_PARAM_POLICY_NAME"
```

> Команда нічого не повертає.

## Налаштування інстансів

### 1. Створення інстанс профайлу для `APP`

```
aws iam create-instance-profile \
    --instance-profile-name "$APP_PROFILE_NAME" \
    --tags Key=task,Value=3 \
    | tee output/hw_3/create_app_profile.json
```

> [Вивід](output/hw_3/create_app_profile.json)

### 2. Створення інстанс профайлу для `DB`

```
aws iam create-instance-profile \
    --instance-profile-name "$DB_PROFILE_NAME" \
    --tags Key=task,Value=3 \
    | tee output/hw_3/create_db_profile.json
```

> [Вивід](output/hw_3/create_app_profile.json)

### 3. Додавання ролі до інстанс профайлу для `APP`

```
aws iam add-role-to-instance-profile \
    --role-name "$APP_ROLE_NAME" \
    --instance-profile-name "$APP_PROFILE_NAME"
```

> Команда нічого не повертає.

### 4. Додавання ролі до інстанс профайлу для `DB`

```
aws iam add-role-to-instance-profile \
    --role-name "$DB_ROLE_NAME" \
    --instance-profile-name "$DB_PROFILE_NAME"
```

> Команда нічого не повертає.

### 5. Створення `DB` інстансу:

```
aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type t2.micro \
    --iam-instance-profile Name="$DB_PROFILE_NAME" \
    --key-name homework-key \
    --security-group-ids $SG_DB_ID \
    --subnet-id $DB_SUBNET_ID \
    --user-data file://scripts/hw_3/db.sh \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=task,Value=3},{Key=Name,Value=DB}]' \
    | tee output/hw_3/create_db_instance.json
```

> [Вивід](output/hw_3/create_db_instance.json)

### 6. Створення `APP` інстансу:

```
aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type t2.micro \
    --iam-instance-profile Name="$APP_PROFILE_NAME" \
    --key-name homework-key \
    --security-group-ids $SG_APP_ID $SG_DB_ID \
    --user-data file://scripts/hw_3/app.sh \
    --subnet-id $APP_SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=task,Value=3},{Key=Name,Value=APP}]' \
    | tee output/hw_3/create_app_instance.json
```

> [Вивід](output/hw_3/create_app_instance.json)
