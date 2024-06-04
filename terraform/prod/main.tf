data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-20240507193507683300000001"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "vpc/terraform_tfstate"
    region         = "eu-central-1"
  }
}

module "app_sg" {
  source = "../modules/sec_group"

  name        = "APP-sg-${var.env}"
  description = "Security group for the Flask application"
  vpc_id      = data.terraform_remote_state.vpc.outputs.prod_vpc_id
  tags = {
    Project = "Homework-10"
    Env     = var.env
  }

  ingress_rules = ["ssh-22-tcp", "flask-8000-tcp"]
  egress_rules  = ["all-all"]
}

module "db_sg" {
  source = "../modules/sec_group"

  name        = "DB-sg-${var.env}"
  description = "Security group for the MySQL database"
  vpc_id      = data.terraform_remote_state.vpc.outputs.prod_vpc_id
  tags = {
    Project = "Homework-10"
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

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.prod_public_subnets
}

resource "aws_db_parameter_group" "main" {
  name        = "main-parameter-group"
  family      = "mariadb10.11"
  description = "Main parameter group"

  parameter {
    name  = "max_connections"
    value = "50"
  }
}

resource "aws_db_instance" "main" {
  identifier             = var.db_identifier
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  username               = var.db_master_user
  password               = var.db_master_password
  parameter_group_name   = aws_db_parameter_group.main.name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [module.db_sg.security_group_id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}

module "app_instance" {
  source = "../modules/app"

  name = "APP-instance"
  ami  = data.aws_ami.app.id

  subnets                = data.terraform_remote_state.vpc.outputs.prod_public_subnets
  vpc_security_group_ids = [module.app_sg.security_group_id, module.db_sg.security_group_id]
  tags = {
    Project = "Homework-10"
    Env     = var.env
  }
}

resource "local_file" "generate_inventory_file" {
  content = templatefile("../files/inventory.tpl", {
    app_instances      = module.app_instance.public_ip,
    rds_endpoint       = aws_db_instance.main.address,
    db_name            = var.db_name,
    db_master_user     = var.db_master_user,
    db_master_password = var.db_master_password
  })
  filename = "../files/prod_hosts"
}

resource "local_file" "generate_script_file" {
  content = templatefile("../scripts/app.sh.tpl", {
    db_name = var.db_name,
    db_host = aws_db_instance.main.address,
  })
  filename = "../scripts/app.sh"
}
