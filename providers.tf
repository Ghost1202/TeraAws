terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "YOUR_TERRAFORM_STATE_BUCKET"
    key            = "teraaws/task-3.2.4/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "YOUR_TERRAFORM_LOCKS_TABLE"
  }
}

provider "aws" {
  region = "eu-central-1"
}
