variable "vpc_id" {
  description = "The ID of the VPC"
  default     = "vpc-0aae8b528be33ce01"
}

variable "key-name" {
  description = "Key pair"
  default     = "homework-key"
}

variable "instance-type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "db-subnet-id" {
  description = "DB subnet id"
  default = "subnet-0eb7d7cf58c3e85d8"
}

variable "app-subnet-id" {
  description = "APP subnet id"
  default = "subnet-0d75f6a5e122b2ed3"
}
