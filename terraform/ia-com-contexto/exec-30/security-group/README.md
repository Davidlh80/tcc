# Security Group

## 1. Visão geral

Este módulo provisiona um Security Group na AWS, associado a uma VPC informada por variável, seguindo o padrão de nomenclatura `<ambiente>-<sistema>-sg-<finalidade>` e as tags obrigatórias da organização.

Restrições de segurança aplicadas por padrão:

- `0.0.0.0/0` é proibido em qualquer regra de entrada ou saída, exceto na porta 443/tcp;
- toda regra de ingress e egress exige uma descrição não vazia;
- as regras de egress são declaradas explicitamente, sem liberação irrestrita padrão;
- regras de entrada e saída são totalmente configuráveis via variáveis.

## 2. Variáveis

| Nome | Tipo | Obrigatória | Descrição |
|------|------|-------------|-----------|
| `environment` | `string` | Sim | Ambiente de implantação (`dev`, `hml` ou `prd`). |
| `system` | `string` | Sim | Nome do sistema ou aplicação ao qual o recurso pertence. |
| `region` | `string` | Não | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`. |
| `additional_tags` | `map(string)` | Não | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`. |
| `security_group_name` | `string` | Sim | Finalidade do Security Group, usada na composição do nome padronizado (ex.: `web`, `db`). |
| `security_group_description` | `string` | Não | Descrição do Security Group. Padrão: `"Security Group gerenciado via Terraform."`. |
| `vpc_id` | `string` | Sim | ID da VPC onde o Security Group será criado. |
| `ingress_rules` | `list(object)` | Não | Lista de regras de entrada (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). `0.0.0.0/0` só é permitido na porta 443/tcp. |
| `egress_rules` | `list(object)` | Não | Lista de regras de saída (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). Deve conter ao menos uma regra; `0.0.0.0/0` só é permitido na porta 443/tcp. |

## 3. Outputs

| Nome | Descrição |
|------|-----------|
| `security_group_name` | Nome do Security Group criado. |
| `security_group_arn` | ARN do Security Group criado. |
| `security_group_id` | ID do Security Group criado. |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "dev"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  ingress_rules = [
    {
      description = "Permite trafego HTTPS de entrada a partir de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite SSH de entrada apenas da rede corporativa"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite trafego HTTPS de saida para qualquer destino"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Purpose = "web-frontend"
  }
}
```
