# IAM Policy — Blueprint Terraform

Blueprint standalone para provisionamento de uma IAM Policy na AWS, com escopo de acoes e recursos definido via variaveis, seguindo o principio de menor privilegio por padrao.

## Recursos criados

- `data.aws_iam_policy_document.this`: documento de policy renderizado a partir de `effect`, `actions` e `resources`.
- `aws_iam_policy.this`: IAM Policy gerenciada, com nome, path, descricao e tags configuraveis.

## Decisões de design

- O documento da policy é construído com o data source `aws_iam_policy_document` em vez de JSON inline, permitindo validação sintática pelo próprio Terraform.
- Os valores padrão de `actions` e `resources` são exemplos restritos (leitura de um bucket S3 específico), evitando `"*"` como padrão. Ajuste conforme o caso de uso real antes de aplicar em produção.
- `effect` é validado para aceitar apenas `Allow` ou `Deny`.

## Uso

```
terraform init -backend=false
terraform validate
terraform plan \
  -var="policy_name=minha-policy" \
  -var='actions=["s3:GetObject"]' \
  -var='resources=["arn:aws:s3:::meu-bucket/*"]'
```

## Inputs

| Nome | Descrição | Tipo | Default |
|---|---|---|---|
| `aws_region` | Região AWS do provider | `string` | `us-east-1` |
| `policy_name` | Nome da IAM Policy | `string` | `app-least-privilege-policy` |
| `policy_description` | Descrição da policy | `string` | `Policy gerada com escopo restrito de acoes e recursos.` |
| `policy_path` | Path da policy na conta | `string` | `/` |
| `effect` | Efeito da statement (`Allow`/`Deny`) | `string` | `Allow` |
| `actions` | Lista de ações IAM | `list(string)` | `["s3:GetObject", "s3:ListBucket"]` |
| `resources` | Lista de ARNs alvo | `list(string)` | `["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]` |
| `tags` | Tags da policy | `map(string)` | `{ ManagedBy = "terraform" }` |

## Outputs

| Nome | Descrição |
|---|---|
| `policy_arn` | ARN da IAM Policy criada |
| `policy_id` | ID da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_document_json` | JSON renderizado da policy |

## Recomendações de segurança

- Nunca use `"*"` em `actions` ou `resources` sem justificativa explícita — prefira listar ações e ARNs específicos.
- Revise periodicamente as policies anexadas para remover permissões não utilizadas (least privilege).
- Este módulo não anexa a policy a nenhuma role, user ou group — o attachment deve ser feito separadamente, de forma explícita, para manter o controle sobre quem recebe as permissões.
