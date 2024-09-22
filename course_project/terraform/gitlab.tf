resource "gitlab_project_variable" "setup_host_variable" {
  project = var.gitlab_project_id
  key     = "SERVER_HOST"
  value   = element(values(module.app_instance.public_ip), 0)
}

resource "gitlab_project_variable" "setup_user_variable" {
  project = var.gitlab_project_id
  key     = "SERVER_USER"
  value   = var.gitlab_deploy_user
}

resource "gitlab_project_variable" "setup_key_variable" {
  project = var.gitlab_project_id
  key     = "SSH_PRIVATE_KEY"

  value = file(var.gitlab_key_path)

  protected = true
}
