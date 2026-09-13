# Security Group

## 1. Visão geral

Este módulo provisiona um Security Group na AWS, associado a uma VPC informada via variável, seguindo os padrões organizacionais de nomenclatura, tags e segurança.

Regras de segurança aplicadas por padrão:

- o nome do recurso segue o padrão `<ambiente>-<sistema>-sg-<finalidade>`;
- nenhuma regra de entrada ou de saída é criada por padrão — todas devem ser declaradas explicitamente pelo consumidor via variável;
- `0.0.0.0/0` é proibido em qualquer regra de entrada ou saída, exceto na porta 443/tcp;
- toda regra de entrada e de saída deve conter uma descrição não vazia;
- todas as tags obrigatórias da organização são aplicadas automaticamente.

## 2. Variáveis

| Nome                   | Tipo                                                                                                   | Obrigatória | Descrição                                                                                          |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|------------------------------------------------------------------------------------------------------------|
| `environment`           | `string`                                                                                                | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                   |
| `system`                | `string`                                                                                                | Sim         | Nome do sistema ao qual o recurso pertence.                                                        |
| `region`                | `string`                                                                                                | Não         | Região AWS onde o recurso será provisionado. Padrão: `us-east-1`.                                  |
| `additional_tags`       | `map(string)`                                                                                           | Não         | Tags adicionais a serem mescladas às tags obrigatórias. Padrão: `{}`.                               |
| `vpc_id`                | `string`                                                                                                | Sim         | ID da VPC onde o Security Group será criado.                                                       |
| `security_group_name`   | `string`                                                                                                | Sim         | Finalidade do Security Group, usada como último segmento do nome (ex.: `web`).                     |
| `description`           | `string`                                                                                                | Não         | Descrição do Security Group. Padrão: `"Security Group gerenciado via Terraform."`.                 |
| `ingress_rules`         | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`                              | Não         | Regras de entrada. Nenhuma por padrão. `0.0.0.0/0` só é aceito na porta 443/tcp.                    |
| `egress_rules`          | `list(object({ description, from_port, to_port, protocol, cidr_blocks }))`                              | Não         | Regras de saída. Nenhuma por padrão. `0.0.0.0/0` só é aceito na porta 443/tcp.                      |

## 3. Outputs

| Nome                    | Descrição                              |
|-------------------------|-----------------------------------------|
| `security_group_name`   | Nome do Security Group criado.          |
| `security_group_arn`    | ARN do Security Group criado.           |
| `security_group_id`     | ID do Security Group criado.            |

## 4. Exemplo de uso

```hcl
module "sg_web" {
  source = "./security-group"

  environment          = "hml"
  system               = "tcc"
  region               = "us-east-1"
  vpc_id               = "vpc-0123456789abcdef0"
  security_group_name  = "web"
  description          = "Security Group para a camada web."

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
      description = "Acesso HTTPS de saída para atualizações"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  additional_tags = {
    Team = "platform"
  }
}
```
