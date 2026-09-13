# Security Group

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC configuravel via variavel.

## Recursos criados

- `aws_security_group.this`: Security Group com regras de entrada e saida configuraveis via variaveis.

## Postura de seguranca

- Por padrao, nenhuma regra de entrada e criada (`ingress_rules = []`), evitando exposicao acidental de portas.
- Por padrao, o trafego de saida e liberado totalmente (`0.0.0.0/0`), padrao comum em ambientes AWS. Restrinja `egress_rules` se necessario para o seu caso de uso.
- Nenhum CIDR aberto (`0.0.0.0/0`) e definido por padrao para entrada. Ao configurar `ingress_rules`, evite usar `0.0.0.0/0` em portas sensiveis (ex.: 22, 3389) e prefira CIDRs restritos.

## Variaveis

| Nome            | Descricao                                              | Tipo                 | Padrao                          |
|-----------------|---------------------------------------------------------|----------------------|----------------------------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado             | `string`             | (obrigatorio)                    |
| `name`          | Nome do Security Group                                   | `string`             | `"app-sg"`                        |
| `description`   | Descricao do Security Group                              | `string`             | `"Security Group gerenciado via Terraform"` |
| `ingress_rules` | Lista de regras de entrada                                | `list(object)`       | `[]`                               |
| `egress_rules`  | Lista de regras de saida                                  | `list(object)`       | libera todo trafego de saida     |
| `tags`          | Tags adicionais                                           | `map(string)`        | `{}`                               |

### Formato de cada regra (`ingress_rules` / `egress_rules`)

```
{
  description = string (opcional)
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks = list(string)
}
```

## Outputs

| Nome                  | Descricao                                |
|-----------------------|--------------------------------------------|
| `security_group_id`   | ID do Security Group criado                |
| `security_group_arn`  | ARN do Security Group criado               |
| `security_group_name` | Nome do Security Group criado              |
| `vpc_id`               | ID da VPC associada ao Security Group      |

## Exemplo de uso

```hcl
module "sg" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "web-sg"
  description = "Security Group para servidores web"

  ingress_rules = [
    {
      description = "HTTPS de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]

  tags = {
    Environment = "producao"
  }
}
```

## Validacao

```
terraform init -backend=false
terraform validate
```
