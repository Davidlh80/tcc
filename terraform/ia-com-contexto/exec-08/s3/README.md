# S3 Bucket

## Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket e criado com bloqueio total de acesso publico (quatro flags do Public Access Block habilitadas), criptografia server-side com AES256, negacao explicita de requisicoes sem `aws:SecureTransport` via bucket policy, e versionamento configuravel por variavel (padrao `Enabled`). O nome do bucket segue o padrao `<ambiente>-<sistema>-s3-<finalidade>`.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                                   |
|---------------------|---------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`        | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml`, `prd`).                                                |
| `system`             | `string`      | Sim         | Identificador do sistema/produto, usado na nomenclatura padronizada.                          |
| `region`             | `string`      | Nao         | Regiao AWS onde o recurso sera provisionado. Padrao: `us-east-1`.                              |
| `purpose`            | `string`      | Sim         | Finalidade do bucket, usada na nomenclatura padronizada (ex.: `logs`, `artifacts`).            |
| `additional_tags`    | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.               |
| `versioning_status`  | `string`      | Nao         | Status do versionamento do bucket (`Enabled` ou `Suspended`). Padrao: `Enabled`.               |

## Outputs

| Nome          | Descricao                              |
|---------------|-------------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.                  |
| `bucket_arn`  | ARN do bucket S3 criado.                   |
| `bucket_id`   | Identificador (ID) do bucket S3 criado.    |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./s3"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"
  region      = "us-east-1"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
