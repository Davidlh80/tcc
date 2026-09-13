# S3 Bucket

## 1. Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos de Infraestrutura como Codigo da organizacao. O recurso inclui:

- Nomenclatura padronizada no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso publico (quatro flags do Public Access Block);
- Criptografia server-side habilitada por padrao (AES256, configuravel via variavel);
- Bucket policy que nega explicitamente requisicoes sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## 2. Variaveis

| Nome                | Tipo          | Obrigatoria | Descricao                                                                          |
|----------------------|---------------|-------------|--------------------------------------------------------------------------------------|
| `environment`         | `string`      | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                      |
| `system`              | `string`      | Nao         | Nome do sistema/projeto, usado na nomenclatura padronizada. Padrao: `tcc`.            |
| `region`              | `string`      | Nao         | Regiao AWS onde o bucket sera criado. Padrao: `us-east-1`.                            |
| `purpose`             | `string`      | Sim         | Finalidade do bucket, usada na nomenclatura padronizada (ex.: `logs`, `artifacts`).   |
| `additional_tags`     | `map(string)` | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.      |
| `versioning_status`   | `string`      | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.                |
| `sse_algorithm`       | `string`      | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`.      |

## 3. Outputs

| Nome           | Descricao                                  |
|----------------|---------------------------------------------|
| `bucket_name`  | Nome (identificador) do bucket S3 criado.    |
| `bucket_arn`   | ARN do bucket S3 criado.                     |
| `bucket_id`    | ID do bucket S3 criado.                      |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
