# Security Group

## Visao geral

Este modulo cria um Security Group na AWS, com o ID da VPC configuravel por variavel. As regras de entrada e de saida sao definidas integralmente por variaveis, sem liberacao irrestrita por padrao (nenhuma regra e criada quando as variaveis correspondentes nao sao informadas). Toda regra de entrada e de saida exige descricao obrigatoria, e o uso de `0.0.0.0/0` e proibido em qualquer porta que nao seja 443/tcp. O recurso segue o padrao de nomenclatura `<ambiente>-<sistema>-sg-<finalidade>` e aplica o conjunto de tags obrigatorias da organizacao.

## Variaveis

| Nome                          | Tipo                                                                                   | Obrigatoria | Descricao                                                                                   |
|-------------------------------|-----------------------------------------------------------------------------------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`                 | `string`                                                                                 | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                      | `string`                                                                                 | Sim         | Nome do sistema ao qual o recurso pertence.                                                   |
| `region`                      | `string`                                                                                 | Nao         | Regiao AWS onde os recursos serao criados. Padrao: `us-east-1`.                               |
| `additional_tags`             | `map(string)`                                                                            | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                 |
| `security_group_name`         | `string`                                                                                 | Sim         | Nome do Security Group, no padrao `<ambiente>-<sistema>-sg-<finalidade>`.                     |
| `security_group_description`  | `string`                                                                                 | Nao         | Descricao do Security Group. Padrao: `"Security Group gerenciado via Terraform."`.            |
| `vpc_id`                      | `string`                                                                                 | Sim         | ID da VPC onde o Security Group sera criado.                                                  |
| `ingress_rules`               | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`              | Nao         | Regras de entrada. `0.0.0.0/0` so e aceito na porta 443/tcp. Padrao: `[]`.                     |
| `egress_rules`                | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`              | Nao         | Regras de saida. `0.0.0.0/0` so e aceito na porta 443/tcp. Sem regras, nao ha saida liberada. Padrao: `[]`. |

## Outputs

| Nome                    | Descricao                                  |
|-------------------------|---------------------------------------------|
| `security_group_name`   | Nome do Security Group criado.               |
| `security_group_arn`    | ARN do Security Group criado.                |
| `security_group_id`     | ID do Security Group criado.                 |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "hml-tcc-sg-web"

  security_group_description = "Security Group da aplicacao web hml."

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
