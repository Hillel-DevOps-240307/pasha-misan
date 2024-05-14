output "private_ip" {
  value = { for k, v in aws_instance.this : k => v.private_ip }
}

output "public_ip" {
  value = { for instance_name, instance in aws_instance.this : instance.tags.Name => instance.public_ip }
}

output "dns" {
  value = { for k, v in aws_instance.this : k => v.public_dns }
}
