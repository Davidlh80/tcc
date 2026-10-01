# IAM Policy anexada a IAM Role

## 1. Visao geral

Este modulo provisiona uma IAM Policy de privilegio minimo e uma IAM Role dedicada, com a policy anexada a role via `aws_iam_role_policy_attachment` (a policy nunca fica sem um principal associado).

Caracteristicas principais:

- Trust policy (assume role policy) da role restrita a um unico principal configuravel por variavel (`trusted_principal_arn`); `Principal: "*"` e `"AWS": "*"` sao proibidos.
- A statement da policy customizada usa `Effect: Allow` restrito apenas as acoes (`allowed_actions`) e recursos (`allowed_resources`) informados por variavel.
- E proibida, por validacao de variavel e por precondition no recurso, qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomenclatura no padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` e tags obrigatorias aplicadas em todos os recursos que suportam tags.

## 2. Variaveis

| Nome                     | Tipo         | Obrigatoria | Descricao                                                                                   |
|--------------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`             | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`                  | string       | Sim         | Nome do sistema ou aplicacao proprietaria do recurso.                                         |
| `region`                  | string       | Nao         | Regiao AWS. Padrao: `us-east-1`.                                                               |
| `policy_name`             | string       | Sim         | Finalidade da policy/role, usada na nomenclatura (ex.: `readonly`, `deploy`).                  |
| `additional_tags`         | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                  |
| `trusted_principal_arn`   | string       | Sim         | ARN do principal autorizado a assumir a role. Nao pode ser `"*"`.                              |
| `allowed_actions`         | list(string) | Sim         | Lista de acoes IAM permitidas na policy. Nao pode conter somente `"*"`.                        |
| `allowed_resources`       | list(string) | Sim         | Lista de ARNs de recursos permitidos na policy. Nao pode conter somente `"*"`.                 |

## 3. Outputs

| Nome          | Descricao                                       |
|----------------|--------------------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.                        |
| `policy_arn`   | ARN da IAM Policy criada.                         |
| `policy_id`    | ID da IAM Policy criada.                          |
| `role_name`    | Nome da IAM Role criada e associada a policy.     |
| `role_arn`     | ARN da IAM Role criada e associada a policy.      |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./iam"

      environment = "dev"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-app-execution"

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
