# Security Group - Terraform Blueprint

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras de entrada e saída explícitas, dentro de uma VPC configurável (não a VPC padrão da conta).

## Recursos criados

- `aws_security_group.this`: Security Group com regras de ingress/egress definidas via variáveis dinâmicas (`dynamic` blocks).

## Postura de segurança

- Nenhuma regra de ingress é aplicada por padrão (`ingress_rules = []`), evitando exposição não intencional.
- A única regra de egress padrão libera somente tráfego HTTPS (porta 443) para `0.0.0.0/0`, em vez de liberar todo o tráfego de saída.
- O `vpc_id` é validado para garantir o formato esperado (`vpc-xxxxxxxx`) e deve apontar para a VPC provisionada pelo próprio ambiente de teste.
- Todas as portas, protocolos e CIDRs de entrada/saída devem ser declarados explicitamente pelo consumidor do módulo.

## Uso

```hcl
module "security_group" {
  source = "./"

  vpc_id      = "vpc-0123456789abcdef0"
  name        = "sg-app"
  description = "Security Group da aplicação"

  ingress_rules = [
    {
      description = "Acesso HTTPS interno"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
    Project     = "tcc"
  }
}
```

## Variáveis

| Nome            | Descrição                                            | Tipo           | Padrão                              |
|-----------------|-------------------------------------------------------|----------------|--------------------------------------|
| `region`        | Região AWS                                            | `string`       | `"us-east-1"`                        |
| `vpc_id`        | ID da VPC onde o SG será criado                       | `string`       | *obrigatório*                        |
| `name`          | Nome do Security Group                                | `string`       | `"sg-default"`                       |
| `description`   | Descrição do Security Group                           | `string`       | `"Security Group gerenciado via Terraform."` |
| `ingress_rules` | Lista de regras de entrada                            | `list(object)` | `[]`                                  |
| `egress_rules`  | Lista de regras de saída                              | `list(object)` | HTTPS (443) de saída liberado         |
| `tags`          | Tags adicionais                                       | `map(string)`  | `{}`                                  |

## Outputs

| Nome                   | Descrição                                   |
|------------------------|----------------------------------------------|
| `security_group_id`    | ID do Security Group criado                  |
| `security_group_arn`   | ARN do Security Group criado                 |
| `security_group_name`  | Nome do Security Group criado                |
| `vpc_id`               | ID da VPC associada                          |
| `ingress_rule_count`   | Quantidade de regras de entrada aplicadas    |
| `egress_rule_count`    | Quantidade de regras de saída aplicadas      |

## Validação

```bash
terraform init -backend=false
terraform validate
```
