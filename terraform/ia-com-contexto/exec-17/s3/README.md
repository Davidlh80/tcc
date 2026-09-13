# S3 Bucket - dev-tcc-s3-logs (exemplo)

## 1. Visao geral do recurso

Este template provisiona um bucket Amazon S3 aderente aos padroes internos de seguranca e governanca da organizacao, incluindo:

- Nomenclatura padronizada no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio das quatro flags do Public Access Block (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`);
- Criptografia server-side habilitada por padrao com AES256 (SSE-S3), com suporte opcional a `aws:kms`;
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Tags obrigatorias aplicadas automaticamente, com suporte a tags adicionais.

## 2. Tabela de variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                                   |
|---------------------|--------------|-------------|-----------------------------------------------------------------------------------------------|
| `environment`       | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| `system`             | string       | Sim         | Nome do sistema/produto proprietario do recurso.                                              |
| `region`             | string       | Sim         | Regiao AWS onde o bucket sera criado.                                                          |
| `purpose`            | string       | Sim         | Finalidade do bucket, usada na nomenclatura (ex.: `logs`, `artifacts`).                        |
| `versioning_status`  | string       | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.                         |
| `sse_algorithm`      | string       | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`.                |
| `kms_key_id`         | string       | Nao         | ID/ARN da chave KMS, usado apenas quando `sse_algorithm = "aws:kms"`. Padrao: `null`.           |
| `additional_tags`    | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias da organizacao. Padrao: `{}`.                |

## 3. Tabela de outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.               |
| `bucket_arn`  | ARN do bucket S3 criado.                |
| `bucket_id`   | ID do bucket S3 criado.                 |

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
