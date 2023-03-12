terraform {
  cloud {
    organization = "kaokakelvin"

    workspaces {
      name = "nginx-devops-project"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                   = var.region
}