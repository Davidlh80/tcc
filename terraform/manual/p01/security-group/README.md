# Security Group - p01

Cria um Security Group com regras de entrada e saida explicitas. As regras de
entrada sao geradas a partir das portas e dos CIDRs informados, e a saida libera
somente HTTPS para os CIDRs configurados. SSH, RDP e `0.0.0.0/0` nao sao
permitidos por padrao.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
| --- | --- | --- | --- |
| `security_group_name` | `string` | sim | Nome do Security Group. |
| `vpc_id` | `string` | sim | ID da VPC onde o Security Group sera criado. |
| `environment` | `string` | sim | Ambiente do recurso: `dev` ou `prd`. |
| `allowed_ports` | `list(number)` | sim | Portas TCP liberadas na entrada. |
| `allowed_cidrs` | `list(string)` | sim | CIDRs IPv4 de origem liberados na entrada. |
| `egress_cidrs` | `list(string)` | nao | CIDRs de destino liberados na saida em HTTPS. Padrao: `["10.0.0.0/8"]`. |
| `additional_tags` | `map(string)` | nao | Tags adicionais aplicadas ao Security Group. |

## Outputs

| Nome | Descricao |
| --- | --- |
| `security_group_id` | ID do Security Group criado. |
| `security_group_arn` | ARN do Security Group criado. |
| `security_group_name` | Nome do Security Group criado. |

## Uso

```hcl
security_group_name = "dev-tcc-sg-web"
vpc_id              = "vpc-0123456789abcdef0"
environment         = "dev"
allowed_ports       = [443]
allowed_cidrs       = ["10.0.0.0/16"]
egress_cidrs        = ["10.0.0.0/8"]
additional_tags     = { Project = "tcc" }
```

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```
