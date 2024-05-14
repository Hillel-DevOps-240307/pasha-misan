variable "cidr" {
  description = "Default cidr"
  default     = "192.168.0.0/24"
}

variable "azs" {
  description = "Availability zones"
  default     = ["eu-central-1a"]
}
