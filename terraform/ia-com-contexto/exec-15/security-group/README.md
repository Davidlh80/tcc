# Security Group

## 1. Visão geral

Este template Terraform provisiona um Security Group na AWS seguindo os padrões organizacionais de nomenclatura, tags e segurança. O nome do recurso é composto automaticamente no formato `<ambiente>-<sistema>-sg-<finalidade>` (ex.: `hml-tcc-sg-web`).

O recurso aplica as seguintes garantias de segurança:

- O CIDR `0.0.0.0/0` só é aceito em regras de entrada ou saída quando a porta for exatamente 443/tcp; qualquer outra combinação é bloqueada por validação de variável.
- Toda regra de entrada e de saída exige uma descrição não vazia.
- Não há liberação irrestrita de egress por padrão: o valor padrão de `egress_rules` libera apenas saída HTTPS (443/tcp); qualquer outra saída deve ser declarada explicitamente pelo consumidor do módulo.
- Não há regras de entrada por padrão (`ingress_rules` inicia vazio), seguindo o princípio do menor privilégio.
- Tags obrigatórias da organização são aplicadas automaticamente, com possibilidade de complemento via `additional_tags`.

## 2. Variáveis

| Nome                   | Tipo                     | Obrigatória | Descrição                                                                                     |
|------------------------|--------------------------|-------------|-------------------------------------------------------------------------------------------------|
| environment            | string                   | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                |
| system                 | string                   | Sim         | Identificador do sistema/projeto, usado na nomenclatura padronizada.                             |
| region                 | string                   | Não         | Região AWS onde o recurso será criado. Padrão: `us-east-1`.                                     |
| additional_tags        | map(string)              | Não         | Tags adicionais mescladas às tags obrigatórias. Padrão: `{}`.                                   |
| security_group_name    | string                   | Sim         | Finalidade/nome do Security Group, usado na composição do nome padronizado.                     |
| vpc_id                 | string                   | Sim         | ID da VPC onde o Security Group será criado.                                                    |
| ingress_rules          | list(object)             | Não         | Regras de entrada (description, from_port, to_port, protocol, cidr_blocks). Padrão: `[]`.       |
| egress_rules           | list(object)             | Não         | Regras de saída (description, from_port, to_port, protocol, cidr_blocks). Padrão: HTTPS (443/tcp) para `0.0.0.0/0`. |

## 3. Outputs

| Nome                  | Descrição                                  |
|-----------------------|---------------------------------------------|
| security_group_name   | Nome do Security Group criado.              |
| security_group_arn    | ARN do Security Group criado.               |
| security_group_id     | ID do Security Group criado.                |

## 4. Exemplo de uso

module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  ingress_rules = [
    {
      description = "Acesso HTTPS externo"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Acesso SSH restrito à rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saída HTTPS para integrações externas"
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
