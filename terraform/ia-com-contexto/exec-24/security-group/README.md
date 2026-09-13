# Security Group

## 1. Visao geral

Este modulo Terraform provisiona um Security Group na AWS seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O recurso segue o principio do menor privilegio: nenhuma regra de entrada ou saida e criada por padrao, o uso de `0.0.0.0/0` e proibido em qualquer porta diferente de 443/tcp, e toda regra de entrada ou saida exige uma descricao obrigatoria.

O nome do Security Group e gerado automaticamente seguindo o padrao `<ambiente>-<sistema>-sg-<finalidade>`, por exemplo `hml-tcc-sg-web`.

## 2. Variaveis

| Nome                  | Tipo                  | Obrigatoria | Descricao                                                                                     |
|-----------------------|-----------------------|-------------|------------------------------------------------------------------------------------------------|
| `environment`         | `string`               | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`              | `string`               | Sim         | Nome do sistema ou aplicacao ao qual o recurso pertence.                                       |
| `region`              | `string`               | Nao         | Regiao AWS onde o recurso sera provisionado. Padrao: `us-east-1`.                              |
| `additional_tags`     | `map(string)`          | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.               |
| `security_group_name` | `string`               | Sim         | Finalidade do Security Group, usada como sufixo no padrao de nomenclatura.                     |
| `vpc_id`              | `string`               | Sim         | ID da VPC onde o Security Group sera criado.                                                   |
| `ingress_rules`       | `list(object({...}))`  | Nao         | Lista de regras de entrada. Cada regra exige `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. Padrao: `[]`. |
| `egress_rules`        | `list(object({...}))`  | Nao         | Lista de regras de saida. Cada regra exige `description`, `from_port`, `to_port`, `protocol` e `cidr_blocks`. Padrao: `[]`.   |

## 3. Outputs

| Nome                   | Descricao                              |
|------------------------|-----------------------------------------|
| `security_group_name`  | Nome do Security Group criado.          |
| `security_group_arn`   | ARN do Security Group criado.           |
| `security_group_id`    | ID do Security Group criado.            |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Permite HTTPS publico"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Permite acesso HTTPS a servicos externos"
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
