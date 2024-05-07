resource "aws_instance" "this" {
  count = var.instance_count

  ami           = var.ami
  instance_type = var.instance_type

  user_data              = var.user_data
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name = var.key_name

  tags = merge({ "Name" = var.name }, var.tags)
}
