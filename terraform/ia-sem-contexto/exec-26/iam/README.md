# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Role com trust policy restrita a um principal configuravel e uma IAM Policy de menor privilegio anexada a essa role via `aws_iam_role_policy_attachment`. A policy nunca fica solta: ela e sempre criada e anexada a role dentro da mesma execucao.

## Recursos criados

- `aws_iam_role.this` — IAM Role cuja trust policy (assume role policy) e restrita ao(s) principal(is) definido(s) em `assume_role_principal_identifiers`, sem permitir `"*"` ou `AWS: "*"`.
- `aws_iam_policy.this` — IAM Policy com acoes e recursos definidos por variavel, evitando wildcard amplo (`"*"`) em `Action` e `Resource`.
- `aws_iam_role_policy_attachment.this` — anexa a policy criada a role criada.

## Seguranca por padrao

- A trust policy exige um `principals.identifiers` explicito; variaveis com `"*"` sao rejeitadas por `validation`.
- As acoes e recursos da policy tambem rejeitam `"*"` via `validation`, incentivando permissoes especificas.
- Suporte opcional a `sts:ExternalId` na trust policy, util para cenarios de acesso cross-account (mitigacao de confused deputy).
- Nenhuma credencial real e necessaria para `terraform validate`; os valores padrao sao apenas exemplos ilustrativos (ex.: conta `123456789012`, bucket `example-bucket`).

## Uso

```
terraform init -backend=false
terraform validate
```

Para um cenario real, defina via `terraform.tfvars` ou `-var`:

- `assume_role_principal_type` e `assume_role_principal_identifiers`: quem pode assumir a role.
- `policy_actions` e `policy_resources`: permissoes minimas necessarias para o caso de uso.
- `external_id`: opcional, para reforcar a trust policy em acessos cross-account.

## Inputs principais

| Nome | Descricao | Padrao |
|---|---|---|
| `aws_region` | Regiao AWS | `us-east-1` |
| `role_name` | Nome da IAM Role | `app-restricted-role` |
| `policy_name` | Nome da IAM Policy | `app-restricted-policy` |
| `assume_role_principal_type` | Tipo do principal (`AWS` ou `Service`) | `AWS` |
| `assume_role_principal_identifiers` | Principais autorizados a assumir a role | `["arn:aws:iam::123456789012:root"]` |
| `policy_actions` | Acoes permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos alcançados pela policy | `["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]` |
| `external_id` | ExternalId opcional na trust policy | `null` |
| `tags` | Tags aplicadas aos recursos IAM | `{}` |

## Outputs principais

| Nome | Descricao |
|---|---|
| `role_arn` | ARN da IAM Role criada |
| `role_name` | Nome da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_attachment_id` | ID do anexo entre policy e role |
