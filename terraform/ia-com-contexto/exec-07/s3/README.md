# S3 Bucket

## Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura e seguranca da organizacao. O bucket e criado com:

- Nome no padrao `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio das quatro flags do Public Access Block;
- Criptografia server-side habilitada (AES256 por padrao, com suporte a aws:kms);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Tags obrigatorias de governanca aplicadas automaticamente.

## Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| environment         | string       | Sim         | Ambiente de implantacao (dev, hml, prd).                                  |
| system              | string       | Sim         | Nome curto do sistema/aplicacao dono do recurso.                          |
| region              | string       | Nao         | Regiao AWS onde o bucket sera criado. Padrao: `us-east-1`.                |
| purpose             | string       | Sim         | Finalidade do bucket, usada no padrao de nomenclatura.                    |
| additional_tags     | map(string)  | Nao         | Tags adicionais mescladas com as tags obrigatorias. Padrao: `{}`.         |
| versioning_status   | string       | Nao         | Status do versionamento (Enabled ou Suspended). Padrao: `Enabled`.        |
| sse_algorithm       | string       | Nao         | Algoritmo de criptografia server-side (AES256 ou aws:kms). Padrao: `AES256`. |
| kms_key_id          | string       | Nao         | ID/ARN da chave KMS, usado quando sse_algorithm for aws:kms.              |

## Outputs

| Nome         | Descricao                              |
|--------------|-----------------------------------------|
| bucket_name  | Nome (bucket) do bucket S3 criado.      |
| bucket_arn   | ARN do bucket S3 criado.                |
| bucket_id    | ID do bucket S3 criado.                 |

## Exemplo de uso

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
