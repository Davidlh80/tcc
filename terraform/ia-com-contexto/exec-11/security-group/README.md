# Security Group

## Visao geral

Este template Terraform cria um Security Group na AWS, com o ID da VPC configuravel por variavel. As regras de entrada e de saida sao configuraveis via variaveis, sendo obrigatoria a descricao em cada regra. O CIDR `0.0.0.0/0` somente e permitido na porta 443/tcp, tanto em ingress quanto em egress. Por padrao, nenhuma regra de entrada ou saida e criada, evitando qualquer liberacao irrestrita. O nome do recurso segue o padrao organizacional `<ambiente>-<sistema>-sg-<finalidade>` e todas as tags obrigatorias da organizacao sao aplicadas automaticamente.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|------|------|-------------|-----------|
| environment | string | Sim | Ambiente de implantacao do recurso (dev, hml ou prd). |
| system | string | Nao (default: "tcc") | Nome do sistema ou aplicacao proprietaria do recurso. |
| region | string | Nao (default: "us-east-1") | Regiao AWS onde os recursos serao provisionados. |
| additional_tags | map(string) | Nao (default: {}) | Tags adicionais mescladas com as tags obrigatorias da organizacao. |
| vpc_id | string | Sim | ID da VPC onde o Security Group sera criado. |
| security_group_name | string | Sim | Nome do Security Group, no padrao `<ambiente>-<sistema>-sg-<finalidade>`. |
| ingress_rules | list(object) | Nao (default: []) | Regras de entrada. Cada regra exige description, from_port, to_port, protocol e cidr_blocks. |
| egress_rules | list(object) | Nao (default: []) | Regras de saida. Cada regra exige description, from_port, to_port, protocol e cidr_blocks. |

## Outputs

| Nome | Descricao |
|------|-----------|
| security_group_name | Nome do Security Group criado. |
| security_group_arn | ARN do Security Group criado. |
| security_group_id | ID do Security Group criado. |

## Exemplo de uso

    module "sg_web" {
      source = "./"

      environment          = "hml"
      system                = "tcc"
      region                 = "us-east-1"
      vpc_id                 = "vpc-0123456789abcdef0"
      security_group_name    = "hml-tcc-sg-web"

      ingress_rules = [
        {
          description = "Acesso HTTPS publico"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]

      egress_rules = [
        {
          description = "Acesso a API interna"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
        }
      ]

      additional_tags = {
        Squad = "plataforma"
      }
    }
