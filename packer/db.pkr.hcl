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
    Project = "Homework-4"
  }
}

build {
  name = "db"
  sources = [
    "source.amazon-ebs.db"
  ]
  provisioner "file" {
    source      = "./services/backup.service"
    destination = "/tmp/backup.service"
  }
  provisioner "file" {
    source      = "./services/backup.timer"
    destination = "/tmp/backup.timer"
  }
  provisioner "file" {
    source      = "./scripts/backup.sh"
    destination = "/home/ubuntu/backup.sh"
  }
  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y mariadb-server awscli",
      "wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb",
      "sudo dpkg -i -E ./amazon-cloudwatch-agent.deb"
    ]
    pause_before = "10s"
  }
  provisioner "shell" {
    script          = "scripts/configure_db.sh"
    execute_command = "sudo {{.Path}}"
  }

  post-processor "manifest" {
    output = "manifests/db.json"
  }
}
