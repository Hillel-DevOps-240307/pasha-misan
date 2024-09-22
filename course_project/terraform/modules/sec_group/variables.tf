variable "name" {
  description = "Name of security group"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}
variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_with_self" {
  description = "List of ingress rules to create where 'self' is defined"
  type        = list(map(string))
  default     = []
}
