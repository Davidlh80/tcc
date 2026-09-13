# dev-tcc-sg-web

## Visão geral

Este template Terraform provisiona um Security Group na AWS seguindo os padrões organizacionais de nomenclatura, tags e segurança.

O Security Group é associado a uma VPC informada via variável e não possui regras de entrada ou saída por padrão — todas as regras devem ser declaradas explicitamente pelo consumidor do módulo.

Restrições de segurança aplicadas:

- o CIDR `0.0.0.0/0` é permitido apenas em regras (entrada ou saída) na porta `443/tcp`; qualquer outra combinação é bloqueada por validação em tempo de plano;
- toda regra de entrada e de saída deve conter uma descrição não vazia;
- não há liberação irrestrita de egress por padrão — a lista de regras de saída inicia vazia e deve ser definida explicitamente;
- o nome do recurso segue o padrão `<ambiente>-<sistema>-sg-<finalidade>`;
- todos os recursos recebem o conjunto obrigatório de tags da organização.

## Variáveis

| Nome                   | Tipo                        | Obrigatória | Descrição                                                                                     |
|------------------------|-----------------------------|:-----------:|------------------------------------------------------------------------------------------------|
| `environment`          | `string`                    | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                               |
| `system`                | `string`                    | Sim         | Nome do sistema ou aplicação ao qual o recurso pertence.                                        |
| `region`                | `string`                    | Não         | Região AWS onde os recursos serão provisionados. Padrão: `us-east-1`.                          |
| `additional_tags`       | `map(string)`               | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                               |
| `security_group_name`   | `string`                    | Sim         | Finalidade do Security Group, usada na composição do nome padronizado.                         |
| `vpc_id`                | `string`                    | Sim         | ID da VPC onde o Security Group será criado.                                                    |
| `ingress_rules`         | `list(object({...}))`       | Não         | Lista de regras de entrada (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). Padrão: `[]`. |
| `egress_rules`          | `list(object({...}))`       | Não         | Lista de regras de saída (`description`, `from_port`, `to_port`, `protocol`, `cidr_blocks`). Padrão: `[]`.   |

## Outputs

| Nome                   | Descrição                              |
|------------------------|-----------------------------------------|
| `security_group_name`  | Nome do Security Group criado.          |
| `security_group_arn`   | ARN do Security Group criado.           |
| `security_group_id`    | ID do Security Group criado.            |

## Exemplo de uso

```hcl
module "sg_web" {
  source = "./"

  environment          = "dev"
  system               = "tcc"
  region               = "us-east-1"
  security_group_name  = "web"
  vpc_id               = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      description = "Acesso HTTPS público"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
