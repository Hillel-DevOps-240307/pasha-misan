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
  source = "./modules/sec_group"

  name        = "APP-sg-${var.env}"
  description = "Security group for the Voting App application"
  vpc_id      = data.terraform_remote_state.vpc.outputs.dev_vpc_id
  tags = {
    Project = "Voting app"
    Env     = var.env
  }

  ingress_rules = ["ssh-22-tcp", "http-5000-tcp", "http-5001-tcp"]
  egress_rules  = ["all-all"]
}

module "db_sg" {
  source = "./modules/sec_group"

  name        = "DB-sg-${var.env}"
  description = "Security group for the Voting App database"
  vpc_id      = data.terraform_remote_state.vpc.outputs.dev_vpc_id
  tags = {
    Project = "Voting app"
    Env     = var.env
  }

  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]
}

data "aws_ami" "app" {
  most_recent = true

  filter {
    name = "tag:ami_type"
    //todo доробити
    values = ["voting-app"]
  }

  owners = ["self"]
}

data "aws_ami" "db" {
  most_recent = true

  filter {
    name   = "tag:ami_type"
    values = ["voting-db"]
  }

  owners = ["self"]
}

module "db_instance" {
  source = "./modules/db"

  name = "Voting app database"
  ami  = data.aws_ami.db.id

  subnet_id              = data.terraform_remote_state.vpc.outputs.dev_private_subnet
  vpc_security_group_ids = [module.db_sg.security_group_id]
  tags = {
    Project = "Voting_app"
    Env     = var.env
  }
}

module "app_instance" {
  source = "./modules/app"

  name = "Voting app instance"
  ami  = data.aws_ami.app.id

  subnets                = data.terraform_remote_state.vpc.outputs.dev_public_subnets
  vpc_security_group_ids = [module.app_sg.security_group_id, module.db_sg.security_group_id]
  tags = {
    Name = "Voting_app"
    Env  = var.env
  }
}

resource "gitlab_project_variable" "setup_host_variable" {
  project = var.gitlabProjectId
  key     = "SERVER_HOST"
  value   = element(values(module.app_instance.public_ip), 0)
}

resource "local_file" "generate_service_file" {
  content = templatefile("../ansible/templates/inventory.tpl", {
    app_instances = module.app_instance.public_ip,
  })
  filename = "../ansible/inventory"
}

resource "local_file" "generate_env_file" {
  content = templatefile("../ansible/templates/env.tpl", {
    db_ip = module.db_instance.private_ip,
  })
  filename = "../ansible/.env"
}
