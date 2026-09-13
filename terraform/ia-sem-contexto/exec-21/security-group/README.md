# Security Group (AWS)

Blueprint Terraform para provisionamento de um Security Group na AWS, associado a uma VPC informada via variavel.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0

## Variaveis principais

| Nome            | Descricao                                              | Tipo          | Default          |
|-----------------|---------------------------------------------------------|---------------|------------------|
| `aws_region`    | Regiao AWS                                               | `string`      | `"us-east-1"`    |
| `vpc_id`        | ID da VPC onde o Security Group sera criado (obrigatorio)| `string`      | -                |
| `name`          | Nome do Security Group                                   | `string`      | `"app-sg"`       |
| `description`   | Descricao do Security Group                              | `string`      | -                |
| `ingress_rules` | Lista de regras de entrada                                | `list(object)`| `[]`             |
| `egress_rules`  | Lista de regras de saida                                  | `list(object)`| Allow all outbound |
| `tags`          | Tags adicionais                                           | `map(string)` | `{}`             |

## Seguranca por padrao

- Nenhuma regra de entrada e criada por padrao (`ingress_rules = []`), seguindo o principio de menor privilegio.
- Cabe ao consumidor do modulo definir explicitamente as portas e origens (CIDRs) necessarias, evitando exposicoes amplas como `0.0.0.0/0` em portas sensiveis.
- A regra de saida padrao permite todo o trafego (`egress_rules`), podendo ser restringida conforme necessidade.

## Exemplo de uso

```
module "sg" {
  source = "./"

  vpc_id = "vpc-xxxxxxxx"
  name   = "web-sg"

  ingress_rules = [
    {
      description = "HTTPS from corporate network"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Outputs

- `security_group_id`
- `security_group_arn`
- `security_group_name`
- `security_group_vpc_id`
