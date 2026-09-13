# IAM Policy - Blueprint Terraform

Blueprint Terraform para provisionamento de uma IAM Policy na AWS, gerada de forma autonoma, sem vinculo com padroes organizacionais especificos.

## Caracteristicas de seguranca

- Nao ha valores fixos sensiveis; toda configuracao e feita via variaveis.
- A variavel `statements` e obrigatoria (sem valor padrao), forcando quem consome o modulo a declarar explicitamente as permissoes desejadas.
- Wildcards (`*`) em `actions` ou `resources` sao bloqueados por validacao de variavel para statements com `effect = "Allow"`, evitando politicas excessivamente permissivas por engano.
- Statements com `effect = "Deny"` podem usar wildcards livremente, permitindo guardrails amplos (ex.: negar acoes fora de uma regiao especifica).
- Tags padrao (`Name`, `ManagedBy`) sao aplicadas automaticamente e podem ser complementadas via `var.tags`.

## Uso

```
module "iam_policy" {
  source = "./"

  name        = "app-read-only-s3"
  description = "Permite leitura de objetos em um bucket especifico"

  statements = [
    {
      sid       = "AllowReadSpecificBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::meu-bucket-exemplo",
        "arn:aws:s3:::meu-bucket-exemplo/*"
      ]
    }
  ]

  tags = {
    Ambiente = "dev"
  }
}
```

## Requisitos

| Nome | Versao |
|---|---|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS usada pelo provider | string | `"us-east-1"` | nao |
| name | Nome da IAM Policy | string | - | sim |
| path | Path da IAM Policy | string | `"/"` | nao |
| description | Descricao da IAM Policy | string | `"Gerenciado via Terraform."` | nao |
| tags | Tags adicionais | map(string) | `{}` | nao |
| statements | Lista de statements da policy | list(object) | - | sim |

## Outputs

| Nome | Descricao |
|---|---|
| policy_arn | ARN da IAM Policy criada |
| policy_id | ID da IAM Policy criada |
| policy_name | Nome da IAM Policy criada |
| policy_document_json | Documento JSON renderizado da policy |

## Validacao local

```
terraform init -backend=false
terraform validate
```
