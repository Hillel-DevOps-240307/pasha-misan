module "prod-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                          = "Prod-vpc"
  cidr                          = "192.168.0.0/24"
  manage_default_security_group = false
  map_public_ip_on_launch       = true

  azs             = ["eu-central-1a"]
  private_subnets = ["192.168.0.0/26"]
  public_subnets  = ["192.168.0.64/26", "192.168.0.128/26", "192.168.0.192/26"]

  tags = {
    Environment = "prod"
    Project     = "Homework-7"
  }
}

module "dev-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                          = "Dev-vpc"
  cidr                          = "192.168.0.0/24"
  manage_default_security_group = false
  map_public_ip_on_launch       = true

  azs             = ["eu-central-1a"]
  private_subnets = ["192.168.0.0/26"]
  public_subnets  = ["192.168.0.64/26"]

  tags = {
    Environment = "dev"
    Project     = "Homework-7"
  }
}
