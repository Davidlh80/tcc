# S3 Bucket - dev-tcc-s3-logs

## 1. Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O recurso e nomeado no formato `<ambiente>-<sistema>-s3-<finalidade>` (ex.: `dev-tcc-s3-logs`) e inclui, por padrao:

- Bloqueio total de acesso publico (as quatro flags do Public Access Block habilitadas);
- Criptografia server-side (SSE-S3/AES256 por padrao, com opcao de SSE-KMS);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, habilitado (`Enabled`) por padrao;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## 2. Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                  |
|----------------------|--------------|-------------|------------------------------------------------------------------------------|
| `environment`        | string       | Sim         | Ambiente de implantacao do recurso (`dev`, `hml` ou `prd`).                   |
| `system`             | string       | Nao         | Nome do sistema ou produto ao qual o recurso pertence. Padrao: `tcc`.         |
| `region`             | string       | Nao         | Regiao AWS onde o bucket sera provisionado. Padrao: `us-east-1`.              |
| `purpose`            | string       | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: `logs`, `artifacts`). |
| `versioning_status`  | string       | Nao         | Status do versionamento do bucket (`Enabled` ou `Suspended`). Padrao: `Enabled`. |
| `sse_algorithm`      | string       | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`. |
| `additional_tags`    | map(string)  | Nao         | Tags adicionais aplicadas ao bucket, alem das tags obrigatorias da organizacao. |

## 3. Outputs

| Nome          | Descricao                                |
|---------------|--------------------------------------------|
| `bucket_name` | Nome do bucket S3 criado.                   |
| `bucket_arn`  | ARN do bucket S3 criado.                    |
| `bucket_id`   | Identificador (id) do bucket S3 criado.     |

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
