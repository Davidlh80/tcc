# IAM Policy — dev-tcc-iam-\<finalidade\>

## 1. Visão Geral

Este template Terraform provisiona uma IAM Policy (`aws_iam_policy`) seguindo o padrão de nomenclatura `<ambiente>-<sistema>-iam-<finalidade>` e as tags obrigatórias da organização.

O documento da policy é construído dinamicamente a partir da variável `policy_statements`, permitindo múltiplos statements com `Effect = "Allow"`. As restrições de segurança abaixo são aplicadas via validação de variável:

- todo statement é sempre `Effect = "Allow"`; a policy não suporta `Deny` nem `Effect` customizado;
- é proibido combinar a action `"*"` com o resource `"*"` na mesma statement;
- ações e recursos permitidos são definidos exclusivamente pela variável `policy_statements`, informada pelo consumidor do módulo;
- este template não anexa nem replica nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) — apenas cria a policy, sem realizar attachments.

## 2. Variáveis

| Nome                  | Tipo                                                                 | Obrigatória | Descrição                                                                                     |
|-----------------------|-----------------------------------------------------------------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`         | `string`                                                              | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                              |
| `system`               | `string`                                                              | Sim         | Nome do sistema/aplicação, usado na composição do nome padronizado.                           |
| `region`               | `string`                                                              | Não         | Região AWS de referência. Padrão: `us-east-1`.                                                |
| `additional_tags`      | `map(string)`                                                         | Não         | Tags adicionais mescladas com as tags obrigatórias da organização. Padrão: `{}`.               |
| `policy_name`          | `string`                                                              | Sim         | Finalidade da policy, usada no nome padronizado (`<ambiente>-<sistema>-iam-<finalidade>`).     |
| `policy_description`   | `string`                                                              | Não         | Descrição da IAM Policy. Padrão: `"IAM Policy gerenciada via Terraform."`.                    |
| `policy_statements`    | `list(object({ sid = optional(string), actions = list(string), resources = list(string) }))` | Sim | Lista de statements `Allow` da policy, com ações e recursos permitidos por statement.          |

## 3. Outputs

| Nome           | Descrição                              |
|----------------|-----------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.              |
| `policy_arn`   | ARN da IAM Policy criada.               |
| `policy_id`    | ID da IAM Policy criada.                |

## 4. Exemplo de Uso

    module "iam_policy_readonly" {
      source = "./."

      environment = "prd"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      policy_statements = [
        {
          sid       = "ReadOnlyS3"
          actions   = ["s3:GetObject", "s3:ListBucket"]
          resources = [
            "arn:aws:s3:::prd-tcc-s3-logs",
            "arn:aws:s3:::prd-tcc-s3-logs/*"
          ]
        }
      ]

      additional_tags = {
        Squad = "plataforma"
      }
    }

    output "iam_policy_arn" {
      value = module.iam_policy_readonly.policy_arn
    }
