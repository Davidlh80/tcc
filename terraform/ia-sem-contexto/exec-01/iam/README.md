# IAM Role com IAM Policy anexada

Blueprint Terraform para provisionar uma IAM Role com uma IAM Policy dedicada anexada diretamente a ela, seguindo o principio de menor privilegio.

## Recursos criados

- `aws_iam_role.this`: IAM Role com trust policy (assume role policy) restrita a um unico principal configuravel.
- `aws_iam_policy.this`: IAM Policy customizada com acoes e recursos definidos via variaveis.
- `aws_iam_role_policy_attachment.this`: anexa a policy criada diretamente a role, garantindo que a policy nunca fique solta (sem principal associado).
- `data.aws_iam_policy_document.assume_role`: gera a trust policy restrita ao `trusted_principal_arn`.
- `data.aws_iam_policy_document.this`: gera o documento da policy com as acoes e recursos permitidos.

## Decisoes de seguranca

- A trust policy aceita exatamente um principal (`var.trusted_principal_arn`), validado para nunca ser `"*"` e sempre corresponder a um ARN IAM especifico (conta root, usuario ou role). Isso impede que qualquer conta ou principal arbitrario assuma a role.
- Suporte opcional a `sts:ExternalId` (`require_external_id` / `external_id`) para cenarios de acesso cross-account de terceiros, mitigando o problema do "confused deputy".
- `policy_actions` e `policy_resources` sao validados para rejeitar wildcards amplos (`"*"`, `"iam:*"`, `"*:*"`), forcando o uso de permissoes especificas.
- Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e utilizada; a policy e sempre customizada e escopada pelas variaveis.
- `max_session_duration` e limitado entre 1h e 12h, dentro dos limites suportados pela AWS.
- `force_detach_policies = true` garante que anexos de policy nao impecam a destruicao da role.
- Nenhum valor sensivel (credenciais, segredos) e definido como default; `external_id`, quando usado, deve ser fornecido via variavel marcada como `sensitive`.

## Uso

```
module "iam_role" {
  source = "./"

  role_name              = "minha-app-role"
  policy_name            = "minha-app-policy"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-deployer"
  policy_actions         = ["s3:GetObject", "s3:ListBucket"]
  policy_resources       = ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]
}
```

## Variaveis principais

| Nome | Descricao | Default |
|---|---|---|
| `aws_region` | Regiao AWS do provider | `us-east-1` |
| `role_name` | Nome da IAM Role | `example-application-role` |
| `trusted_principal_arn` | Principal autorizado a assumir a role (obrigatorio) | — |
| `require_external_id` / `external_id` | Exige `ExternalId` na trust policy | `false` / `""` |
| `policy_name` | Nome da IAM Policy | `example-application-policy` |
| `policy_actions` | Acoes permitidas pela policy | `["s3:GetObject", "s3:ListBucket"]` |
| `policy_resources` | Recursos alvo das acoes | bucket de exemplo |
| `max_session_duration` | Duracao maxima da sessao assumida | `3600` |
| `tags` | Tags aplicadas a role e policy | `{ ManagedBy = "terraform" }` |

## Outputs

- `role_arn`, `role_name`, `role_id`
- `policy_arn`, `policy_name`, `policy_id`
- `assume_role_policy_json`

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e configurado e nenhuma credencial real e necessaria para `init`/`validate`; apenas `trusted_principal_arn` precisa ser fornecido (pode ser um ARN de exemplo valido sintaticamente para fins de validacao).
