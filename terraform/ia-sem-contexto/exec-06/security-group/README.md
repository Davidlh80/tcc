# Security Group (AWS)

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC informada por variavel.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Uma VPC ja existente, cujo ID sera informado via `var.vpc_id`

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-xxxxxxxx"
  name        = "app-sg"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "Acesso HTTPS interno"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis

| Nome            | Descricao                                     | Tipo                | Padrao              |
|-----------------|------------------------------------------------|---------------------|----------------------|
| region          | Regiao AWS de provisionamento                  | `string`            | `"us-east-1"`        |
| vpc_id          | ID da VPC onde o Security Group sera criado    | `string`            | (obrigatorio)        |
| name            | Nome do Security Group                         | `string`            | `"app-sg"`           |
| description     | Descricao do Security Group                    | `string`            | `"Security Group gerenciado via Terraform"` |
| ingress_rules   | Lista de regras de entrada                     | `list(object)`      | Ver `variables.tf`   |
| egress_rules    | Lista de regras de saida                       | `list(object)`      | Ver `variables.tf`   |
| tags            | Tags adicionais                                | `map(string)`       | `{}`                 |

## Outputs

| Nome                | Descricao                          |
|---------------------|-------------------------------------|
| security_group_id   | ID do Security Group criado         |
| security_group_arn  | ARN do Security Group criado        |
| security_group_name | Nome do Security Group criado       |
| vpc_id              | ID da VPC associada                 |

## Seguranca

- Nenhuma regra de entrada padrao permite origem `0.0.0.0/0`; uma validacao de variavel bloqueia essa configuracao para `ingress_rules`.
- Regras de entrada e saida sao totalmente parametrizaveis, permitindo restringir portas e origens conforme a politica de seguranca do ambiente.
- Nao ha valores sensiveis fixos no codigo; credenciais e configuracao de regiao devem ser fornecidas pelo ambiente de execucao (variaveis de ambiente, perfil AWS, etc.).

## Validacao

```
terraform init -backend=false
terraform validate
```
