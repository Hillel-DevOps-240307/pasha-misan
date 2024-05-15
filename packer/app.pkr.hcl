#Для формату hcl2 змінні необхідно попередньо оголосити
#https://developer.hashicorp.com/packer/guides/hcl/variables#defining-variables-and-locals
variable "instance_size" { type = string }
variable "region" { type = string }
variable "base_ami" { type = string }

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "app" {
  ami_name      = "ansible-ami-app"
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username  = "ubuntu"
  tags = {
    Project  = "Homework-9"
    ami_type = "ansible-app"
  }
}

build {
  name = "app"
  sources = [
    "source.amazon-ebs.app"
  ]

  provisioner "ansible" {
    playbook_file    = "../ansible/app_install.yml"
    ansible_env_vars = ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"]
  }

  post-processor "manifest" {
    output = "manifests/app.json"
  }
}
