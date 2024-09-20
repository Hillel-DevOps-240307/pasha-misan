terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "15.9.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "terraform"
}

provider "gitlab" {
  token = var.gitlabToken
}
