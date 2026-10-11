# Security Group - Blueprint Terraform

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras explicitas de entrada e saida, tags configuraveis e outputs relevantes.

## Recursos criados

- `aws_security_group.this`: Security Group associado a uma VPC configuravel.

## Variaveis principais

| Nome            | Descricao                                                                 | Tipo           | Default                        |
|-----------------|----------------------------------------------------------------------------|----------------|---------------------------------|
| `vpc_id`        | ID da VPC (criada pelo ambiente de teste) onde o SG sera provisionado      | `string`       | obrigatorio                     |
| `name`          | Nome do Security Group                                                     | `string`       | `"app-sg"`                      |
| `description`   | Descricao do Security Group                                                | `string`       | ver `variables.tf`              |
| `ingress_rules` | Lista de regras de entrada explicitas                                      | `list(object)` | regra HTTPS restrita a `10.0.0.0/16` |
| `egress_rules`  | Lista de regras de saida explicitas                                        | `list(object)` | HTTPS e DNS                     |
| `tags`          | Tags adicionais aplicadas ao recurso                                        | `map(string)`  | `{}`                             |
| `aws_region`    | Regiao AWS utilizada pelo provider                                          | `string`       | `"us-east-1"`                    |

> Nao ha regra de entrada liberada para `0.0.0.0/0` por padrao. Caso seja necessario, ajuste `ingress_rules` explicitamente e com consciencia do risco.

## Outputs

- `security_group_id`
- `security_group_arn`
- `security_group_name`
- `vpc_id`

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-sg"

  ingress_rules = [
    {
      description = "HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
  }
}
```

## Validacao

```bash
terraform init -backend=false
terraform validate
terraform fmt -check
```

## Observacoes de seguranca

- Nenhuma regra de entrada ou saida usa credenciais ou valores sensiveis fixos.
- As regras de entrada e saida sao explicitas e configuraveis via variaveis, evitando abertura irrestrita desnecessaria.
- O Security Group deve ser associado a uma VPC criada pelo ambiente de teste, e nao a VPC default da conta.
