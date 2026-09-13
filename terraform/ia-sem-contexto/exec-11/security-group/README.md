# Security Group (AWS)

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC informada via variavel.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-xxxxxxxx"
  name        = "sg-aplicacao"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH restrito a rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "equipe-infra"
  }
}
```

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0

## Inputs

| Nome           | Descricao                                              | Tipo                  | Default                         |
|----------------|---------------------------------------------------------|-----------------------|----------------------------------|
| vpc_id         | ID da VPC onde o Security Group sera criado             | string                | (obrigatorio)                   |
| name           | Nome do Security Group                                  | string                | "sg-default"                    |
| description    | Descricao do Security Group                             | string                | "Security Group gerenciado via Terraform" |
| ingress_rules  | Lista de regras de entrada (descricao, portas, protocolo, cidr_blocks) | list(object) | []                               |
| egress_rules   | Lista de regras de saida (descricao, portas, protocolo, cidr_blocks)   | list(object) | permite todo trafego de saida    |
| tags           | Tags adicionais aplicadas ao recurso                     | map(string)           | {}                               |

## Outputs

| Nome                  | Descricao                                 |
|-----------------------|--------------------------------------------|
| security_group_id     | ID do Security Group criado                |
| security_group_arn    | ARN do Security Group criado               |
| security_group_name   | Nome do Security Group criado              |
| vpc_id                | ID da VPC associada ao Security Group      |

## Boas praticas aplicadas

- Nenhuma regra de entrada e definida por padrao (`ingress_rules = []`), evitando exposicao acidental de portas.
- A regra de saida padrao permite todo o trafego, seguindo o comportamento padrao de Security Groups na AWS, mas pode ser sobrescrita via `egress_rules`.
- `vpc_id` e obrigatorio e configuravel, permitindo uso em qualquer VPC, inclusive VPCs criadas por outros modulos ou ambientes de teste.
- `create_before_destroy` habilitado no lifecycle para reduzir impacto em substituicoes do recurso.
