# Security Group

## 1. Visão geral do recurso

Este template provisiona um Security Group na AWS, com o ID da VPC configurável por variável. As regras de entrada e saída são totalmente configuráveis por variável e vazias por padrão (nenhuma regra é criada automaticamente, evitando liberação irrestrita). Toda regra de entrada ou saída exige descrição obrigatória, e o uso do CIDR `0.0.0.0/0` é bloqueado em qualquer porta que não seja 443/tcp. O recurso segue o padrão de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e aplica o conjunto de tags obrigatórias da organização.

## 2. Tabela de variáveis

| Nome                          | Tipo                                                                                          | Obrigatória | Descrição                                                                                          |
|-------------------------------|------------------------------------------------------------------------------------------------|-------------|------------------------------------------------------------------------------------------------------|
| environment                   | string                                                                                          | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                     |
| system                        | string                                                                                          | Sim         | Nome do sistema ou aplicação ao qual o recurso pertence.                                             |
| region                        | string                                                                                          | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                                |
| additional_tags               | map(string)                                                                                     | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                                    |
| security_group_name           | string                                                                                          | Sim         | Finalidade do Security Group, usada na composição do nome padrão (ex.: `web`, `db`).                 |
| security_group_description    | string                                                                                          | Não         | Descrição do Security Group. Padrão: `"Security Group gerenciado via Terraform."`.                   |
| vpc_id                        | string                                                                                          | Sim         | ID da VPC onde o Security Group será criado.                                                         |
| ingress_rules                 | list(object({ description, from_port, to_port, protocol, cidr_ipv4 }))                         | Não         | Regras de entrada. `0.0.0.0/0` só é permitido restrito à porta 443/tcp. Padrão: `[]`.                |
| egress_rules                  | list(object({ description, from_port, to_port, protocol, cidr_ipv4 }))                         | Não         | Regras de saída. `0.0.0.0/0` só é permitido restrito à porta 443/tcp. Padrão: `[]`.                  |

## 3. Tabela de outputs

| Nome                   | Descrição                                  |
|------------------------|---------------------------------------------|
| security_group_name    | Nome do Security Group criado.              |
| security_group_arn     | ARN do Security Group criado.               |
| security_group_id      | ID do Security Group criado.                |

## 4. Exemplo de uso

    module "sg_web" {
      source = "./"

      environment          = "hml"
      system                = "tcc"
      region                 = "us-east-1"
      security_group_name    = "web"
      vpc_id                 = "vpc-0123456789abcdef0"

      additional_tags = {
        Squad = "plataforma"
      }

      ingress_rules = [
        {
          description = "HTTPS publico"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        },
        {
          description = "SSH restrito a rede corporativa"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
        }
      ]

      egress_rules = [
        {
          description = "Saida HTTPS para atualizacoes"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
      ]
    }
