# Security Group — Blueprint Terraform

Blueprint Terraform para provisionamento de um Security Group na AWS, com regras de entrada e saída explícitas e configuráveis via variáveis.

## Recursos criados

- `aws_security_group.this`: Security Group associado a uma VPC existente (informada via `var.vpc_id`).

## Comportamento padrão

- **Entrada (ingress):** nenhuma regra é criada por padrão (`ingress_rules = []`). É necessário declarar explicitamente as regras de entrada necessárias, evitando exposição irrestrita (`0.0.0.0/0`) desnecessária.
- **Saída (egress):** por padrão permite todo o tráfego de saída (`0.0.0.0/0`, todas as portas/protocolos), comportamento comum para a maioria das cargas de trabalho. Pode ser restringido via `var.egress_rules`.

## Variáveis principais

| Nome | Descrição | Padrão |
|---|---|---|
| `region` | Região AWS | `us-east-1` |
| `vpc_id` | ID da VPC onde o Security Group será criado (obrigatório) | — |
| `name` | Nome do Security Group | `sg-managed-by-terraform` |
| `description` | Descrição do Security Group | `Security Group gerenciado via Terraform.` |
| `ingress_rules` | Lista de regras de entrada explícitas | `[]` |
| `egress_rules` | Lista de regras de saída explícitas | permite todo tráfego de saída |
| `tags` | Tags adicionais | `{}` |

## Exemplo de uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-app-web"

  ingress_rules = [
    {
      description = "Permite HTTPS de uma origem confiável"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]

  tags = {
    Environment = "test"
    Owner       = "equipe-infra"
  }
}
```

## Outputs

| Nome | Descrição |
|---|---|
| `security_group_id` | ID do Security Group criado |
| `security_group_arn` | ARN do Security Group criado |
| `security_group_name` | Nome do Security Group criado |
| `security_group_vpc_id` | ID da VPC associada ao Security Group |

## Validação

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

## Observações de segurança

- Evite usar `0.0.0.0/0` em regras de entrada; prefira CIDRs específicos ou security groups de origem.
- Revise periodicamente `ingress_rules` e `egress_rules` para garantir que apenas o tráfego estritamente necessário esteja liberado.
- Não utilize a VPC padrão da conta; sempre informe o `vpc_id` de uma VPC dedicada ao ambiente.
