output "app_private_ip" {
  value = module.app_instance.private_ip
}

output "app_public_ip" {
  value = module.app_instance.public_ip
}

output "app_dns" {
  value = module.app_instance.dns
}
