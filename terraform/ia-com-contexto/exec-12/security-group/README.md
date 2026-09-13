# Security Group

## Visão geral do recurso

Este template provisiona um Security Group na AWS, com o ID da VPC configurável por variável. O recurso segue o padrão de nomenclatura organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `hml-tcc-sg-web`) e aplica o conjunto de tags obrigatórias da organização.

Por padrão, o Security Group não possui regras de entrada (least privilege) e uma única regra de saída explícita permitindo tráfego HTTPS (443/tcp). Todas as regras de entrada e saída são configuráveis por variável, mas estão sujeitas às seguintes restrições de segurança:

- `0.0.0.0/0` é proibido em qualquer porta além da 443/tcp;
- toda regra de entrada e de saída deve conter uma descrição não vazia;
- não há liberação irrestrita de egress por padrão.

## Variáveis

| Nome                   | Tipo                  | Obrigatória | Descrição                                                                                   |
|------------------------|-----------------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`          | `string`              | Sim         | Ambiente de implantação do recurso (`dev`, `hml` ou `prd`).                                  |
| `system`               | `string`              | Sim         | Nome do sistema/aplicação ao qual o recurso pertence.                                        |
| `region`               | `string`              | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                        |
| `additional_tags`      | `map(string)`         | Não         | Tags adicionais mescladas com as tags obrigatórias da organização. Padrão: `{}`.              |
| `security_group_name`  | `string`              | Sim         | Finalidade do Security Group, usada para compor o nome padronizado (ex.: `web`, `database`). |
| `vpc_id`               | `string`              | Sim         | ID da VPC onde o Security Group será criado.                                                 |
| `description`          | `string`              | Não         | Descrição do Security Group. Padrão: `"Security Group gerenciado via Terraform"`.             |
| `ingress_rules`        | `list(object({...}))` | Não         | Lista de regras de entrada. `0.0.0.0/0` só é permitido na porta 443/tcp. Padrão: `[]`.        |
| `egress_rules`         | `list(object({...}))` | Não         | Lista de regras de saída. `0.0.0.0/0` só é permitido na porta 443/tcp. Padrão: HTTPS (443/tcp) liberado. |

Cada elemento de `ingress_rules` e `egress_rules` deve seguir a estrutura:

```text
{
  description = string
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks = list(string)
}
```

## Outputs

| Nome                   | Descrição                              |
|------------------------|------------------------------------------|
| `security_group_id`    | ID do Security Group criado.             |
| `security_group_arn`   | ARN do Security Group criado.            |
| `security_group_name`  | Nome do Security Group criado.           |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"
  description          = "Security Group para a camada web"

  ingress_rules = [
    {
      description = "Permite HTTPS de entrada"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite SSH somente da rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite tráfego HTTPS de saída"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
