# Security Group (AWS) - Terraform Blueprint

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC informada via variavel.

## Recursos criados

- `aws_security_group.this`: Security Group com regras de ingress e egress configuraveis via listas de objetos.

## Padroes de seguranca adotados

- Nenhuma regra de entrada e liberada por padrao (`ingress_rules = []`), seguindo o principio de menor privilegio.
- O egress padrao libera todo o trafego de saida (`0.0.0.0/0`), comportamento padrao do provider AWS, mas pode ser restringido sobrescrevendo `egress_rules`.
- Uso de `name_prefix` combinado com `create_before_destroy` para evitar conflitos de nome durante recriacoes do recurso.
- Validacoes de variaveis garantem que `from_port <= to_port` e que cada regra possua ao menos um CIDR definido.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-sg"

  ingress_rules = [
    {
      description = "HTTPS"
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

| Nome            | Descricao                                   | Padrao                          |
|-----------------|----------------------------------------------|----------------------------------|
| `aws_region`    | Regiao AWS do provider                        | `us-east-1`                     |
| `vpc_id`        | ID da VPC de destino (obrigatorio)            | -                                |
| `name`          | Nome base do Security Group                   | `app-sg`                        |
| `description`   | Descricao do Security Group                   | `Security Group gerenciado via Terraform` |
| `ingress_rules` | Lista de regras de entrada                    | `[]`                             |
| `egress_rules`  | Lista de regras de saida                      | Libera todo trafego de saida    |
| `tags`          | Tags adicionais                               | `{}`                             |

## Outputs

| Nome                   | Descricao                              |
|------------------------|------------------------------------------|
| `security_group_id`    | ID do Security Group criado             |
| `security_group_arn`   | ARN do Security Group criado            |
| `security_group_name`  | Nome efetivo do recurso                 |
| `vpc_id`               | ID da VPC associada                     |

## Validacao local

```bash
terraform init -backend=false
terraform validate
```
