resource "aws_security_group" "sg-app" {
  name        = "app-sg"
  description = "Security group for the Flask application"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "APP"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "APP-sg"
    Project = "Homework-9"
  }
}

resource "aws_security_group" "sg-db" {
  name        = "db-sg"
  description = "Security group for the MySQL database"
  vpc_id      = var.vpc_id

  ingress {
    description = "Inside"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "DB-sg"
    Project = "Homework-9"
  }
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.sg-db.id]
  subnet_id              = var.db-subnet-id

  tags = {
    Name    = "DB-instance"
    Project = "Homework-9"
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.sg-db.id, aws_security_group.sg-app.id]
  subnet_id              = var.app-subnet-id
  iam_instance_profile   = var.app-instance-profile-name

  tags = {
    Name    = "APP-instance"
    Project = "Homework-9"
  }
}

resource "local_file" "generate_db_vars" {
  content = templatefile("files/app_vars.yml.tpl", {
    db_id = aws_instance.db.private_ip
  })
  filename = "../ansible/environments/stage/group_vars/app.yml"
}

resource "local_file" "generate_inventory" {
  content = templatefile("files/base_inventory.tpl", {
    app_instance_name = aws_instance.app.tags.Name,
    app_instance_ip   = aws_instance.app.public_ip,
    db_instance_name  = aws_instance.db.tags.Name,
    db_instance_ip    = aws_instance.db.public_ip
  })
  filename = "../ansible/environments/stage/inventory"
}
