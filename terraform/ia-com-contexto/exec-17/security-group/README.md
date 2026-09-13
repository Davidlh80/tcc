# Security Group — dev-tcc-sg-web

## Visão geral

Este módulo provisiona um Security Group AWS seguindo os padrões organizacionais de nomenclatura, tags e segurança. O recurso é criado a partir de um `vpc_id` informado por variável e não define nenhuma regra de entrada ou saída por padrão — todas as regras de ingress e egress devem ser declaradas explicitamente pelo consumidor do módulo, cada uma com descrição obrigatória.

Regras de segurança aplicadas por padrão:

- o CIDR `0.0.0.0/0` só é aceito em regras (ingress ou egress) restritas à porta 443/tcp;
- toda regra de entrada e de saída exige o campo `description` preenchido;
- não há egress irrestrito por padrão — a lista `egress_rules` inicia vazia e deve ser preenchida explicitamente;
- o nome do recurso segue o padrão `<ambiente>-<sistema>-sg-<finalidade>`;
- as tags obrigatórias da organização são aplicadas automaticamente.

## Variáveis

| Nome                          | Tipo                  | Obrigatória | Descrição                                                                                     |
|-------------------------------|-----------------------|:-----------:|------------------------------------------------------------------------------------------------|
| `environment`                 | `string`              | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                               |
| `system`                      | `string`              | Sim         | Nome do sistema ou aplicação ao qual o Security Group pertence.                                |
| `region`                      | `string`              | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                          |
| `additional_tags`             | `map(string)`         | Não         | Tags adicionais mescladas às tags obrigatórias da organização. Padrão: `{}`.                    |
| `security_group_name`         | `string`              | Sim         | Finalidade do Security Group, usada para compor o nome padronizado.                            |
| `security_group_description`  | `string`              | Não         | Descrição do Security Group. Padrão: `"Managed by Terraform."`.                                |
| `vpc_id`                      | `string`              | Sim         | ID da VPC onde o Security Group será criado.                                                   |
| `ingress_rules`               | `list(object({...}))` | Não         | Regras de entrada (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). Padrão: `[]`. |
| `egress_rules`                | `list(object({...}))` | Não         | Regras de saída (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). Padrão: `[]`.  |

## Outputs

| Nome                    | Descrição                             |
|-------------------------|----------------------------------------|
| `security_group_name`   | Nome do Security Group criado.         |
| `security_group_arn`    | ARN do Security Group criado.          |
| `security_group_id`     | ID do Security Group criado.           |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "dev"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  additional_tags = {
    Squad = "plataforma"
  }

  ingress_rules = [
    {
      description = "Acesso HTTPS público"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Acesso HTTPS de saída para atualizações"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```
