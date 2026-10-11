# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Role com uma IAM Policy anexada, seguindo boas praticas de minimo privilegio.

## O que este modulo cria

- Uma IAM Policy (`aws_iam_policy`) com um conjunto explicito de acoes e recursos (sem wildcard total `"*"`).
- Uma IAM Role (`aws_iam_role`) cuja trust policy (assume role policy) restringe o `sts:AssumeRole` a um unico principal configuravel, nunca a `"*"` ou `AWS: "*"`.
- O anexo (`aws_iam_role_policy_attachment`) entre a role e a policy, garantindo que a policy nunca fique solta sem nenhum principal associado.
- Suporte opcional a `sts:ExternalId` na trust policy, util em cenarios cross-account para mitigar o problema do "confused deputy".

## Decisoes de seguranca

- A variavel `trusted_principal_arn` e validada para rejeitar `"*"` e exigir um ARN IAM especifico (conta, usuario ou role).
- As variaveis `allowed_actions` e `allowed_resources` sao validadas para rejeitar o wildcard total `"*"`, evitando permissoes administrativas amplas por acidente.
- Nenhum valor sensivel (credenciais, chaves, segredos) e usado ou exigido por este modulo.
- Tags sao aplicadas tanto na role quanto na policy para rastreabilidade.

## Uso

```hcl
module "iam_role_with_policy" {
  source = "./"

  role_name              = "app-readonly-role"
  policy_name            = "app-readonly-policy"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-pipeline"
  external_id            = "optional-shared-secret"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*",
  ]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Inputs

| Nome                    | Descricao                                                                 | Tipo           | Default                  |
|-------------------------|----------------------------------------------------------------------------|----------------|---------------------------|
| role_name               | Nome da IAM Role                                                           | string         | "example-app-role"       |
| role_description        | Descricao da IAM Role                                                     | string         | ver variables.tf          |
| policy_name             | Nome da IAM Policy                                                         | string         | "example-app-policy"     |
| policy_description      | Descricao da IAM Policy                                                   | string         | ver variables.tf          |
| trusted_principal_arn   | ARN especifico autorizado a assumir a role (obrigatorio, sem wildcard)    | string         | (obrigatorio)             |
| external_id             | External ID opcional exigido no AssumeRole                                | string         | null                      |
| max_session_duration    | Duracao maxima da sessao assumida (segundos)                              | number         | 3600                      |
| allowed_actions         | Acoes IAM permitidas pela policy (sem "*")                                | list(string)   | ["s3:GetObject", "s3:ListBucket"] |
| allowed_resources       | Recursos aos quais as acoes se aplicam (sem "*")                          | list(string)   | exemplos de bucket S3     |
| tags                    | Tags aplicadas a role e a policy                                          | map(string)    | {}                        |

## Outputs

| Nome                   | Descricao                                        |
|------------------------|---------------------------------------------------|
| role_arn               | ARN da IAM Role criada                            |
| role_name              | Nome da IAM Role criada                           |
| role_id                | ID unico da IAM Role criada                       |
| policy_arn             | ARN da IAM Policy criada                          |
| policy_name            | Nome da IAM Policy criada                         |
| policy_attachment_id   | ID do attachment entre a role e a policy          |

## Validacao local

```sh
terraform init -backend=false
terraform validate
```
