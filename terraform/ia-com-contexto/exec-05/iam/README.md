# IAM Policy anexada a uma IAM Role

## Visao geral

Este template provisiona uma IAM Policy de privilegio minimo e uma IAM Role dedicada, anexando a policy a role atraves de `aws_iam_role_policy_attachment` (a policy nunca fica solta, sem nenhum principal associado). A trust policy (assume role policy) da role restringe o `sts:AssumeRole` a um unico principal AWS informado via variavel, proibindo `Principal: "*"` ou `"AWS": "*"`. A statement `Effect: Allow` da policy e restrita apenas as acoes e aos recursos informados por variavel, e uma precondition de lifecycle impede que uma mesma statement combine `Action: "*"` com `Resource: "*"`. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Nomenclatura seguindo o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` da organizacao:
- Policy: `<ambiente>-<sistema>-iam-policy-<policy_name>`
- Role: `<ambiente>-<sistema>-iam-role-<policy_name>`

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| environment | string | sim | Ambiente de implantacao (dev, hml, prd). |
| system | string | sim | Nome do sistema/aplicacao, usado na nomenclatura padronizada. |
| region | string | sim | Regiao AWS onde os recursos serao provisionados. |
| additional_tags | map(string) | nao (default `{}`) | Tags adicionais mescladas com as tags obrigatorias da organizacao. |
| policy_name | string | sim | Finalidade/nome da IAM Policy e da IAM Role, usada na nomenclatura padronizada. |
| trusted_principal_arn | string | sim | ARN do principal especifico autorizado a assumir a IAM Role (trust policy). Nao pode ser "*". |
| allowed_actions | list(string) | sim | Acoes IAM permitidas (Effect Allow) na policy. |
| allowed_resources | list(string) | sim | ARNs de recursos permitidos (Effect Allow) na policy. |
| max_session_duration | number | nao (default 3600) | Duracao maxima, em segundos, da sessao assumida via a role (3600-43200). |

## Outputs

| Nome | Descricao |
|---|---|
| policy_name | Nome da IAM Policy criada. |
| policy_arn | ARN da IAM Policy criada. |
| policy_id | ID da IAM Policy criada. |
| role_name | Nome da IAM Role criada. |
| role_arn | ARN da IAM Role criada. |
| role_id | ID (unique id) da IAM Role criada. |

## Exemplo de uso

    module "iam_readonly" {
      source = "./iam"

      environment           = "dev"
      system                = "tcc"
      region                = "us-east-1"
      policy_name            = "readonly"
      trusted_principal_arn  = "arn:aws:iam::123456789012:role/dev-tcc-app-role"

      allowed_actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]

      allowed_resources = [
        "arn:aws:s3:::dev-tcc-s3-logs",
        "arn:aws:s3:::dev-tcc-s3-logs/*"
      ]

      additional_tags = {
        Squad = "plataforma"
      }
    }
