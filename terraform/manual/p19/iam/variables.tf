variable "aws_region" {
  description = "Região AWS usada pelo provider."
  type        = string
  default     = "us-east-1"
}

variable "policy_name" {
  description = "Nome da IAM Policy."
  type        = string
  default     = "example-policy"
}

variable "policy_description" {
  description = "Descrição da IAM Policy."
  type        = string
  default     = "Policy gerida por Terraform."
}

variable "role_name" {
  description = "Nome da IAM Role."
  type        = string
  default     = "example-role"
}

variable "policy_json" {
  description = "Documento JSON da IAM Policy."
  type        = string
  default     = <<-JSON
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:ListAllMyBuckets"],
        "Resource": "*"
      }
    ]
  }
  JSON
}

variable "assume_role_policy_json" {
  description = "Documento de confiança da IAM Role. Ajuste o principal ao serviço/entidade que irá assumir a role."
  type        = string
  default     = <<-JSON
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  JSON
}

variable "tags" {
  description = "Tags aplicadas aos recursos IAM."
  type        = map(string)
  default     = {}
}
