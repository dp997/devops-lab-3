terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    random = {
      source = "hashicorp/random"
    }

    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }

  backend "s3" {
    bucket  = "terraform-lab-dpierzga"
    key     = "state/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}



