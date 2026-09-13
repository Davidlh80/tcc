# Security Group (AWS) - Terraform Blueprint

Blueprint Terraform para provisionamento de um Security Group na AWS, dentro de uma VPC cujo ID e informado por variavel.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.3.0
- Provider AWS `~> 5.0`

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-xxxxxxxx"
  name        = "app-sg"
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
      description = "SSH restrito a uma faixa interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
    Owner        = "infra"
  }
}
```

## Variaveis

| Nome           | Descricao                                              | Tipo                 | Default                                  |
|----------------|----------------------------------------------------------|----------------------|-------------------------------------------|
| `aws_region`   | Regiao AWS                                               | `string`             | `"us-east-1"`                             |
| `vpc_id`       | ID da VPC onde o Security Group sera criado (obrigatorio)| `string`             | -                                          |
| `name`         | Nome do Security Group                                   | `string`             | `"example-sg"`                            |
| `description`  | Descricao do Security Group                              | `string`             | `"Security Group gerenciado via Terraform"` |
| `ingress_rules`| Lista de regras de entrada                               | `list(object(...))`  | `[]`                                       |
| `egress_rules` | Lista de regras de saida                                  | `list(object(...))`  | permite todo trafego de saida              |
| `tags`         | Tags adicionais                                           | `map(string)`        | `{}`                                       |

## Outputs

| Nome     | Descricao                              |
|----------|-------------------------------------------|
| `id`     | ID do Security Group criado               |
| `arn`    | ARN do Security Group criado               |
| `name`   | Nome do Security Group criado              |
| `vpc_id` | ID da VPC associada ao Security Group      |

## Consideracoes de seguranca

- Nenhuma regra de entrada e liberada por padrao (`ingress_rules = []`); o consumidor do modulo deve declarar explicitamente as portas e origens necessarias, evitando exposicao acidental.
- Recomenda-se restringir `cidr_blocks` a faixas conhecidas sempre que possivel, evitando `0.0.0.0/0` em regras de entrada, especialmente para portas administrativas (ex.: 22, 3389).
- O trafego de saida e permitido integralmente por padrao (`egress_rules` default), pratica comum em Security Groups; ajuste conforme a politica de seguranca do ambiente, se necessario.
- Nao fixe credenciais ou valores sensiveis neste codigo; utilize variaveis, arquivos `.tfvars` nao versionados ou um gerenciador de segredos.
