# Security Group

## 1. Visao geral

Este template provisiona um AWS Security Group, com o ID da VPC configuravel por variavel. As regras de entrada e de saida sao definidas externamente por variaveis, nao ha liberacao irrestrita (`0.0.0.0/0`) em nenhuma porta alem da 443/tcp, e toda regra exige descricao obrigatoria. O egress e sempre declarado de forma explicita (nenhuma regra e criada automaticamente). O recurso segue o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e aplica o conjunto de tags obrigatorias da organizacao.

## 2. Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| environment | string | Sim | Ambiente de implantacao (dev, hml ou prd). |
| system | string | Sim | Nome do sistema/aplicacao ao qual o recurso pertence. |
| region | string | Nao (default: us-east-1) | Regiao AWS onde o Security Group sera provisionado. |
| additional_tags | map(string) | Nao (default: {}) | Tags adicionais mescladas com as tags obrigatorias. |
| security_group_name | string | Sim | Finalidade do Security Group, usada para compor o nome padronizado (ex.: web). |
| vpc_id | string | Sim | ID da VPC onde o Security Group sera criado. |
| ingress_rules | list(object) | Nao (default: []) | Regras de entrada (description, from_port, to_port, protocol, cidr_blocks). `0.0.0.0/0` so e permitido restrito a 443/tcp. |
| egress_rules | list(object) | Nao (default: []) | Regras de saida (description, from_port, to_port, protocol, cidr_blocks). `0.0.0.0/0` so e permitido restrito a 443/tcp. |

## 3. Outputs

| Nome | Descricao |
|---|---|
| security_group_name | Nome do Security Group criado. |
| security_group_arn | ARN do Security Group criado. |
| security_group_id | ID do Security Group criado. |

## 4. Exemplo de uso

module "sg_web" {
  source               = "./"
  environment          = "dev"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  ingress_rules = [
    {
      description = "Acesso HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Acesso SSH restrito a rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS para atualizacoes e integracoes"
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
