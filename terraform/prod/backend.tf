terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-20240507193507683300000001"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "prod/terraform_tfstate"
    region         = "eu-central-1"
  }
}
