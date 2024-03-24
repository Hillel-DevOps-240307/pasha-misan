## Використані змінні

- `VPC_ID`
- `PUB_SUBNET_ID`
- `PRIV_SUBNET_ID`
- `GATEWAY_ID`
- `PUB_ROUTE_TABLE_ID`
- `PRIV_ROUTE_TABLE_ID`
- `SG_FRONT_ID`
- `SG_BACK_ID`
- `AMI_ID`
- `INSTANCE_IMAGE_ID`
- `AMI_DB_ID`

---

## Налаштування VPC

### 1. Створення додаткової VPC

```
aws ec2 create-vpc \
    --cidr-block 192.168.0.0/24 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=homework-vpc},{Key=Project,Value=homework}]' \
    | tee create_vpc_output.json
```

> [Вивід](create_vpc_output.json)

### 2. Створення subnets

#### 2.1 Створення публічної мережі:

```
aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block 192.168.0.0/26 \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PUBLIC},{Key=Project,Value=homework}]' \
    | tee create_public_subnet_output.json
```

> [Вивід](create_public_subnet_output.json)

#### 2.2 Заміна значення "Auto-assign public IPv4 address":

```
aws ec2 modify-subnet-attribute \
    --subnet-id "$PUB_SUBNET_ID" \
    --map-public-ip-on-launch
```

> Команда нічого не повертає.

#### 2.3 Створення приватної мережі:

```
aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block 192.168.0.64/26 \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PRIVATE},{Key=Project,Value=homework}]' \
    | tee create_private_subnet_output.json
```

> [Вивід](create_private_subnet_output.json)

### 3. Налаштування internet gateway

#### 3.1 Створення internet gateway:

```
aws ec2 create-internet-gateway \
    --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=homework-igw},{Key=Project,Value=homework}]' \
    | tee create_internet_gateway_output.json
```

> [Вивід](create_internet_gateway_output.json)

#### 3.2 Attach to VPC:

```
aws ec2 attach-internet-gateway \
    --internet-gateway-id "$GATEWAY_ID" \
    --vpc-id "$VPC_ID"
```

> Команда нічого не повертає.

### 4. Налаштування route tables

#### 4.1 Додавання тегів для публічного route table:

```
aws ec2 create-tags \
    --resources "$PUB_ROUTE_TABLE_ID" \
    --tags Key=Name,Value=public-rt Key=Project,Value=homework
```

> Команда нічого не повертає.

#### 4.2 Створення публічного route для internet gateway:

```
aws ec2 create-route \
    --route-table-id "$PUB_ROUTE_TABLE_ID" \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id "$GATEWAY_ID" \
    | tee create_gateway_route_output.json
```

> [Вивід](create_gateway_route_output.json)

#### 4.3 Створення приватного route table:

```
aws ec2 create-route-table \
    --vpc-id "$VPC_ID" \
    --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=private-rt},{Key=Project,Value=homework}]' \
    | tee create_private_route_table_output.json
```

> [Вивід](create_private_route_table_output.json)

#### 4.4 Додавання асоціації приватної підмережі до приватного route table:

```
aws ec2 associate-route-table \
    --subnet-id "$PRIV_SUBNET_ID" \
    --route-table-id "$PRIV_ROUTE_TABLE_ID" \
    | tee associate_private_route_table_output.json
```

> [Вивід](associate_private_route_table_output.json)

## Налаштування Security Group

### 1. Налаштування sg для вебу

#### 1.1 Створення sg:

```
aws ec2 create-security-group \
    --group-name FRONT-sg \
    --description "AWS ec2 CLI Homework FRONT SG" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=FRONT-sg},{Key=Project,Value=homework}]' \
    --vpc-id "$VPC_ID" \
    | tee create_front_sg_output.json
```

> [Вивід](create_front_sg_output.json)

#### 1.2 Надавання дозволу на вхідний ssh трафік:

```
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_FRONT_ID" \
    --protocol tcp \
    --port 22 \
    --cidr "0.0.0.0/0" \
    | tee authorize_ssh_front_ingress_output.json
```

> [Вивід](authorize_ssh_front_ingress_output.json)

#### 1.3 Надавання доззволу на вхідний трафік для додатку

```
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_FRONT_ID" \
    --protocol tcp \
    --port 8000 \
    --cidr "0.0.0.0/0" \
    | tee authorize_p8000_front_ingress_output.json
```

> [Вивід](authorize_p8000_front_ingress_output.json)

### 2. Налаштування sg для db

#### 2.1 Створення sg:

```
aws ec2 create-security-group \
    --group-name BACK-sg \
    --description "AWS ec2 CLI Homework BACK SG" \
    --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=BACK-sg},{Key=Project,Value=homework}]' \
    --vpc-id "$VPC_ID" \
    | tee create_back_sg_output.json
```

> [Вивід](create_back_sg_output.json)

#### 2.2 Надавання дозволу на трафік в середині групи:

```
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_BACK_ID" \
    --protocol -1 \
    --port -1 \
    --source-group $SG_BACK_ID \
    | tee authorize_ssh_back_ingress_output.json
```

> [Вивід](authorize_ssh_back_ingress_output.json)

## Налаштування інстансів

### 1. Створення пари ключів:

```
mkdir -p ~/.ssh/aws && \
aws ec2 create-key-pair \
    --key-name homework-key \
    --key-type ed25519 \
    --key-format pem \
    --query "KeyMaterial" \
    --output text > ~/.ssh/aws/homework-key.pem && \
chmod 400 ~/.ssh/aws/homework-key.pem
```

### 2. Створення instance для образу:

```
aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type t2.micro \
    --security-group-ids $SG_FRONT_ID \
    --subnet-id $PUB_SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=homework-image},{Key=Project,Value=homework}]' \
    --user-data file://scripts/image_db.sh \
    | tee create_image_instance_output.json
```

> [Вивід](create_image_instance_output.json)

### 3. Створення образу:

```
aws ec2 create-image \
    --name "DB-image" \
    --instance-id $INSTANCE_IMAGE_ID \
    | tee create_image_output.json
```

> [Вивід](create_image_output.json)

### 4. Створення back інстансу:

```
aws ec2 run-instances \
    --image-id "$AMI_DB_ID" \
    --count 1 \
    --instance-type t2.micro \
    --key-name homework-key \
    --security-group-ids $SG_BACK_ID \
    --subnet-id $PRIV_SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=homework-db-server},{Key=Project,Value=homework}]' \
    --user-data file://scripts/db.sh \
    | tee create_db_instance_output.json
```

> [Вивід](create_db_instance_output.json)

### 5. Створення front інстансу:

```
aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type t2.micro \
    --key-name homework-key \
    --security-group-ids $SG_FRONT_ID $SG_BACK_ID \
    --subnet-id $PUB_SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=homework-front-server},{Key=Project,Value=homework}]' \
    --user-data file://scripts/web.sh \
    | tee create_front_instance_output.json
```

> [Вивід](create_front_instance_output.json)

## Налаштування ssh підключення

- Додавання ключа до ssh агента

```
ssh-add ~/.ssh/aws/homework-key.pem
```

- Налаштування ssh підключень у ~/.ssh/aws/config

```
host aws-web
    HostName 3.77.234.218
    User ubuntu
    IdentityFile ~/.ssh/aws/homework-key.pem
    UserKnownHostsFile ~/.ssh/known_hosts_aws
    ForwardAgent yes

host db-host
    HostName 192.168.0.125
    User ubuntu
    ProxyJump aws-web
```

- Підключення aws конфігу до ~/.ssh/config

```
include aws/config
```

#### Додатково

```
curl -I 3.77.234.218:8000 | tee curl_output.txt
```

> [Вивід](curl_output.txt)
