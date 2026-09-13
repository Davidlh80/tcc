# Security Group — dev-tcc-sg-<finalidade>

## 1. Visão geral

Este módulo provisiona um Security Group na AWS seguindo os padrões internos de nomenclatura, tags e segurança da organização (contexto `tcc-iac-ia`).

Características principais:

- Nome do recurso segue o padrão `<ambiente>-<sistema>-sg-<finalidade>`, montado a partir das variáveis `environment`, `system` e `security_group_name`.
- O ID da VPC é configurável via variável `vpc_id`.
- Regras de entrada e saída são totalmente configuráveis via variáveis (`ingress_rules` e `egress_rules`), sem valores fixos no código.
- Toda regra de entrada e saída exige uma descrição não vazia (validada em `variables.tf`).
- O uso de `0.0.0.0/0` é proibido em qualquer porta diferente de `443/tcp`, tanto em regras de entrada quanto de saída.
- Egress não possui liberação irrestrita por padrão — nenhuma regra de saída é criada a menos que seja explicitamente declarada via variável.
- Tags obrigatórias (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`) são aplicadas automaticamente, podendo ser complementadas via `additional_tags`.

## 2. Variáveis

| Nome                   | Tipo                                                                                   | Obrigatória | Descrição                                                                                  |
|------------------------|-----------------------------------------------------------------------------------------|:-----------:|----------------------------------------------------------------------------------------------|
| `environment`          | `string`                                                                                 | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                              |
| `system`                | `string`                                                                                 | Sim         | Identificador do sistema ou aplicação ao qual o recurso pertence.                             |
| `region`                | `string`                                                                                 | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                         |
| `additional_tags`       | `map(string)`                                                                            | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                              |
| `security_group_name`   | `string`                                                                                 | Sim         | Finalidade do Security Group, usada para compor o nome padronizado (ex.: `web`, `database`).  |
| `vpc_id`                | `string`                                                                                 | Sim         | ID da VPC onde o Security Group será criado.                                                  |
| `description`           | `string`                                                                                 | Não         | Descrição do Security Group. Padrão: `"Security group gerenciado via Terraform."`.             |
| `ingress_rules`         | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`              | Não         | Regras de entrada. Cada regra exige descrição; `0.0.0.0/0` só é aceito na porta 443/tcp. Padrão: `[]`. |
| `egress_rules`          | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`              | Não         | Regras de saída. Cada regra exige descrição; `0.0.0.0/0` só é aceito na porta 443/tcp. Padrão: `[]`. |

## 3. Outputs

| Nome                   | Descrição                                    |
|------------------------|-----------------------------------------------|
| `security_group_name`  | Nome do Security Group criado.                |
| `security_group_arn`   | ARN do Security Group criado.                 |
| `security_group_id`    | ID do Security Group criado.                  |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "dev"
  system                = "tcc"
  region                = "us-east-1"
  vpc_id                = "vpc-0123456789abcdef0"
  security_group_name   = "web"
  description           = "Security group para a camada web da aplicação tcc"

  ingress_rules = [
    {
      description = "Acesso HTTPS público"
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      description = "Acesso SSH restrito à rede interna"
      from_port    = 22
      to_port      = 22
      protocol     = "tcp"
      cidr_blocks  = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saída HTTPS para atualizações e integrações externas"
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
