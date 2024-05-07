module "app_sg" {
  source = "../modules/sec_group"

  name        = "APP-sg-${var.env}"
  description = "Security group for the Flask application"
  vpc_id      = var.vpc_id
  tags = {
    Project = "Homework-7"
    Env     = var.env
  }

  ingress_rules = ["ssh-22-tcp", "flask-8000-tcp"]
  egress_rules  = ["all-all"]
}

module "db_sg" {
  source = "../modules/sec_group"

  name        = "DB-sg-${var.env}"
  description = "Security group for the MySQL database"
  vpc_id      = var.vpc_id
  tags = {
    Project = "Homework-7"
    Env     = var.env
  }

  ingress_with_self = [
    {
      rule = "all-all"
    }
  ]
  egress_rules = ["all-all"]
}

data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "tag:ami_type"
    values = ["app"]
  }

  owners = ["self"]
}

data "aws_ami" "db" {
  most_recent = true

  filter {
    name   = "tag:ami_type"
    values = ["db"]
  }

  owners = ["self"]
}

module "db_instance" {
  source = "../modules/db"

  name = "DB instance"
  ami  = data.aws_ami.db.id

  subnet_id              = var.db-subnet-id
  vpc_security_group_ids = [module.db_sg.security_group_id]
  tags = {
    Project = "Homework-7"
    Env     = var.env
  }
}

module "app_instance" {
  source = "../modules/app"

  name = "APP instance"
  ami  = data.aws_ami.app.id
  instance_count = 3

  user_data = templatefile("../scripts/app.sh.tpl", {
    db_private_ip = module.db_instance.private_ip
  })
  subnet_id              = var.app-subnet-id
  vpc_security_group_ids = [module.app_sg.security_group_id, module.db_sg.security_group_id]
  tags = {
    Project = "Homework-7"
    Env     = var.env
  }
}
