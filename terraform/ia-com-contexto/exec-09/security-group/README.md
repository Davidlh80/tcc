# Security Group

## 1. Visao geral

Este modulo Terraform provisiona um Security Group na AWS, com o ID da VPC configuravel por variavel. O recurso segue o padrao organizacional de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` e aplica, por padrao, as tags obrigatorias da organizacao.

Regras de seguranca aplicadas por este modulo:

- o CIDR `0.0.0.0/0` e proibido em qualquer porta diferente de `443/tcp`, tanto em ingress quanto em egress;
- toda regra de entrada e de saida exige uma descricao nao vazia;
- as regras de egress sao declaradas explicitamente por variavel; se `egress_rules` nao for informado, nenhuma regra de saida e criada (sem liberacao irrestrita por padrao);
- as regras de entrada e saida sao totalmente configuraveis por variavel.

## 2. Variaveis

| Nome                  | Tipo                                                                                     | Obrigatoria | Descricao                                                                                       |
|-----------------------|-------------------------------------------------------------------------------------------|-------------|---------------------------------------------------------------------------------------------------|
| `environment`         | `string`                                                                                   | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                  |
| `system`              | `string`                                                                                   | Sim         | Nome do sistema ou aplicacao ao qual o recurso pertence.                                          |
| `region`              | `string`                                                                                   | Nao         | Regiao AWS onde o recurso sera criado. Padrao: `us-east-1`.                                       |
| `additional_tags`     | `map(string)`                                                                              | Nao         | Tags adicionais alem das obrigatorias. Padrao: `{}`.                                               |
| `security_group_name` | `string`                                                                                   | Sim         | Finalidade do Security Group, usada na composicao do nome padronizado.                            |
| `vpc_id`              | `string`                                                                                   | Sim         | ID da VPC onde o Security Group sera criado.                                                      |
| `description`         | `string`                                                                                   | Nao         | Descricao do Security Group. Padrao: `"Security Group gerenciado via Terraform."`.                |
| `ingress_rules`       | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`                | Nao         | Regras de entrada. `0.0.0.0/0` so e permitido em `443/tcp`. Padrao: `[]`.                          |
| `egress_rules`        | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`                | Nao         | Regras de saida. `0.0.0.0/0` so e permitido em `443/tcp`. Padrao: `[]` (sem saida liberada).       |

## 3. Outputs

| Nome                   | Descricao                              |
|------------------------|------------------------------------------|
| `security_group_name`  | Nome padronizado do Security Group.       |
| `security_group_arn`   | ARN do Security Group.                    |
| `security_group_id`    | ID do Security Group.                     |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Acesso HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Saida HTTPS para atualizacoes de pacotes"
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
