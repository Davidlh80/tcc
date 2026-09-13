# IAM Policy — Blueprint Terraform

Blueprint Terraform para provisionamento de uma IAM Policy na AWS, gerado de forma autonoma sem vinculo a padroes organizacionais especificos.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy com uma unica statement, construida via `data.aws_iam_policy_document.this`.

## Decisoes de design

- Nao ha wildcard total (`*`) em `actions` ou `resources` por padrao; a policy padrao concede apenas `s3:GetObject` e `s3:ListBucket` sobre um bucket de exemplo.
- Variaveis `allowed_actions` e `allowed_resources` possuem validacao que bloqueia o uso do wildcard total `"*"`, forcando o consumidor do modulo a ser explicito sobre o escopo de acesso.
- `effect` e restrito a `Allow` ou `Deny` via validacao.
- Nenhum valor sensivel ou credencial real esta hardcoded; toda configuracao e feita via variaveis.
- Tags sao opcionais e configuraveis via `var.tags`.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name         = "app-readonly-s3"
  policy_description  = "Permite leitura de objetos em um bucket especifico"
  allowed_actions     = ["s3:GetObject", "s3:ListBucket"]
  allowed_resources   = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]
  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
```

## Variaveis

| Nome                | Descricao                                              | Default                          |
|----------------------|---------------------------------------------------------|-----------------------------------|
| aws_region           | Regiao AWS do provider                                  | `us-east-1`                       |
| policy_name          | Nome da IAM Policy                                       | `example-iam-policy`              |
| policy_description   | Descricao da IAM Policy                                  | `Policy gerenciada via Terraform.`|
| path                 | Path da IAM Policy                                        | `/`                                |
| effect               | Efeito da statement (`Allow` ou `Deny`)                   | `Allow`                            |
| allowed_actions      | Lista de acoes IAM permitidas (sem wildcard total)        | `["s3:GetObject", "s3:ListBucket"]`|
| allowed_resources    | Lista de ARNs de recursos (sem wildcard total)             | bucket de exemplo                 |
| tags                 | Tags aplicadas ao recurso                                  | `{}`                               |

## Outputs

| Nome                  | Descricao                             |
|------------------------|-----------------------------------------|
| policy_arn             | ARN da IAM Policy criada                |
| policy_id              | ID da IAM Policy criada                 |
| policy_name            | Nome da IAM Policy criada               |
| policy_document_json   | Documento JSON da policy gerada         |

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para `init` e `validate`, pois nenhum data source depende de chamadas de API remotas.
