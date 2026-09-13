# Security Group

## 1. Visão geral

Este módulo Terraform cria um Security Group na AWS seguindo os padrões organizacionais de nomenclatura, tags e segurança.

O nome do recurso é composto automaticamente no formato `<ambiente>-<sistema>-sg-<finalidade>` (ex.: `hml-tcc-sg-web`), a partir das variáveis `environment`, `system` e `security_group_name`.

Regras de segurança aplicadas:

- o CIDR `0.0.0.0/0` só é aceito em regras de entrada ou saída na porta 443/tcp; qualquer outra combinação com esse CIDR falha na validação do Terraform;
- toda regra de entrada e de saída exige uma descrição não vazia;
- não há regras de egress liberadas por padrão — a lista `egress_rules` inicia vazia e deve ser declarada explicitamente pelo consumidor do módulo;
- as regras de entrada e saída são totalmente configuráveis via variáveis.

## 2. Variáveis

| Nome                  | Tipo                  | Obrigatória | Descrição                                                                                     |
|-----------------------|-----------------------|-------------|------------------------------------------------------------------------------------------------|
| `environment`         | `string`              | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                               |
| `system`              | `string`              | Sim         | Nome do sistema ou aplicação ao qual o recurso pertence.                                        |
| `region`              | `string`              | Não         | Região AWS onde os recursos serão criados. Padrão: `us-east-1`.                                |
| `additional_tags`     | `map(string)`         | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                               |
| `security_group_name` | `string`              | Sim         | Finalidade do Security Group, usada para compor o nome padronizado (ex.: `web`, `database`).    |
| `vpc_id`              | `string`              | Sim         | ID da VPC onde o Security Group será criado.                                                    |
| `ingress_rules`       | `list(object({...}))` | Não         | Regras de entrada (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). Padrão: `[]`. |
| `egress_rules`        | `list(object({...}))` | Não         | Regras de saída (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). Padrão: `[]`.   |

## 3. Outputs

| Nome                   | Descrição                        |
|------------------------|-----------------------------------|
| `security_group_name`  | Nome do Security Group criado.    |
| `security_group_arn`   | ARN do Security Group criado.     |
| `security_group_id`    | ID do Security Group criado.      |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  ingress_rules = [
    {
      description = "Acesso HTTPS público"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Acesso SSH restrito à rede corporativa"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saída HTTPS para atualizações e integrações externas"
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
