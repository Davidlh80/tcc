# Security Group (Terraform / AWS)

Blueprint Terraform para provisionamento de um AWS Security Group com regras explicitas de entrada e saida, sem depender da VPC default da conta.

## Recursos criados

- `aws_security_group.this`: Security Group associado a uma VPC informada via variavel, com regras de ingress e egress definidas dinamicamente a partir de listas de objetos.

## Requisitos

- Terraform >= 1.3.0
- Provider AWS >= 5.0.0, < 6.0.0
- Credenciais AWS configuradas (nao necessarias para `terraform validate`)

## Variaveis principais

| Nome            | Descricao                                                                 | Tipo          | Default                                 |
|-----------------|----------------------------------------------------------------------------|---------------|------------------------------------------|
| `vpc_id`        | ID da VPC (criada pelo ambiente de teste) onde o SG sera provisionado     | `string`      | obrigatorio                             |
| `name`          | Nome do Security Group                                                    | `string`      | `"app-sg"`                               |
| `description`   | Descricao do Security Group                                               | `string`      | `"Security Group gerenciado via Terraform"` |
| `ingress_rules` | Lista de regras de entrada explicitas (sem default, deve ser definida pelo usuario) | `list(object)` | `[]`                                    |
| `egress_rules`  | Lista de regras de saida explicitas                                       | `list(object)` | HTTPS (443) liberado para `0.0.0.0/0`   |
| `tags`          | Tags adicionais aplicadas ao Security Group                               | `map(string)` | `{}`                                     |

Cada regra de `ingress_rules` e `egress_rules` segue o formato:

```
{
  description = "..."
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}
```

## Boas praticas aplicadas

- Nenhuma regra de ingress e definida por padrao, evitando exposicao acidental de portas.
- O default de egress libera apenas a porta 443 (HTTPS), e nao todas as portas/protocolos.
- Validacoes garantem que os valores de `cidr_blocks` sejam blocos CIDR validos e que `from_port <= to_port`.
- `vpc_id` e validado quanto ao formato esperado (`vpc-xxxxxxxx`).
- Tags sao aplicadas via `merge()`, garantindo que `Name` esteja sempre presente junto das tags customizadas.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "web-sg"

  ingress_rules = [
    {
      description = "Permite HTTPS de entrada da rede interna"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
    Project      = "experimento-ia"
  }
}
```

## Validacao

```
terraform init -backend=false
terraform validate
```
