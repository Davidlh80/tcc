# Security Group Blueprint

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente (o `vpc_id` e informado por variavel, sem depender da VPC default da conta).

## Recursos criados

- `aws_security_group.this`

## Postura de seguranca

- Por padrao, `ingress_rules` e `egress_rules` sao listas vazias, ou seja, o Security Group e criado sem nenhuma regra de entrada ou saida (nega todo o trafego por padrao).
- Todas as regras (portas, protocolos e CIDRs) devem ser declaradas explicitamente pelo consumidor do modulo.
- Os CIDRs informados sao validados por formato (IPv4 CIDR) antes do `apply`.
- Nenhum valor sensivel ou credencial esta embutido no codigo.

## Uso

```
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "app-sg"
  description = "Security Group da aplicacao"

  ingress_rules = [
    {
      description = "HTTPS de dentro da VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "HTTPS para a internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Ambiente = "teste"
  }
}
```

## Inputs

| Nome            | Descricao                                            | Tipo                | Default              |
|-----------------|-------------------------------------------------------|---------------------|-----------------------|
| aws_region      | Regiao AWS para o provider                            | `string`             | `"us-east-1"`         |
| vpc_id          | ID da VPC onde o Security Group sera criado           | `string`             | *obrigatorio*         |
| name            | Nome do Security Group                                | `string`             | `"sg-default"`        |
| description     | Descricao do Security Group                           | `string`             | `"Managed by Terraform"` |
| ingress_rules   | Lista de regras de entrada                             | `list(object(...))`  | `[]`                  |
| egress_rules    | Lista de regras de saida                                | `list(object(...))`  | `[]`                  |
| tags            | Tags adicionais                                        | `map(string)`        | `{}`                  |

## Outputs

| Nome                 | Descricao                              |
|----------------------|------------------------------------------|
| security_group_id    | ID do Security Group criado             |
| security_group_arn   | ARN do Security Group criado            |
| security_group_name  | Nome do Security Group criado           |
| vpc_id               | ID da VPC associada ao Security Group   |

## Validacao

```
terraform init -backend=false
terraform validate
```
