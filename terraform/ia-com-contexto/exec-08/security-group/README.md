# Security Group

## 1. Visao geral do recurso

Este template provisiona um Security Group AWS em uma VPC existente, seguindo os padroes organizacionais de nomenclatura, tags e seguranca definidos pela organizacao.

Caracteristicas principais:

- Nome do recurso composto no padrao `<ambiente>-<sistema>-sg-<finalidade>`.
- ID da VPC configuravel por variavel.
- Regras de entrada e saida totalmente configuraveis por variavel, sem valores fixos no codigo.
- Toda regra de entrada e de saida exige descricao obrigatoria.
- O CIDR `0.0.0.0/0` e permitido exclusivamente na porta 443/tcp, tanto em ingress quanto em egress.
- Egress declarado de forma explicita: nenhuma liberacao irrestrita e criada por padrao (lista padrao vazia).
- Tags obrigatorias da organizacao aplicadas automaticamente, com suporte a tags adicionais.

## 2. Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|------|------|-------------|-----------|
| `environment` | `string` | Sim | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`). |
| `system` | `string` | Sim | Nome do sistema ou aplicacao associado ao recurso. |
| `region` | `string` | Sim | Regiao AWS onde o recurso sera criado. |
| `additional_tags` | `map(string)` | Nao | Tags adicionais a serem mescladas as tags obrigatorias. Padrao: `{}`. |
| `security_group_name` | `string` | Sim | Finalidade do Security Group, usada para compor o nome padronizado (ex.: `web`, `database`). |
| `security_group_description` | `string` | Nao | Descricao do Security Group. Padrao: `"Security group gerenciado via Terraform"`. |
| `vpc_id` | `string` | Sim | ID da VPC onde o Security Group sera criado. |
| `ingress_rules` | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))` | Nao | Lista de regras de entrada. Padrao: `[]`. |
| `egress_rules` | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))` | Nao | Lista de regras de saida. Padrao: `[]`. |

## 3. Outputs

| Nome | Descricao |
|------|-----------|
| `security_group_name` | Nome do Security Group criado. |
| `security_group_arn` | ARN do Security Group criado. |
| `security_group_id` | ID do Security Group criado. |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  additional_tags = {
    Team = "plataforma"
  }

  ingress_rules = [
    {
      description = "Acesso HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Acesso SSH restrito a rede interna"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS para atualizacoes e integracoes externas"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```
