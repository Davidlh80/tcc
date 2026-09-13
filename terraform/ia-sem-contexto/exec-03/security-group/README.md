# Security Group (AWS)

Blueprint Terraform para provisionar um `aws_security_group` dentro de uma VPC existente, com ID configuravel por variavel.

## Recursos criados

- `aws_security_group.this`

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "web-sg"
  description = "Security group para servidores web"

  ingress_rules = [
    {
      description = "HTTPS from internal network"
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

## Entradas

| Nome            | Tipo               | Padrao                                    | Descricao                                                                 |
|-----------------|--------------------|--------------------------------------------|----------------------------------------------------------------------------|
| `vpc_id`        | `string`           | n/a (obrigatorio)                          | ID da VPC onde o Security Group sera criado.                              |
| `name`          | `string`           | `"app-sg"`                                 | Nome do Security Group.                                                    |
| `description`   | `string`           | `"Managed by Terraform"`                   | Descricao do Security Group.                                               |
| `ingress_rules` | `list(object)`     | `[]`                                        | Regras de entrada. Vazia por padrao (secure by default).                  |
| `egress_rules`  | `list(object)`     | Allow all outbound (`0.0.0.0/0`, protocolo `-1`) | Regras de saida.                                                      |
| `tags`          | `map(string)`      | `{}`                                        | Tags adicionais.                                                            |
| `aws_region`    | `string`           | `"us-east-1"`                              | Regiao AWS usada pelo provider.                                            |

## Saidas

| Nome                       | Descricao                                    |
|----------------------------|-----------------------------------------------|
| `security_group_id`        | ID do Security Group criado.                  |
| `security_group_arn`       | ARN do Security Group criado.                 |
| `security_group_name`      | Nome do Security Group criado.                |
| `security_group_vpc_id`    | ID da VPC associada.                          |
| `security_group_owner_id`  | ID da conta AWS proprietaria do recurso.      |

## Consideracoes de seguranca

- Nenhuma regra de entrada e criada por padrao (`ingress_rules = []`), evitando exposicao acidental de portas.
- A regra de saida padrao libera todo o trafego (`0.0.0.0/0`), padrao comum em ambientes AWS; ajuste `egress_rules` caso deseje restringir.
- Prefira CIDRs restritos em vez de `0.0.0.0/0` para regras de entrada em ambientes de producao.
- `vpc_id` e validado quanto ao formato esperado de um ID de VPC da AWS.
