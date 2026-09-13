# Security Group (AWS)

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC informada via variavel.

## Recursos criados

- `aws_security_group.this`: Security Group com regras de entrada e saida configuraveis dinamicamente.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS ~> 5.0

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "app-sg"

  ingress_rules = [
    {
      description = "HTTPS interno"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Variaveis principais

| Nome            | Descricao                                  | Tipo          | Padrao                          |
|-----------------|---------------------------------------------|---------------|----------------------------------|
| `vpc_id`        | ID da VPC onde o SG sera criado             | `string`      | -                                 |
| `name`          | Nome do Security Group                      | `string`      | -                                 |
| `description`   | Descricao do Security Group                 | `string`      | `"Managed by Terraform"`         |
| `ingress_rules` | Lista de regras de entrada                  | `list(object)`| `[]`                              |
| `egress_rules`  | Lista de regras de saida                    | `list(object)`| Libera todo trafego de saida     |
| `tags`          | Tags adicionais                             | `map(string)` | `{}`                              |

## Seguranca por padrao

- Nenhuma regra de ingress e criada por padrao (lista vazia).
- Regras de ingress com origem `0.0.0.0/0` sao bloqueadas por validacao — informe CIDRs restritos.
- Regras de egress liberam todo o trafego de saida por padrao, podendo ser restringidas conforme a necessidade.

## Outputs

| Nome                   | Descricao                              |
|------------------------|------------------------------------------|
| `security_group_id`    | ID do Security Group criado              |
| `security_group_arn`   | ARN do Security Group criado             |
| `security_group_name`  | Nome do Security Group criado            |
| `vpc_id`               | ID da VPC associada ao Security Group    |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
