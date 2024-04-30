variable "instance_size" { type = string }
variable "region" { type = string }
variable "base_ami" { type = string }

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "db" {
  ami_name      = "ami-db"
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username  = "ubuntu"
  tags = {
    Project  = "Homework-6",
    ami_type = "db"
  }
}

build {
  name = "db"
  sources = [
    "source.amazon-ebs.db"
  ]
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y mariadb-server"
    ]
    pause_before = "10s"
  }
  provisioner "shell" {
    script          = "scripts/db.sh"
    execute_command = "sudo {{.Path}}"
  }
  post-processor "manifest" {
    output = "manifests/db.json"
  }
}
