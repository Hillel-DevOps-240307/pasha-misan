variable "instance_size" { type = string }
variable "region" { type = string }
variable "base_ami" { type = string }
variable "user_name" { type = string }
variable "user_password" { type = string }

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
  ami_name      = "voting-app-db"
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username  = "ubuntu"
  tags = {
    Project  = "Voting app"
    ami_type = "voting-db"
  }
}

build {
  name = "db"
  sources = [
    "source.amazon-ebs.db"
  ]

  provisioner "ansible" {
    playbook_file = "../ansible/ami_db.yml"
    extra_arguments = [
      "--extra-vars",
      "user_name=${var.user_name} user_password=${var.user_password}"
    ]
  }
}
