terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = merge(
      {
        Project     = "tcc-iac-ia"
        Environment = var.environment
        ManagedBy   = "terraform"
        Owner       = "devops"
        CostCenter  = "academic-research"
      },
      var.additional_tags
    )
  }
}
