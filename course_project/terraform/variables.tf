variable "env" {
  description = "Env"
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  default     = "Voting-app"
}

variable "gitlab_project_id" {
  description = "Gitlab project id"
}

variable "gitlab_token" {
  description = "Gitlab token"
  sensitive   = true
}

variable "gitlab_deploy_user" {
  description = "User for deploy"
  default     = "ubuntu"
}

variable "gitlab_key_path" {
  description = "Шлях до файлу з приватним ключем"
  type        = string
  default     = "~/.ssh/aws/homework-key.pem"
}
