module "prod-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                          = "Voting-app-vpc"
  cidr                          = var.cidr
  manage_default_security_group = false
  map_public_ip_on_launch       = true

  azs             = var.azs
  private_subnets = ["192.168.0.0/26"]
  public_subnets  = ["192.168.0.64/26", "192.168.0.128/26", "192.168.0.192/26"]

  tags = {
    Environment = "prod"
    Project     = "Voting-app"
  }
}

module "dev-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                          = "Voting-app-vpc"
  cidr                          = var.cidr
  manage_default_security_group = false
  map_public_ip_on_launch       = true

  azs             = var.azs
  private_subnets = ["192.168.0.0/26"]
  public_subnets  = ["192.168.0.64/26"]

  tags = {
    Environment = "dev"
    Project     = "Voting-app"
  }
}
