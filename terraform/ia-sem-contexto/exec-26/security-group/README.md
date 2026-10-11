# Security Group — Blueprint Terraform

Blueprint Terraform para provisionamento de um AWS Security Group com regras explicitas de entrada e saida, sem abertura irrestrita desnecessaria.

## Recursos criados

- `aws_security_group.this`: Security Group associado a uma VPC existente (informada via variavel).

## Caracteristicas de seguranca

- Nenhuma regra de ingress e criada por padrao (`ingress_rules = []`).
- E proibido o uso de `0.0.0.0/0` em CIDRs de ingress (validado via bloco `validation`).
- A regra de egress padrao libera apenas trafego HTTPS (porta 443) para a internet.
- Todas as regras de entrada e saida sao declaradas explicitamente via variaveis, sem uso de `-1`/"all" para portas ou protocolos.
- `vpc_id` e validado quanto ao formato esperado (`vpc-xxxxxxxx`).

## Variaveis principais

| Nome            | Descricao                                                        | Default               |
|-----------------|-------------------------------------------------------------------|------------------------|
| `vpc_id`        | ID da VPC onde o Security Group sera criado                      | obrigatorio            |
| `name`          | Nome do Security Group                                            | `sg-custom`            |
| `description`   | Descricao do Security Group                                       | texto padrao           |
| `ingress_rules` | Lista de regras de entrada (description, portas, protocolo, CIDRs)| `[]`                   |
| `egress_rules`  | Lista de regras de saida (description, portas, protocolo, CIDRs)  | HTTPS para `0.0.0.0/0` |
| `tags`          | Tags adicionais a serem aplicadas                                 | `{}`                   |
| `region`        | Regiao AWS do provider                                            | `us-east-1`            |

## Outputs

| Nome                  | Descricao                              |
|-----------------------|------------------------------------------|
| `security_group_id`   | ID do Security Group criado              |
| `security_group_arn`  | ARN do Security Group criado             |
| `security_group_name` | Nome do Security Group criado            |
| `vpc_id`              | ID da VPC associada ao Security Group    |

## Exemplo de uso

```hcl
module "security_group" {
  source = "./"

  vpc_id = "vpc-0123456789abcdef0"
  name   = "sg-app"

  ingress_rules = [
    {
      description = "Permite acesso HTTPS interno"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "test"
  }
}
```

## Validacao

```bash
terraform fmt
terraform init -backend=false
terraform validate
```
