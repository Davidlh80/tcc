# Template Security Group

## Visão geral

Cria um Security Group em uma VPC informada por variável, com regras explícitas:

- uma regra de entrada TCP para cada porta de `allowed_ports`, restrita às faixas de `allowed_cidrs` (gerada com bloco `dynamic`);
- validação que impede liberar `0.0.0.0/0` na entrada;
- uma única regra de saída HTTPS (443/tcp) para as faixas de `egress_cidrs` (padrão `10.0.0.0/8`), sem liberação irrestrita;
- descrição em todas as regras;
- tags padrão (`Project`, `Environment`, `ManagedBy`), que podem ser complementadas por `additional_tags`.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
| --- | --- | --- | --- |
| `security_group_name` | `string` | Sim | Nome do Security Group (não pode começar com `sg-`) |
| `vpc_id` | `string` | Sim | ID da VPC onde o Security Group será criado |
| `allowed_ports` | `list(number)` | Sim | Lista de portas TCP liberadas na entrada |
| `allowed_cidrs` | `list(string)` | Sim | Lista de faixas de IP (CIDR) autorizadas na entrada (não pode conter `0.0.0.0/0`) |
| `egress_cidrs` | `list(string)` | Não (padrão: `["10.0.0.0/8"]`) | Faixas de IP (CIDR) de destino liberadas na saída |
| `environment` | `string` | Não (padrão: `"dev"`) | Ambiente de implantação (`dev`, `hml` ou `prd`) |
| `additional_tags` | `map(string)` | Não (padrão: `{}`) | Tags extras aplicadas a todos os recursos |
| `region` | `string` | Não (padrão: `"us-east-1"`) | Região AWS onde os recursos serão criados |

## Outputs

| Nome | Descrição |
| --- | --- |
| `security_group_name` | Nome do Security Group |
| `security_group_arn` | ARN do Security Group |
| `security_group_id` | ID do Security Group |

## Exemplo de uso

```hcl
module "security_group" {
  source = "./terraform/manual/p14/security-group"

  environment         = "dev"
  security_group_name = "dev-tcc-sg-web"
  vpc_id              = "vpc-0123456789abcdef0"
  allowed_ports       = [443]
  allowed_cidrs       = ["10.0.0.0/8"]
}
```

Para validar direto na pasta do template:

```bash
terraform init
terraform validate
```
