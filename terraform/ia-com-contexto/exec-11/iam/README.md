# IAM Policy anexada a uma IAM Role

## Visao geral

Este blueprint Terraform provisiona uma IAM Policy customizada anexada a uma IAM Role, seguindo o principio do menor privilegio e os padroes organizacionais de nomenclatura, tags e seguranca.

Recursos criados:
- Uma IAM Role, com trust policy (assume role policy) restrita a um unico principal configuravel via variavel (nunca "*").
- Uma IAM Policy customizada, com uma statement Allow restrita apenas as acoes e recursos informados por variavel.
- O attachment que associa a IAM Policy a IAM Role, garantindo que a policy nunca fique solta, sem nenhum principal associado.

Guardrails de seguranca aplicados:
- Proibido `Principal: "AWS": "*"` na trust policy (validado via variavel `trusted_principal_arn`).
- Proibida qualquer statement que combine `Action: "*"` com `Resource: "*"` (validado via `lifecycle precondition` na policy).
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- `Effect: Allow` restrito apenas as acoes e recursos informados via variavel.

Padrao de nomenclatura aplicado: `<ambiente>-<sistema>-iam-<finalidade>`, onde `<finalidade>` e o valor de `policy_name`. Exemplo: `prd-tcc-iam-readonly` (policy) e `prd-tcc-iam-readonly-role` (role).

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| environment | string | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| system | string | Sim | Nome do sistema/projeto, usado na nomenclatura padronizada. |
| region | string | Nao (default: `us-east-1`) | Regiao AWS usada pelo provider. |
| additional_tags | map(string) | Nao (default: `{}`) | Tags adicionais mescladas as tags obrigatorias da organizacao. |
| policy_name | string | Sim | Finalidade da policy/role, usada como sufixo do nome padronizado (ex.: `readonly`). |
| trusted_principal_arn | string | Sim | ARN do principal autorizado a assumir a role via trust policy. Nao pode ser `"*"`. |
| allowed_actions | list(string) | Sim | Lista de acoes IAM permitidas pela policy. |
| allowed_resources | list(string) | Sim | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam. |

## Outputs

| Nome | Descricao |
|---|---|
| policy_name | Nome da IAM Policy criada. |
| policy_arn | ARN da IAM Policy criada. |
| policy_id | ID da IAM Policy criada. |
| role_name | Nome da IAM Role criada. |
| role_arn | ARN da IAM Role criada. |
| role_id | ID unico (unique_id) da IAM Role criada. |

## Exemplo de uso

    module "iam_readonly" {
      source = "./."

      environment = "prd"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      trusted_principal_arn = "arn:aws:iam::123456789012:role/plataforma-ci"

      allowed_actions = [
        "s3:GetObject",
        "s3:ListBucket",
      ]

      allowed_resources = [
        "arn:aws:s3:::dev-tcc-s3-logs",
        "arn:aws:s3:::dev-tcc-s3-logs/*",
      ]

      additional_tags = {
        Squad = "plataforma"
      }
    }
