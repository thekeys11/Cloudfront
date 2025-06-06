terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.47.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      workload    = ""
      environment = ""
      buss_owner  = ""
      tech_owner  = ""
      company     = ""
      departament = ""
      cost_center = ""
    }
  }
}