# Security Group

## Visão geral

Este template provisiona um Security Group na AWS, com o ID da VPC configurável por variável. As regras de entrada e de saída são totalmente configuráveis por variável e nenhuma regra de egress é criada por padrão, garantindo que não haja liberação irrestrita de tráfego. Toda regra de entrada ou saída exige descrição obrigatória e o CIDR `0.0.0.0/0` só é permitido na porta 443/tcp, em conformidade com o padrão organizacional de segurança. O nome do recurso segue o padrão `<ambiente>-<sistema>-sg-<finalidade>` e as tags obrigatórias da organização são aplicadas automaticamente.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
|---|---|---|---|
| `environment` | `string` | Sim | Ambiente de implantação (`dev`, `hml` ou `prd`). |
| `system` | `string` | Sim | Nome do sistema/aplicação, usado na composição do nome padronizado. |
| `region` | `string` | Não (default: `us-east-1`) | Região AWS onde os recursos serão provisionados. |
| `additional_tags` | `map(string)` | Não (default: `{}`) | Tags adicionais mescladas às tags obrigatórias da organização. |
| `security_group_name` | `string` | Sim | Finalidade do Security Group, usada na composição do nome padronizado. |
| `security_group_description` | `string` | Não (default: `"Security Group gerenciado via Terraform."`) | Descrição do Security Group. |
| `vpc_id` | `string` | Sim | ID da VPC onde o Security Group será criado. |
| `ingress_rules` | `list(object)` | Não (default: `[]`) | Regras de entrada. Cada regra exige `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. `0.0.0.0/0` só é permitido na porta 443/tcp. |
| `egress_rules` | `list(object)` | Não (default: `[]`) | Regras de saída. Cada regra exige `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. `0.0.0.0/0` só é permitido na porta 443/tcp. Sem regras por padrão. |

## Outputs

| Nome | Descrição |
|---|---|
| `security_group_name` | Nome do Security Group criado. |
| `security_group_arn` | ARN do Security Group criado. |
| `security_group_id` | ID do Security Group criado. |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
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
    },
    {
      description = "Acesso SSH restrito à rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saída HTTPS para atualizações e integrações"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```
