# Security Group (AWS) — Terraform

Blueprint Terraform para provisionar um Security Group na AWS dentro de uma VPC existente, com regras de entrada e saída explícitas.

## Recursos criados

- `aws_security_group.this`: Security Group associado à VPC informada em `var.vpc_id`, com regras de ingress/egress definidas via listas de objetos e tags configuráveis.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS `~> 5.0`
- Uma VPC previamente criada (não a VPC padrão da conta), cujo ID deve ser informado em `var.vpc_id`.

## Variáveis principais

| Nome            | Descrição                                               | Padrão                          |
| --------------- | -------------------------------------------------------- | -------------------------------- |
| `region`        | Região AWS                                                | `us-east-1`                      |
| `vpc_id`        | ID da VPC onde o Security Group será criado (obrigatório) | —                                 |
| `name`          | Nome do Security Group                                    | `app-sg`                         |
| `description`   | Descrição do Security Group                               | `Security group gerenciado via Terraform` |
| `ingress_rules` | Lista de regras de entrada explícitas                     | Regra HTTPS liberada apenas para `10.0.0.0/16` |
| `egress_rules`  | Lista de regras de saída explícitas                       | Libera todo o tráfego de saída   |
| `tags`          | Tags adicionais                                           | `{}`                              |

## Uso

```
module "security_group" {
  source = "./"

  vpc_id = "vpc-xxxxxxxx"
  name   = "meu-security-group"

  ingress_rules = [
    {
      description = "Permite HTTPS de uma rede corporativa"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]
    }
  ]

  tags = {
    Environment = "dev"
  }
}
```

## Outputs

- `security_group_id`: ID do Security Group.
- `security_group_arn`: ARN do Security Group.
- `security_group_name`: Nome do Security Group.
- `vpc_id`: ID da VPC associada.

## Boas práticas aplicadas

- Nenhuma regra de entrada é aberta para `0.0.0.0/0` por padrão; a regra de exemplo restringe a origem a um bloco CIDR específico.
- Regras de entrada e saída são declaradas de forma explícita via variáveis, evitando acesso irrestrito não intencional.
- O `vpc_id` é obrigatório e configurável, não dependendo da VPC padrão da conta.
- Tags são aplicadas de forma consistente, incluindo `Name` e tags adicionais fornecidas pelo usuário.

## Validação

```
terraform init -backend=false
terraform validate
terraform fmt -check
```
