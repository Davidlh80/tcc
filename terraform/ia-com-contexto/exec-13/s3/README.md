# S3 Bucket

## 1. Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O nome do bucket e composto no formato `<ambiente>-<sistema>-s3-<finalidade>`.

Recursos criados:

- Bucket S3 com nome padronizado e tags obrigatorias;
- Bloqueio total de acesso publico (quatro flags do Public Access Block);
- Criptografia server-side com AES256 (SSE-S3);
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`.

## 2. Variaveis

| Nome              | Tipo          | Obrigatoria | Descricao                                                                 |
|-------------------|---------------|-------------|----------------------------------------------------------------------------|
| environment       | string        | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                           |
| system            | string        | Sim         | Nome do sistema ou aplicacao proprietaria do recurso.                     |
| region            | string        | Sim         | Regiao AWS onde o bucket sera provisionado.                               |
| purpose           | string        | Sim         | Finalidade do bucket, usada na composicao do nome.                       |
| versioning        | string        | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.    |
| additional_tags   | map(string)   | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.         |

## 3. Outputs

| Nome         | Descricao                          |
|--------------|--------------------------------------|
| bucket_name  | Nome do bucket S3 criado.          |
| bucket_arn   | ARN do bucket S3 criado.           |
| bucket_id    | ID do bucket S3 criado.            |

## 4. Exemplo de uso

```hcl
module "s3_logs" {
  source = "./s3"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning = "Enabled"

  additional_tags = {
    Squad = "plataforma"
  }
}
```
