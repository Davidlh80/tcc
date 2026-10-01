# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona uma IAM Policy de minimo privilegio anexada a uma IAM Role dedicada, seguindo os padroes internos de nomenclatura, tags e governanca de IaC da organizacao.

Caracteristicas principais:

- A IAM Policy nunca fica solta: ela e criada e imediatamente anexada a uma IAM Role via `aws_iam_role_policy_attachment`.
- A trust policy (assume role policy) da Role restringe o principal autorizado a assumir a Role a um unico ARN configuravel (`trusted_principal_arn`), sem uso de `Principal: "*"` ou `"AWS": "*"`.
- A statement de permissoes da Policy usa `Effect: Allow` restrito apenas as acoes (`allowed_actions`) e recursos (`allowed_resources`) informados por variavel.
- E proibida, por validacao em tempo de plano, qualquer statement que combine `Action: "*"` com `Resource: "*"`.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.
- Nomes de recursos seguem o padrao `<ambiente>-<sistema>-iam-<finalidade>` (ex.: `prd-tcc-iam-readonly`).
- Tags obrigatorias da organizacao sao aplicadas a todos os recursos que suportam tags.

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                              |
|--------------------------|----------------|:-----------:|----------------------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim          | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                                          |
| `system`                 | `string`       | Sim          | Nome curto do sistema/aplicacao, usado na composicao do nome padronizado.                                |
| `region`                 | `string`       | Sim          | Regiao AWS onde os recursos serao provisionados.                                                         |
| `additional_tags`        | `map(string)`  | Nao          | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                          |
| `policy_name`            | `string`       | Sim          | Finalidade/nome funcional da Policy e da Role, usado como sufixo do nome padronizado (ex.: `readonly`).   |
| `trusted_principal_arn`  | `string`       | Sim          | ARN unico do principal autorizado a assumir a Role via `sts:AssumeRole`. Nao pode ser `"*"`.              |
| `allowed_actions`        | `list(string)` | Sim          | Lista de acoes IAM permitidas (`Effect = Allow`) na policy.                                               |
| `allowed_resources`      | `list(string)` | Sim          | Lista de ARNs/recursos sobre os quais as acoes informadas sao permitidas (`Effect = Allow`).               |

## 3. Outputs

| Nome          | Descricao                                 |
|---------------|--------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                 |
| `policy_arn`  | ARN da IAM Policy criada.                  |
| `policy_id`   | ID da IAM Policy criada.                   |
| `role_name`   | Nome da IAM Role criada.                   |
| `role_arn`    | ARN da IAM Role criada.                    |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./caminho/para/este/modulo"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-deployer"

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
