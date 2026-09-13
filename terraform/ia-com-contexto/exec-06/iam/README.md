# IAM Policy

## Visao geral do recurso

Este modulo cria uma IAM Policy gerenciada pelo cliente (customer managed policy) seguindo os padroes internos da organizacao. A policy contem uma unica statement `Allow`, restrita exclusivamente as acoes e aos recursos informados via variavel.

Restricoes de seguranca aplicadas:

- Proibida qualquer statement que combine `Action: "*"` com `Resource: "*"` (validado por `precondition` no plano/apply).
- O `Effect: Allow` fica restrito apenas as acoes (`allowed_actions`) e recursos (`allowed_resources`) informados por variavel.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada por este modulo — o modulo apenas cria a policy, sem anexa-la a usuarios, grupos ou roles.
- Nome do recurso segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `prd-tcc-iam-readonly`).
- Tags obrigatorias da organizacao sao aplicadas automaticamente e podem ser complementadas via `additional_tags`.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| environment | string | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`) |
| system | string | Sim | Nome do sistema ou aplicacao ao qual o recurso pertence |
| region | string | Nao (default: `us-east-1`) | Regiao AWS onde os recursos serao provisionados |
| additional_tags | map(string) | Nao (default: `{}`) | Tags adicionais mescladas as tags obrigatorias da organizacao |
| policy_name | string | Sim | Finalidade da policy, usada para compor o nome padronizado |
| allowed_actions | list(string) | Sim | Lista de acoes IAM permitidas na statement Allow |
| allowed_resources | list(string) | Sim | Lista de ARNs de recursos permitidos na statement Allow |

## Outputs

| Nome | Descricao |
|---|---|
| policy_name | Nome da IAM Policy criada |
| policy_arn | ARN da IAM Policy criada |
| policy_id | ID da IAM Policy criada |

## Exemplo de uso

```hcl
module "iam_policy" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"

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
```
