module "app_sg" {
  source = "../modules/sec_group"

  name        = "APP-sg"
  description = "Security group for the Flask application"
  vpc_id      = var.vpc_id
  tags = {
    Project = "Homework-7"
  }

  ingress_rules = ["ssh-22-tcp", "flask-8000-tcp"]
  egress_rules  = ["all-all"]
}

module "db_sg" {
  source = "../modules/sec_group"

  name        = "DB-sg"
  description = "Security group for the MySQL database"
  vpc_id      = var.vpc_id
  tags = {
    Project = "Homework-7"
  }

  ingress_with_self = [
    {
      rule = "all-all"
    }
  ]
  egress_rules = ["all-all"]
}
