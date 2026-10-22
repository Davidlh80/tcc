# Blueprint Amazon S3

Cria um bucket S3 com criptografia SSE-S3 (`AES256`), bloqueio completo de
acesso publico, propriedade de objetos controlada pelo proprietario do bucket
e versionamento configuravel. A tag `Name`, `Project`, `ManagedBy` e
`Environment` sao aplicadas automaticamente; tags padrao nao podem ser
substituidas pelas tags adicionais.

## Variaveis

| Variavel | Tipo | Obrigatoria | Descricao |
|---|---|---:|---|
| `aws_region` | `string` | Sim | Regiao AWS do provider. |
| `bucket_name` | `string` | Sim | Nome globalmente unico do bucket. |
| `environment` | `string` | Sim | `dev`, `staging` ou `prod`. |
| `versioning_enabled` | `bool` | Nao | Controla versionamento; padrao `true`. |
| `additional_tags` | `map(string)` | Nao | Tags adicionais; padrao `{}`. |

## Outputs

`bucket_name`, `bucket_arn` e `bucket_id`.

## Exemplo

```hcl
aws_region         = "us-east-1"
bucket_name        = "p31-app-data-123456789012"
environment        = "dev"
versioning_enabled = true
additional_tags = {
  DataClass = "internal"
}
```

O nome de bucket deve ser unico globalmente na AWS. Mantenha os valores em um
`terraform.tfvars` local e nao inclua credenciais nesse arquivo.
