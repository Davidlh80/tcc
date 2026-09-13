# IAM Policy - Blueprint Terraform

Blueprint Terraform para provisionamento de uma IAM Policy gerenciada pelo cliente (customer managed policy) na AWS, com guarda-corpos contra o uso inadvertido de curingas (`*`) em acoes e recursos.

## Recursos criados

- `data.aws_iam_policy_document.this`: documento de policy validado sintaticamente pelo provider AWS.
- `aws_iam_policy.this`: IAM Policy gerenciada, com precondicoes de seguranca em `lifecycle`.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name = "app-s3-read-write"
  actions     = ["s3:GetObject", "s3:PutObject"]
  resources   = ["arn:aws:s3:::my-bucket/*"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Seguranca por padrao

- `allow_wildcard_actions` e `allow_wildcard_resources` sao `false` por padrao: se `actions` ou `resources` contiverem `"*"`, o `terraform plan/apply` falhara com um erro explicito, a menos que o consumidor habilite explicitamente a flag correspondente.
- Nenhum valor sensivel ou credencial e utilizado ou fixado no codigo.
- `effect` e validado para aceitar apenas `Allow` ou `Deny`.
- `policy_name` e `policy_path` sao validados contra os formatos aceitos pela API IAM da AWS.

## Inputs

| Nome                      | Tipo           | Padrao                        | Descricao                                                        |
|---------------------------|----------------|--------------------------------|-------------------------------------------------------------------|
| region                    | string         | "us-east-1"                   | Regiao AWS do provider.                                           |
| policy_name               | string         | (obrigatorio)                  | Nome da IAM Policy.                                               |
| policy_description        | string         | "Gerenciada via Terraform."   | Descricao da policy.                                              |
| policy_path               | string         | "/"                            | Path da policy (deve iniciar e terminar com "/").                 |
| effect                    | string         | "Allow"                        | Efeito da statement: "Allow" ou "Deny".                           |
| actions                   | list(string)   | (obrigatorio)                   | Lista de acoes IAM.                                               |
| resources                 | list(string)   | (obrigatorio)                   | Lista de ARNs de recursos.                                        |
| allow_wildcard_actions    | bool           | false                           | Permite `"*"` em `actions` quando true.                           |
| allow_wildcard_resources  | bool           | false                           | Permite `"*"` em `resources` quando true.                         |
| tags                      | map(string)    | {}                              | Tags aplicadas ao recurso.                                        |

## Outputs

| Nome                  | Descricao                                      |
|-----------------------|--------------------------------------------------|
| policy_arn            | ARN da IAM Policy criada.                        |
| policy_id             | ID da IAM Policy criada.                         |
| policy_name           | Nome da IAM Policy criada.                       |
| policy_document_json  | Documento JSON da policy gerado.                 |

## Validacao local

```
terraform init -backend=false
terraform validate
```

Nao ha dependencia de backend remoto nem de credenciais reais para as validacoes acima.
