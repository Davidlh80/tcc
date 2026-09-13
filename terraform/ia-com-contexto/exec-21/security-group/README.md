# Security Group

## Visao geral

Este template Terraform provisiona um Security Group na AWS, com o ID da VPC configuravel por variavel. As regras de entrada (ingress) e saida (egress) sao configuraveis por meio de variaveis do tipo lista de objetos, sendo obrigatorio informar uma descricao para cada regra. O uso do CIDR `0.0.0.0/0` e proibido em qualquer porta que nao seja a 443/tcp, tanto em regras de entrada quanto de saida. Nao ha liberacao de egress irrestrita por padrao: o valor padrao de `egress_rules` libera apenas trafego HTTPS (443/tcp) de saida. O recurso segue o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatorias da organizacao.

## Variaveis

| Nome                        | Tipo                                                                                          | Obrigatoria | Descricao                                                                                     |
|-----------------------------|-----------------------------------------------------------------------------------------------|-------------|-------------------------------------------------------------------------------------------------|
| environment                 | string                                                                                         | Sim         | Ambiente de implantacao (dev, hml ou prd).                                                     |
| system                      | string                                                                                         | Sim         | Identificador do sistema/aplicacao ao qual o recurso pertence.                                 |
| region                      | string                                                                                         | Sim         | Regiao AWS onde o Security Group sera criado.                                                  |
| additional_tags             | map(string)                                                                                    | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| security_group_name         | string                                                                                         | Sim         | Finalidade/identificador do Security Group, usado para compor o nome do recurso (ex.: web).    |
| security_group_description  | string                                                                                         | Nao         | Descricao do Security Group. Padrao: `"Managed by Terraform"`.                                 |
| vpc_id                      | string                                                                                         | Sim         | ID da VPC onde o Security Group sera criado.                                                    |
| ingress_rules               | list(object({ description, from_port, to_port, protocol, cidr_blocks }))                      | Nao         | Regras de entrada do Security Group, com descricao obrigatoria. Padrao: `[]`.                  |
| egress_rules                | list(object({ description, from_port, to_port, protocol, cidr_blocks }))                      | Nao         | Regras de saida do Security Group, com descricao obrigatoria. Padrao: HTTPS (443/tcp) de saida. |

## Outputs

| Nome                  | Descricao                                |
|------------------------|-------------------------------------------|
| security_group_name    | Nome do Security Group criado.            |
| security_group_arn     | ARN do Security Group criado.             |
| security_group_id      | ID do Security Group criado.              |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Permite HTTPS de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite acesso interno na porta 8080"
      from_port   = 8080
      to_port     = 8080
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
