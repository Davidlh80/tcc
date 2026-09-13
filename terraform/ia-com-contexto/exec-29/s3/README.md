# S3 Bucket - dev-tcc-s3-\<finalidade\>

## Visao geral

Este modulo provisiona um bucket Amazon S3 aderente aos padroes internos de seguranca e governanca da organizacao, incluindo:

- Nomenclatura padronizada no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso publico via S3 Public Access Block (as quatro flags habilitadas);
- Criptografia server-side habilitada por padrao (AES256, com suporte opcional a `aws:kms`);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Tags obrigatorias aplicadas automaticamente, com suporte a tags adicionais.

## Variaveis

| Nome               | Tipo         | Obrigatoria | Descricao                                                                 |
|--------------------|--------------|-------------|----------------------------------------------------------------------------|
| environment        | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                          |
| system             | string       | Nao         | Nome do sistema/projeto, usado na nomenclatura. Padrao: `tcc`.            |
| region             | string       | Nao         | Regiao AWS de provisionamento. Padrao: `us-east-1`.                       |
| additional_tags    | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.             |
| purpose            | string       | Sim         | Finalidade do bucket, usada na nomenclatura (ex.: `logs`, `artifacts`).   |
| versioning_status  | string       | Nao         | Status do versionamento (`Enabled` ou `Suspended`). Padrao: `Enabled`.    |
| sse_algorithm      | string       | Nao         | Algoritmo de criptografia server-side (`AES256` ou `aws:kms`). Padrao: `AES256`. |
| kms_key_arn        | string       | Nao         | ARN da chave KMS, exigido apenas quando `sse_algorithm` for `aws:kms`.    |

## Outputs

| Nome        | Descricao                                |
|-------------|-------------------------------------------|
| bucket_name | Nome (identificador) do bucket S3 criado. |
| bucket_arn  | ARN do bucket S3 criado.                  |
| bucket_id   | ID do bucket S3 criado.                   |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./s3"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  purpose     = "logs"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Team = "plataforma"
  }
}
```
