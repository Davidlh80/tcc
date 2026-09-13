# IAM Policy

## Visao geral do recurso

Este template cria uma IAM Policy customer-managed seguindo os padroes organizacionais de menor privilegio e governanca.

Caracteristicas principais:

- Contem uma unica statement com `Effect: Allow`, restrita exclusivamente as actions e aos recursos informados via variavel (`allowed_actions` e `allowed_resources`).
- Bloqueia, via `precondition` no ciclo de vida do recurso, a combinacao de `Action: "*"` com `Resource: "*"` na mesma statement.
- Nao anexa nem replica nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) — o template apenas cria a policy, sem realizar attachment a usuarios, grupos ou roles.
- Nome do recurso composto no padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `prd-tcc-iam-readonly`.
- Tags obrigatorias aplicadas automaticamente, com possibilidade de extensao via `additional_tags`.

## Variaveis

| Nome                  | Tipo         | Obrigatoria | Descricao                                                                                   |
|-----------------------|--------------|:-----------:|-----------------------------------------------------------------------------------------------|
| `environment`         | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                              |
| `system`               | string       | Sim         | Nome do sistema/aplicacao proprietaria do recurso.                                            |
| `region`               | string       | Sim         | Regiao AWS de referencia para o provider (IAM e global; mantida para padronizacao/auditoria). |
| `additional_tags`      | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                 |
| `policy_name`          | string       | Sim         | Finalidade da policy, usada para compor o nome padronizado (ex.: `readonly`).                 |
| `policy_description`   | string       | Nao         | Descricao funcional da IAM Policy.                                                            |
| `allowed_actions`      | list(string) | Sim         | Actions IAM permitidas explicitamente na statement Allow.                                     |
| `allowed_resources`    | list(string) | Sim         | ARNs de recursos permitidos explicitamente na statement Allow.                                |

## Outputs

| Nome           | Descricao                          |
|----------------|-------------------------------------|
| `policy_name`  | Nome da IAM Policy criada.          |
| `policy_arn`   | ARN da IAM Policy criada.           |
| `policy_id`    | ID da IAM Policy criada.            |

## Exemplo de uso

```hcl
module "iam_policy_readonly" {
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
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*",
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
