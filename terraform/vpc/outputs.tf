output "prod_vpc_id" {
  value = module.prod-vpc.vpc_id
}

output "prod_public_subnets" {
  value = module.prod-vpc.public_subnets
}

output "prod_private_subnet" {
  value = module.prod-vpc.private_subnets[0]
}

output "dev_vpc_id" {
  value = module.dev-vpc.vpc_id
}

output "dev_public_subnets" {
  value = module.dev-vpc.public_subnets
}

output "dev_private_subnet" {
  value = module.dev-vpc.private_subnets[0]
}
