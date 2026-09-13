# Security Group

## Visao geral

Este template cria um Security Group na AWS, com o ID da VPC configuravel por variavel. As regras de entrada e de saida sao definidas por variaveis, com descricao obrigatoria em cada regra. O CIDR `0.0.0.0/0` e proibido em qualquer porta diferente de 443/tcp, tanto em ingress quanto em egress, e o egress e declarado de forma explicita, sem liberacao irrestrita por padrao. O nome do recurso e as tags seguem o padrao organizacional definido para o projeto `tcc-iac-ia`.

## Variaveis

| Nome                 | Tipo                                                                                                    | Obrigatoria | Descricao                                                                                   |
|----------------------|-----------------------------------------------------------------------------------------------------------|-------------|-----------------------------------------------------------------------------------------------|
| environment          | string                                                                                                   | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| system               | string                                                                                                   | Nao         | Nome do sistema ou produto. Padrao: `tcc`.                                                    |
| region               | string                                                                                                   | Nao         | Regiao AWS de criacao do recurso. Padrao: `us-east-1`.                                        |
| additional_tags      | map(string)                                                                                              | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao.                             |
| vpc_id               | string                                                                                                   | Sim         | ID da VPC onde o Security Group sera criado.                                                   |
| security_group_name  | string                                                                                                   | Sim         | Finalidade do Security Group, usada na composicao do nome padronizado (ex.: `web`).            |
| ingress_rules        | list(object({ description, from_port, to_port, protocol, cidr_blocks }))                                | Nao         | Regras de entrada. Cada regra exige descricao; `0.0.0.0/0` restrito a 443/tcp. Padrao: `[]`.   |
| egress_rules         | list(object({ description, from_port, to_port, protocol, cidr_blocks }))                                | Nao         | Regras de saida. Cada regra exige descricao; `0.0.0.0/0` restrito a 443/tcp. Padrao: HTTPS 443.|

## Outputs

| Nome                 | Descricao                              |
|----------------------|-----------------------------------------|
| security_group_name  | Nome do Security Group criado.         |
| security_group_arn   | ARN do Security Group criado.          |
| security_group_id    | ID do Security Group criado.           |

## Exemplo de uso

```hcl
module "security_group" {
  source = "./security-group"

  environment          = "hml"
  system                = "tcc"
  region                = "us-east-1"
  vpc_id                = "vpc-0123456789abcdef0"
  security_group_name   = "web"

  ingress_rules = [
    {
      description = "Permite HTTPS de entrada da internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite acesso SSH somente da rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite trafego HTTPS de saida"
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
