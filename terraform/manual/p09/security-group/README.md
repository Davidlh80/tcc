# Security Group

Cria um Security Group em uma VPC informada, liberando entrada TCP apenas nas portas e CIDRs configurados. Cada porta vira uma regra de entrada separada.

Como estamos fazendo a criação de um template, a saída fica liberada para qualquer destino, mantendo o comportamento padrão da AWS, aberto a modificações para o contexto de uso.

## Variaveis

| Nome | Tipo | Padrao | Descricao |
| --- | --- | --- | --- |
| `name` | string | - | Nome do Security Group |
| `vpc_id` | string | - | ID da VPC |
| `environment` | string | - | dev, hml ou prd |
| `owner` | string | - | E-mail do responsavel pelo recurso |
| `allowed_ports` | list(number) | - | Portas TCP liberadas na entrada |
| `allowed_cidrs` | list(string) | - | CIDRs liberados na entrada |
| `region` | string | `us-east-1` | Regiao AWS |

## Outputs

`ID`, `arn` e `resource_name`.

## Uso

```hcl
name          = "app-web-dev"
vpc_id        = "vpc-0123456789abcdef0"
environment   = "dev"
owner         = "time-plataforma@empresa.com"
allowed_ports = [443]
allowed_cidrs = ["10.0.0.0/16"]
```

```sh
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
```
