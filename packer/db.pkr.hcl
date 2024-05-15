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


source "amazon-ebs" "db" {
  ami_name      = "ansible-ami-db"
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username  = "ubuntu"
  tags = {
    Project  = "Homework-9"
    ami_type = "ansible-db"
  }
}

build {
  name = "db"
  sources = [
    "source.amazon-ebs.db"
  ]

  provisioner "ansible" {
    playbook_file    = "../ansible/db_install.yml"
    ansible_env_vars = ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"]
  }

  post-processor "manifest" {
    output = "manifests/db.json"
  }
}
