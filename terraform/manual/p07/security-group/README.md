# Security Group

Cria um Security Group em uma VPC existente. A entrada e liberada somente nas portas TCP e CIDRs informados, e a saida fica restrita a uma porta (443 por padrao) para os CIDRs de `egress_cidrs`.

## Variaveis

| Nome | Tipo | Padrao | Descricao |
| --- | --- | --- | --- |
| `security_group_name` | string | - | Nome do Security Group |
| `vpc_id` | string | - | ID da VPC |
| `environment` | string | - | dev, hml ou prd |
| `allowed_ports` | list(number) | - | Portas TCP de entrada |
| `allowed_cidrs` | list(string) | - | CIDRs de origem (nao aceita `0.0.0.0/0`) |
| `egress_port` | number | `443` | Porta TCP de saida |
| `egress_cidrs` | list(string) | `["10.0.0.0/8"]` | CIDRs de destino |
| `additional_tags` | map(string) | `{}` | Tags extras |
| `region` | string | `us-east-1` | Regiao AWS |

## Outputs

`security_group_id`, `security_group_arn` e `security_group_name`.

## Uso

```hcl
security_group_name = "app-web-dev"
vpc_id              = "vpc-0123456789abcdef0"
environment         = "dev"
allowed_ports       = [443]
allowed_cidrs       = ["10.0.0.0/16"]
```

```sh
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```
