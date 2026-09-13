# Security Group (AWS) — Terraform Blueprint

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, com regras de entrada e saida totalmente configuraveis via variaveis.

## Recursos criados

- `aws_security_group.this`

## Requisitos

- Terraform >= 1.5.0
- Provider AWS `~> 5.0`
- Uma VPC ja existente (o `vpc_id` deve ser informado; este modulo nao cria a VPC)

## Comportamento padrao (seguro)

- **Ingress**: por padrao, nenhuma regra de entrada e criada (`ingress_rules = []`), ou seja, todo trafego de entrada e negado ate que regras sejam explicitamente declaradas.
- **Egress**: por padrao, todo o trafego de saida e permitido (`0.0.0.0/0`, todas as portas e protocolos), seguindo o comportamento padrao da AWS. Ajuste `egress_rules` para restringir conforme a necessidade.

## Variaveis principais

| Nome            | Tipo                | Padrao                        | Descricao                                              |
|-----------------|---------------------|--------------------------------|---------------------------------------------------------|
| `vpc_id`        | `string`            | obrigatorio                   | ID da VPC onde o Security Group sera criado.            |
| `name`          | `string`            | `"sg-app"`                    | Nome base do Security Group.                             |
| `description`   | `string`            | `"Managed by Terraform"`      | Descricao do Security Group.                             |
| `ingress_rules` | `list(object(...))` | `[]`                           | Regras de entrada (descricao, portas, protocolo, CIDRs).|
| `egress_rules`  | `list(object(...))` | permite todo trafego de saida | Regras de saida.                                         |
| `tags`          | `map(string)`       | `{}`                           | Tags adicionais.                                         |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-web"

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
    Environment = "staging"
    Owner       = "platform-team"
  }
}
```

## Outputs

| Nome     | Descricao                                  |
|----------|----------------------------------------------|
| `id`     | ID do Security Group criado.                  |
| `arn`    | ARN do Security Group criado.                 |
| `vpc_id` | ID da VPC associada.                          |
| `name`   | Nome efetivo do Security Group criado.        |

## Validacao local

```bash
terraform init -backend=false
terraform validate
```

## Notas de seguranca

- Evite CIDRs amplos (ex.: `0.0.0.0/0`) em regras de ingress; restrinja a origens conhecidas sempre que possivel.
- Prefira portas especificas em vez de faixas amplas.
- Revise periodicamente `ingress_rules` e `egress_rules` para remover acessos nao utilizados.
