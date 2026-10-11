# IAM Role com IAM Policy anexada (acesso restrito)

Blueprint Terraform que provisiona:

- Uma IAM Policy com permissoes explicitas (sem acoes administrativas e sem wildcard amplo em `Action` ou `Resource` por padrao).
- Uma IAM Role cuja trust policy (`assume_role_policy`) permite apenas um principal configuravel via `var.trusted_principal_arn`. O principal `"*"` (ou `AWS: "*"`) e explicitamente bloqueado por validacao de variavel.
- O attachment da policy a role, garantindo que a policy nunca fique solta sem nenhum principal associado.

## Uso

```
module "restricted_role" {
  source = "./"

  trusted_principal_arn = "arn:aws:iam::123456789012:role/ci-deployer"
  allowed_resources     = ["arn:aws:logs:us-east-1:123456789012:log-group:/app/*"]
}
```

Ou, diretamente neste diretorio:

```
terraform init -backend=false
terraform validate
terraform plan \
  -var="trusted_principal_arn=arn:aws:iam::123456789012:role/ci-deployer" \
  -var='allowed_resources=["arn:aws:logs:us-east-1:123456789012:log-group:/app/*"]'
```

## Inputs principais

| Nome | Descricao | Obrigatorio |
|---|---|---|
| `trusted_principal_arn` | ARN do unico principal autorizado a assumir a role. Nao pode ser `*`. | Sim |
| `allowed_resources` | ARNs dos recursos cobertos pela policy. Nao pode conter `*`. | Sim |
| `allowed_actions` | Acoes IAM permitidas. Padrao: acoes de CloudWatch Logs sem privilegios administrativos. | Nao |
| `role_name`, `policy_name` | Nomes dos recursos IAM. | Nao |
| `max_session_duration` | Duracao maxima da sessao assumida (3600–43200s). | Nao |
| `tags` | Tags aplicadas aos recursos. | Nao |

## Outputs principais

- `role_arn`, `role_name`, `role_id`
- `policy_arn`, `policy_name`
- `policy_attachment_id`

## Consideracoes de seguranca

- A trust policy nunca aceita `"*"` como principal; isso e reforcado por validacao na variavel `trusted_principal_arn`.
- As variaveis `allowed_actions` e `allowed_resources` rejeitam o wildcard `"*"`, forcando escopo explicito de permissoes e recursos.
- Nenhuma acao administrativa (ex.: `iam:*`, `*:*`) esta incluida no padrao; revise cuidadosamente antes de ampliar `allowed_actions` em ambientes produtivos.
- Credenciais e identificadores de conta reais nao estao fixados no codigo; devem ser fornecidos via variaveis no momento do `plan`/`apply`.
