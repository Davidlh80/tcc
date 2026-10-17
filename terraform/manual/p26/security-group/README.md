# Security Group — p26

Template Terraform que cria um Security Group com regras explícitas de entrada e saída, sem abertura irrestrita.

> Template gerado com assistência de IA (Claude), com autorização do instrutor.

## Recursos criados

| Recurso | Finalidade |
|---|---|
| `aws_security_group` | Security Group na VPC informada |
| `aws_vpc_security_group_ingress_rule` | Uma regra TCP por combinação porta × CIDR |
| `aws_vpc_security_group_egress_rule` | Saída restrita a HTTPS (443) |

## Decisões

- Entrada rejeita `0.0.0.0/0`; padrão: porta 443 a partir de `10.0.0.0/8`.
- Saída limitada a 443; destinos padrão iguais a `allowed_cidrs`, ajustáveis via `egress_cidrs`.
- Toda regra tem descrição, facilitando auditoria.

## Variáveis

| Nome | Tipo | Padrão | Descrição |
|---|---|---|---|
| `region` | `string` | `us-east-1` | Região AWS |
| `environment` | `string` | — | `dev`, `hml` ou `prod` |
| `security_group_name` | `string` | — | Nome do Security Group |
| `vpc_id` | `string` | — | ID da VPC |
| `allowed_ports` | `list(number)` | `[443]` | Portas TCP de entrada |
| `allowed_cidrs` | `list(string)` | `["10.0.0.0/8"]` | Origens autorizadas |
| `egress_cidrs` | `list(string)` | `null` | Destinos HTTPS de saída |
| `tags` | `map(string)` | `{}` | Tags adicionais |

## Outputs

`security_group_id`, `security_group_arn`, `security_group_name`.

## Uso

```bash
terraform init
terraform validate
terraform plan \
  -var="environment=dev" \
  -var="security_group_name=p26-dev-app" \
  -var="vpc_id=vpc-0123456789abcdef0"
```
