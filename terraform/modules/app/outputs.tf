output "private_ip" {
  value = aws_instance.this[*].private_ip
}

output "public_ip" {
  value = aws_instance.this[*].public_ip
}

output "dns" {
  value = aws_instance.this[*].public_dns
}
