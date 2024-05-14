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
    Project = "Homework-8"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "DB-sg"
    Project = "Homework-8"
  }
}

data "aws_ami" "db" {
  most_recent = true

  filter {
    name   = "tag:ami_type"
    values = ["ansible-db"]
  }

  owners = ["self"]
}

data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "tag:ami_type"
    values = ["ansible-app"]
  }

  owners = ["self"]
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.db.id
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.sg-db.id]
  subnet_id              = var.db-subnet-id

  tags = {
    Name    = "DB-instance"
    Project = "Homework-8"
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.app.id
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.sg-db.id, aws_security_group.sg-app.id]
  subnet_id              = var.app-subnet-id

  tags = {
    Name    = "APP-instance"
    Project = "Homework-8"
  }
}

resource "local_file" "generate_service_template" {
  content = templatefile("files/app.service.tpl", {
    mysql_host = aws_instance.db.private_ip
  })
  filename = "../ansible/templates/app.service.j2"
}

resource "local_file" "generate_inventory" {
  content = templatefile("files/single_inventory.tpl", {
    name = aws_instance.app.tags.Name,
    ip = aws_instance.app.public_ip
  })
  filename = "../ansible/inventory"
}
