# Security Group

## Visao geral

Este modulo Terraform provisiona um Security Group na AWS, com o ID da VPC configuravel por variavel. O modulo segue o padrao de nomenclatura organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex: `dev-tcc-sg-web`) e aplica as tags obrigatorias da organizacao a todos os recursos.

Por padrao, o Security Group nao possui regras de entrada (principio do menor privilegio) e possui apenas uma regra de saida explicita liberando HTTPS (443/tcp). Regras adicionais de entrada e saida sao configuraveis por variavel, sendo obrigatoria a descricao em toda regra e proibido o uso de `0.0.0.0/0` em qualquer porta diferente de 443/tcp.

## Variaveis

| Nome                          | Tipo                  | Obrigatoria | Descricao                                                                                     |
|-------------------------------|-----------------------|-------------|------------------------------------------------------------------------------------------------|
| `environment`                 | `string`               | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                |
| `system`                      | `string`               | Sim         | Identificador do sistema/produto, usado na nomenclatura padrao.                                |
| `region`                      | `string`               | Nao         | Regiao AWS onde o recurso sera criado. Padrao: `us-east-1`.                                    |
| `additional_tags`             | `map(string)`          | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |
| `vpc_id`                      | `string`               | Sim         | ID da VPC onde o Security Group sera criado.                                                    |
| `security_group_name`         | `string`               | Sim         | Finalidade do Security Group, usada como sufixo na nomenclatura padrao (ex: `web`).             |
| `security_group_description`  | `string`               | Nao         | Descricao do Security Group. Padrao: `"Security group gerenciado via Terraform."`.              |
| `ingress_rules`                | `list(object)`         | Nao         | Lista de regras de entrada (description, from_port, to_port, protocol, cidr_blocks). Padrao: `[]`. |
| `egress_rules`                 | `list(object)`         | Nao         | Lista de regras de saida (description, from_port, to_port, protocol, cidr_blocks). Padrao: regra HTTPS (443/tcp). |

## Outputs

| Nome                    | Descricao                                 |
|-------------------------|--------------------------------------------|
| `security_group_name`   | Nome do Security Group criado.             |
| `security_group_arn`    | ARN do Security Group criado.              |
| `security_group_id`     | ID do Security Group criado.               |

## Exemplo de uso

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
      description = "Permite acesso HTTPS de qualquer origem"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Permite acesso SSH somente da rede corporativa"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
