# IAM Policy — Blueprint Terraform

Blueprint autonomo para provisionamento de uma IAM Policy na AWS, sem dependencia de padroes organizacionais especificos. As decisoes de nomenclatura, escopo de permissoes e tags seguem boas praticas gerais de mercado, com enfase em menor privilegio.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy gerenciada, com documento de politica construido via `data.aws_iam_policy_document.this`.

## Decisoes de seguranca

- Nenhum valor padrao permite o wildcard global `"*"` em `actions` ou `resources`; ambos os campos sao validados para rejeitar esse valor, forcando o consumidor do modulo a declarar acoes e recursos explicitos.
- Nao ha valores sensiveis fixos no codigo; toda configuracao e parametrizada via variaveis.
- O efeito da statement (`Allow`/`Deny`) e configuravel e validado.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name         = "app-s3-read-only"
  policy_description  = "Permite leitura de objetos em um bucket especifico"
  effect              = "Allow"
  actions             = [
    "s3:GetObject",
    "s3:ListBucket",
  ]
  resources = [
    "arn:aws:s3:::exemplo-bucket",
    "arn:aws:s3:::exemplo-bucket/*",
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS utilizada pelo provider | `string` | `"us-east-1"` | nao |
| policy_name | Nome da IAM Policy | `string` | - | sim |
| policy_description | Descricao da IAM Policy | `string` | `"Managed by Terraform"` | nao |
| path | Path da IAM Policy no IAM | `string` | `"/"` | nao |
| effect | Efeito da statement (`Allow` ou `Deny`) | `string` | `"Allow"` | nao |
| actions | Lista de acoes IAM cobertas pela policy | `list(string)` | - | sim |
| resources | Lista de ARNs de recursos alvo da policy | `list(string)` | - | sim |
| tags | Tags aplicadas a IAM Policy | `map(string)` | `{}` | nao |

## Outputs

| Nome | Descricao |
|---|---|
| policy_arn | ARN da IAM Policy criada |
| policy_id | ID da IAM Policy criada |
| policy_name | Nome da IAM Policy criada |

## Validacao local

```bash
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para `init`/`validate`, pois nao ha data sources ou recursos que exijam chamadas de API na fase de validacao sintatica.
