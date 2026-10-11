# Security Group (Terraform)

Blueprint para provisionamento de um Security Group na AWS, com regras explicitas de entrada e saida, dentro de uma VPC configuravel por variavel.

## Recursos criados

- `aws_security_group.this` — o Security Group.
- `aws_security_group_rule.ingress` — uma regra por item em `var.ingress_rules`.
- `aws_security_group_rule.egress` — uma regra por item em `var.egress_rules`.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-xxxxxxxxxxxxxxxxx"
  name   = "sg-aplicacao"

  ingress_rules = [
    {
      description = "HTTPS a partir da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "HTTPS de saida"
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

| Nome            | Descricao                                             | Tipo          | Default                                      |
|-----------------|--------------------------------------------------------|---------------|-----------------------------------------------|
| `name`          | Nome do Security Group                                  | `string`      | `"sg-managed-by-terraform"`                   |
| `description`   | Descricao do Security Group                             | `string`      | `"Security Group gerenciado via Terraform."`  |
| `vpc_id`        | ID da VPC onde o Security Group sera criado             | `string`      | obrigatorio                                   |
| `ingress_rules` | Lista de regras explicitas de entrada                   | `list(object)`| regra HTTPS de uma rede interna               |
| `egress_rules`  | Lista de regras explicitas de saida                      | `list(object)`| regras HTTPS e DNS de saida                   |
| `tags`          | Tags adicionais aplicadas ao recurso                     | `map(string)` | `{}`                                           |

## Outputs

| Nome                  | Descricao                                       |
|-----------------------|--------------------------------------------------|
| `security_group_id`   | ID do Security Group criado                      |
| `security_group_arn`  | ARN do Security Group criado                      |
| `security_group_name` | Nome do Security Group criado                      |
| `vpc_id`              | ID da VPC associada                               |
| `ingress_rule_ids`    | Mapa com os IDs das regras de entrada criadas      |
| `egress_rule_ids`     | Mapa com os IDs das regras de saida criadas        |

## Observacoes de seguranca

- Nenhuma regra de entrada e aberta por padrao para `0.0.0.0/0`; o exemplo padrao restringe o acesso HTTPS a um bloco CIDR interno (`10.0.0.0/16`).
- As regras de entrada e saida devem ser definidas explicitamente via `ingress_rules` e `egress_rules`, evitando liberacoes irrestritas desnecessarias.
- Nao ha credenciais, segredos ou valores sensiveis fixos no codigo.
- Nenhum backend remoto e configurado; o estado deve ser gerenciado conforme a necessidade de cada ambiente.
