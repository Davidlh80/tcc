# IAM Policy — Blueprint Terraform

Blueprint autonomo para provisionar uma IAM Policy gerenciada na AWS, com escopo de permissoes definido explicitamente via variaveis (sem wildcards amplos por padrao).

## Recursos criados

- `aws_iam_policy.this`
- `data.aws_iam_policy_document.this`

## Principios de seguranca adotados

- Nenhum valor sensivel fixo no codigo; tudo parametrizado via variaveis.
- `policy_actions` e `policy_resources` sao obrigatorios (sem default), forcando escopo explicito por quem consome o modulo.
- Validacoes bloqueiam o uso do wildcard `"*"` isolado em `policy_actions` e `policy_resources`, reduzindo o risco de policies excessivamente permissivas.
- `policy_effect` restrito a `Allow` ou `Deny` via validacao.
- Nenhum backend remoto configurado — estado local, adequado para validacao sintatica isolada.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name = "app-readonly-s3"

  policy_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  policy_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*",
  ]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Variaveis

| Nome | Descricao | Tipo | Default | Obrigatoria |
|---|---|---|---|---|
| `aws_region` | Regiao AWS do provider | `string` | `"us-east-1"` | Nao |
| `policy_name` | Nome da IAM Policy | `string` | - | Sim |
| `policy_description` | Descricao da IAM Policy | `string` | `"IAM Policy gerenciada via Terraform."` | Nao |
| `policy_path` | Path da policy no IAM | `string` | `"/"` | Nao |
| `policy_effect` | Efeito da statement (`Allow`/`Deny`) | `string` | `"Allow"` | Nao |
| `policy_actions` | Lista de IAM actions cobertas | `list(string)` | - | Sim |
| `policy_resources` | Lista de ARNs de recursos | `list(string)` | - | Sim |
| `tags` | Tags aplicadas ao recurso | `map(string)` | `{}` | Nao |

## Outputs

| Nome | Descricao |
|---|---|
| `policy_arn` | ARN da IAM Policy criada |
| `policy_id` | ID da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_document_json` | Documento JSON gerado para a policy |

## Validacao

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

## Observacoes

- Este blueprint nao assume nenhum padrao organizacional pre-existente; nomenclatura, tags e granularidade de permissoes devem ser ajustadas conforme a governanca de IAM de cada ambiente.
- Recomenda-se anexar a policy resultante (`aws_iam_policy.this.arn`) a roles ou usuarios via `aws_iam_role_policy_attachment` ou `aws_iam_user_policy_attachment` em modulos consumidores, mantendo este blueprint focado apenas na definicao da policy.
