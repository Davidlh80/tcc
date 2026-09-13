# S3 Bucket - dev-tcc-s3-<purpose>

## Visao geral

Este modulo provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket e criado com:

- Nomenclatura padronizada no formato `<ambiente>-<sistema>-s3-<finalidade>`;
- Bloqueio total de acesso publico (as quatro flags do Public Access Block habilitadas);
- Criptografia server-side habilitada por padrao (AES256, configuravel);
- Bucket policy que nega explicitamente qualquer requisicao sem `aws:SecureTransport`;
- Versionamento configuravel por variavel, com padrao `Enabled`;
- Tags obrigatorias da organizacao aplicadas automaticamente.

## Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| environment         | string       | Sim         | Ambiente de implantacao (dev, hml ou prd).                                |
| system              | string       | Sim         | Nome do sistema ao qual o bucket pertence.                                |
| region              | string       | Nao         | Regiao AWS onde o bucket sera criado. Padrao: `us-east-1`.                |
| purpose             | string       | Sim         | Finalidade do bucket, utilizada na nomenclatura padronizada.              |
| versioning_status   | string       | Nao         | Status do versionamento do bucket (Enabled ou Suspended). Padrao: `Enabled`. |
| sse_algorithm       | string       | Nao         | Algoritmo de criptografia server-side (AES256 ou aws:kms). Padrao: `AES256`. |
| force_destroy       | bool         | Nao         | Permite exclusao do bucket com objetos. Padrao: `false`.                  |
| additional_tags     | map(string)  | Nao         | Tags adicionais aplicadas ao bucket, alem das obrigatorias. Padrao: `{}`. |

## Outputs

| Nome         | Descricao                              |
|--------------|-----------------------------------------|
| bucket_name  | Nome do bucket S3 criado.               |
| bucket_arn   | ARN do bucket S3 criado.                |
| bucket_id    | Identificador (id) do bucket S3 criado. |

## Exemplo de uso

```hcl
module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"
  region      = "us-east-1"

  versioning_status = "Enabled"
  sse_algorithm     = "AES256"

  additional_tags = {
    Team = "platform"
  }
}
```
