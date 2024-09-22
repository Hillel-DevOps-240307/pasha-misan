resource "aws_instance" "this" {
  for_each = { for idx, subnet_id in var.subnets : idx => subnet_id }

  ami           = var.ami
  instance_type = var.instance_type

  user_data              = var.user_data
  subnet_id              = each.value
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name = var.key_name

  tags = merge({ "Name" = "${var.name}-${each.key}" }, var.tags)
}
