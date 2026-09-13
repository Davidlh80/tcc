# Security Group

## 1. Visão geral

Este template provisiona um AWS Security Group com o ID da VPC configurável por variável. As regras de entrada e de saída são totalmente configuráveis por variável, sem liberação irrestrita por padrão (nenhuma regra é criada caso as listas não sejam informadas). Toda regra de entrada ou saída deve conter uma descrição obrigatória, e o CIDR `0.0.0.0/0` é proibido em qualquer porta além da 443/tcp. O recurso segue o padrão de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatórias da organização.

## 2. Variáveis

| Nome                          | Tipo                    | Obrigatória | Descrição                                                                                          |
|--------------------------------|-------------------------|:-----------:|------------------------------------------------------------------------------------------------------|
| environment                    | string                  | Sim          | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                     |
| system                          | string                  | Sim          | Nome do sistema ou aplicação, usado na composição do nome padronizado.                              |
| region                          | string                  | Não          | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                                |
| additional_tags                 | map(string)             | Não          | Tags adicionais mescladas às tags obrigatórias da organização. Padrão: `{}`.                          |
| vpc_id                          | string                  | Sim          | ID da VPC onde o Security Group será criado.                                                         |
| security_group_name             | string                  | Sim          | Finalidade do Security Group, usada na composição do nome padronizado (ex.: `web`).                  |
| security_group_description      | string                  | Não          | Descrição do Security Group. Padrão: `"Security Group gerenciado via Terraform."`.                   |
| ingress_rules                   | list(object)            | Não          | Regras de entrada (descrição, portas, protocolo, CIDRs). Padrão: `[]` (sem regras de entrada).       |
| egress_rules                    | list(object)            | Não          | Regras de saída (descrição, portas, protocolo, CIDRs). Padrão: `[]` (sem regras de saída).           |

## 3. Outputs

| Nome                  | Descrição                              |
|------------------------|-----------------------------------------|
| security_group_name     | Nome do Security Group criado.          |
| security_group_arn      | ARN do Security Group criado.           |
| security_group_id       | ID do Security Group criado.            |

## 4. Exemplo de uso

    module "sg_web" {
      source = "./security-group"

      environment          = "hml"
      system                = "tcc"
      region                 = "us-east-1"
      vpc_id                 = "vpc-0123456789abcdef0"
      security_group_name    = "web"

      ingress_rules = [
        {
          description = "Acesso HTTPS público"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]

      egress_rules = [
        {
          description = "Acesso HTTPS de saída para atualizações"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]

      additional_tags = {
        Squad = "plataforma"
      }
    }
