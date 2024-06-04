variable "env" {
  description = "Env"
  default     = "prod"
}

variable "db_master_password" {
  description = "Master password"
  default     = "masterPassword"
}

variable "db_master_user" {
  description = "Master user"
  default     = "root"
}

variable "db_instance_class" {
  description = "Instance class"
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "Database engine"
  default     = "mariadb"
}

variable "db_identifier" {
  description = "Database identifier"
  default     = "main-database"
}

variable "db_name" {
  description = "Database name"
  default     = "flask_db"
}
