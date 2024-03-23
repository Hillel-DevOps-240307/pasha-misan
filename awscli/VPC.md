## Використані змінні

- `VPC_ID`
- `PUB_SUBNET_ID`
- `PRIV_SUBNET_ID`
- `GATEWAY_ID`
- `PUB_ROUTE_TABLE_ID`
- `PRIV_ROUTE_TABLE_ID`

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
