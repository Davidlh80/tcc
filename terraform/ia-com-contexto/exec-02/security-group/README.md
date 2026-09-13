# Security Group

## Visão geral

Este template provisiona um Security Group na AWS, com o ID da VPC configurável por variável, seguindo os padrões organizacionais de nomenclatura, tags e segurança.

O nome do recurso é composto automaticamente no formato `<ambiente>-<sistema>-sg-<finalidade>` (ex.: `hml-tcc-sg-web`).

Regras de segurança aplicadas por padrão:

- `0.0.0.0/0` é proibido em qualquer regra de entrada ou saída, exceto quando restrita exclusivamente à porta 443/tcp;
- toda regra de entrada e de saída exige descrição obrigatória (validada via variável);
- as regras de egress são declaradas explicitamente pelo usuário — não há liberação irrestrita por padrão (lista vazia = nenhum tráfego de saída permitido);
- todas as regras de entrada e saída são configuráveis por variável.

## Variáveis

| Nome                 | Tipo                  | Obrigatória | Descrição                                                                                     |
|----------------------|-----------------------|-------------|------------------------------------------------------------------------------------------------|
| environment          | string                | Sim         | Ambiente de implantação do recurso (`dev`, `hml` ou `prd`).                                   |
| system               | string                | Sim         | Nome do sistema ou aplicação ao qual o recurso pertence.                                       |
| region               | string                | Não         | Região AWS onde o recurso será provisionado. Padrão: `us-east-1`.                              |
| additional_tags      | map(string)           | Não         | Tags adicionais a serem mescladas com as tags obrigatórias. Padrão: `{}`.                       |
| security_group_name  | string                | Sim         | Finalidade do Security Group, usada para compor o nome padronizado (ex.: `web`, `db`, `api`).  |
| vpc_id               | string                | Sim         | ID da VPC onde o Security Group será criado.                                                   |
| ingress_rules        | list(object)          | Não         | Lista de regras de entrada (description, from_port, to_port, protocol, cidr_blocks). Padrão: `[]`. |
| egress_rules         | list(object)          | Não         | Lista de regras de saída (description, from_port, to_port, protocol, cidr_blocks). Padrão: `[]`.  |

## Outputs

| Nome                  | Descrição                              |
|-----------------------|------------------------------------------|
| security_group_name   | Nome do Security Group criado.          |
| security_group_arn    | ARN do Security Group criado.           |
| security_group_id     | ID do Security Group criado.            |

## Exemplo de uso

```
module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

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
      description = "Acesso HTTPS para atualização de pacotes"
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
```
