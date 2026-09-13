# S3 Bucket

## Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket e criado com bloqueio total de acesso publico (Public Access Block com as quatro flags habilitadas), criptografia server-side padrao AES256 (SSE-S3), bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport` e versionamento configuravel por variavel, com padrao `Enabled`. O nome do bucket segue o padrao `<ambiente>-<sistema>-s3-<finalidade>`.

## Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                 |
|---------------------|---------------|-------------|----------------------------------------------------------------------------|
| `environment`       | `string`      | Sim         | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`).                |
| `system`            | `string`      | Sim         | Identificador do sistema/aplicacao proprietaria do recurso.               |
| `region`            | `string`      | Nao         | Regiao AWS onde o bucket sera provisionado. Padrao: `us-east-1`.          |
| `purpose`           | `string`      | Sim         | Finalidade do bucket, usada na composicao do nome padronizado.             |
| `versioning_status` | `string`      | Nao         | Status do versionamento do bucket (`Enabled` ou `Suspended`). Padrao: `Enabled`. |
| `additional_tags`   | `map(string)` | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao.             |

## Outputs

| Nome          | Descricao                          |
|---------------|-------------------------------------|
| `bucket_name` | Nome (bucket) do bucket S3 criado. |
| `bucket_arn`  | ARN do bucket S3 criado.           |
| `bucket_id`   | ID do bucket S3 criado.            |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./s3"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
