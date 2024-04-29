output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "app_public_ip" {
  value = aws_instance.app.public_ip
}

output "app_dns" {
  value = aws_instance.app.public_dns
}

output "db_public_ip" {
  value = aws_instance.db.public_ip
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}
