# Security Group

## 1. Visao geral

Este template cria um Security Group na AWS, associado a uma VPC informada por variavel, seguindo os padroes organizacionais de nomenclatura, tags e seguranca definidos para o projeto `tcc-iac-ia`.

O nome do recurso e composto automaticamente no padrao `<ambiente>-<sistema>-sg-<finalidade>` (ex.: `dev-tcc-sg-web`).

Controles de seguranca aplicados por padrao:

- o CIDR `0.0.0.0/0` so e aceito em regras de entrada ou saida que liberem exclusivamente a porta `443/tcp`;
- toda regra de entrada e de saida exige uma descricao nao vazia;
- as regras de saida sao declaradas explicitamente, sem liberacao irrestrita por padrao (o padrao do modulo libera apenas saida HTTPS na porta 443/tcp);
- regras de entrada e saida sao totalmente configuraveis via variaveis.

## 2. Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|------|------|-------------|-----------|
| `environment` | `string` | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| `system` | `string` | Sim | Nome curto do sistema/produto, usado na composicao do nome padronizado. |
| `region` | `string` | Sim | Regiao AWS onde o Security Group sera criado. |
| `additional_tags` | `map(string)` | Nao | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`. |
| `vpc_id` | `string` | Sim | ID da VPC onde o Security Group sera criado. |
| `security_group_name` | `string` | Sim | Finalidade do Security Group, usada na composicao do nome padronizado (ex.: `web`, `database`, `bastion`). |
| `security_group_description` | `string` | Nao | Descricao do Security Group. Padrao: `"Security Group gerenciado via Terraform."`. |
| `ingress_rules` | `list(object({ description=string, from_port=number, to_port=number, protocol=string, cidr_blocks=list(string) }))` | Nao | Lista de regras de entrada. Padrao: `[]`. |
| `egress_rules` | `list(object({ description=string, from_port=number, to_port=number, protocol=string, cidr_blocks=list(string) }))` | Nao | Lista de regras de saida. Padrao: uma regra liberando saida HTTPS (443/tcp) para `0.0.0.0/0`. |

## 3. Outputs

| Nome | Descricao |
|------|-----------|
| `security_group_name` | Nome padronizado do Security Group. |
| `security_group_arn` | ARN do Security Group. |
| `security_group_id` | ID do Security Group. |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "dev"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"

  additional_tags = {
    Squad = "platform"
  }

  ingress_rules = [
    {
      description = "Permite acesso HTTPS publico."
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite acesso SSH somente da rede corporativa."
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  egress_rules = [
    {
      description = "Permite trafego de saida HTTPS para a internet."
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```
