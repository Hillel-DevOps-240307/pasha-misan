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
  ami_name      = "voting-app"
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username  = "ubuntu"
  tags = {
    Project = "Voting app"
    ami_type = "voting-app"
  }
}

build {
  name = "app"
  sources = [
    "source.amazon-ebs.app"
  ]

  provisioner "ansible" {
    playbook_file    = "../ansible/ami_app.yml"
  }
}
