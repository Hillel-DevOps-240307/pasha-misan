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

source "amazon-ebs" "app" {
  ami_name      = "ami-app"
  instance_type = var.instance_size
  region        = var.region
  source_ami    = var.base_ami
  ssh_username  = "ubuntu"
  tags = {
    Project  = "Homework-6",
    ami_type = "app"
  }
}

build {
  name = "app"
  sources = [
    "source.amazon-ebs.app"
  ]
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y git python3-pip awscli mariadb-client default-libmysqlclient-dev build-essential pkg-config",
      "git clone https://github.com/saaverdo/flask-alb-app -b orm /home/ubuntu/flask-alb-app"
    ]
    pause_before = "20s"
  }
  provisioner "shell" {
    script          = "scripts/app.sh"
    execute_command = "sudo {{.Path}}"
  }
  post-processor "manifest" {
    output = "manifests/app.json"
  }
}
