variable "env" {
  description = "Env"
  default     = "dev"
}

variable "gitlabProjectId" {
  description = "Gitlab project id"
}

variable "gitlabToken" {
  description = "Gitlab token"
  sensitive   = true
}
