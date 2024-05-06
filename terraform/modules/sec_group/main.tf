resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_rules)

  security_group_id = aws_security_group.this.id
  type              = "ingress"

  cidr_blocks = var.ingress_cidr_blocks
  description = var.rules[var.ingress_rules[count.index]][3]

  from_port = var.rules[var.ingress_rules[count.index]][0]
  to_port   = var.rules[var.ingress_rules[count.index]][1]
  protocol  = var.rules[var.ingress_rules[count.index]][2]
}

resource "aws_security_group_rule" "ingress_with_self" {
  count = length(var.ingress_with_self)

  security_group_id = aws_security_group.this.id
  type              = "ingress"

  self            = lookup(var.ingress_with_self[count.index], "self", true)

  description = lookup(
    var.ingress_with_self[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_self[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_self[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_self[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][2],
  )
}

resource "aws_security_group_rule" "egress_rules" {
  count = length(var.egress_rules)

  security_group_id = aws_security_group.this.id
  type              = "egress"

  cidr_blocks = var.egress_cidr_blocks
  description = var.rules[var.egress_rules[count.index]][3]

  from_port = var.rules[var.egress_rules[count.index]][0]
  to_port   = var.rules[var.egress_rules[count.index]][1]
  protocol  = var.rules[var.egress_rules[count.index]][2]
}
