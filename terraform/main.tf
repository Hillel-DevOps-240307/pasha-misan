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
    Project = "Homework-6"
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
    Project = "Homework-6"
  }
}

data "aws_ami" "db" {
  most_recent = true

  filter {
    name   = "tag:ami_type"
    values = ["db"]
  }

  owners = ["self"]
}

data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "tag:ami_type"
    values = ["app"]
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
    Name    = "DB instance"
    Project = "Homework-6"
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.app.id
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.sg-db.id, aws_security_group.sg-app.id]
  subnet_id              = var.app-subnet-id
  user_data = templatefile("scripts/app.sh.tpl", {
    db_private_ip = aws_instance.db.private_ip
  })

  tags = {
    Name    = "APP instance"
    Project = "Homework-6"
  }
}
