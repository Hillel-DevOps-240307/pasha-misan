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
  vpc_id      = data.terraform_remote_state.vpc.outputs.prod_vpc_id
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

  name = "DB-instance"
  ami  = data.aws_ami.db.id

  subnet_id              = data.terraform_remote_state.vpc.outputs.prod_private_subnet
  vpc_security_group_ids = [module.db_sg.security_group_id]
  tags = {
    Project = "Homework-7"
    Env     = var.env
  }
}

module "app_instance" {
  source = "../modules/app"

  name = "APP-instance"
  ami  = data.aws_ami.app.id

  user_data = templatefile("../scripts/app.sh.tpl", {
    db_private_ip = module.db_instance.private_ip
  })
  subnets                = data.terraform_remote_state.vpc.outputs.prod_public_subnets
  vpc_security_group_ids = [module.app_sg.security_group_id, module.db_sg.security_group_id]
  tags = {
    Project = "Homework-7"
    Env     = var.env
  }
}

resource "local_file" "generate_service_file" {
  content = templatefile("../files/inventory.tpl", {
    app_instances    = module.app_instance.public_ip,
    db_instance_name = module.db_instance.name,
    #Використав приватний ip для прикладу, оскільки публічного у цього інстансу немає
    db_instance_ip = module.db_instance.private_ip
  })
  filename = "../files/prod_hosts"
}
