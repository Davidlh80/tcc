# S3 Bucket - Blueprint Terraform

## 1. Visão geral

Este blueprint provisiona um bucket Amazon S3 seguindo os padrões internos de nomenclatura, tags e segurança da organização. O bucket é criado com:

- Nome padronizado no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso público (as quatro flags do Public Access Block habilitadas);
- Criptografia server-side habilitada por padrão com AES256 (SSE-S3), com suporte opcional a SSE-KMS;
- Bucket policy que nega explicitamente qualquer requisição que não utilize `aws:SecureTransport`;
- Versionamento configurável por variável, com padrão `Enabled`;
- Tags obrigatórias da organização aplicadas automaticamente, com suporte a tags adicionais.

## 2. Variáveis

| Nome                | Tipo           | Obrigatória | Descrição                                                                                     |
|---------------------|----------------|-------------|-------------------------------------------------------------------------------------------------|
| environment         | string         | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                |
| system              | string         | Sim         | Nome do sistema ou aplicação proprietária do recurso.                                           |
| region              | string         | Não         | Região AWS de provisionamento. Padrão: `us-east-1`.                                             |
| additional_tags     | map(string)    | Não         | Tags adicionais mescladas com as tags obrigatórias. Padrão: `{}`.                                |
| purpose             | string         | Sim         | Finalidade do bucket, usada na composição do nome (ex.: `logs`, `artifacts`).                    |
| versioning_status   | string         | Não         | Status do versionamento (`Enabled` ou `Suspended`). Padrão: `Enabled`.                          |
| sse_algorithm       | string         | Não         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrão: `AES256`.                 |
| kms_key_id          | string         | Não         | ID/ARN da chave KMS, utilizado apenas quando `sse_algorithm` for `aws:kms`. Padrão: `null`.       |
| force_destroy       | bool           | Não         | Permite excluir o bucket mesmo com objetos existentes. Padrão: `false`.                          |

## 3. Outputs

| Nome        | Descrição                                  |
|-------------|----------------------------------------------|
| bucket_name | Nome (identificador) do bucket S3 criado.     |
| bucket_arn  | ARN do bucket S3 criado.                      |
| bucket_id   | ID do bucket S3 criado.                       |

## 4. Exemplo de uso

    module "s3_bucket" {
      source = "./s3"

      environment = "dev"
      system      = "tcc"
      purpose     = "logs"
      region      = "us-east-1"

      versioning_status = "Enabled"
      sse_algorithm     = "AES256"

      additional_tags = {
        Squad = "plataforma"
      }
    }

    output "bucket_name" {
      value = module.s3_bucket.bucket_name
    }
