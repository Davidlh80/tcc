# S3 Bucket

## 1. Visao geral

Este template provisiona um bucket Amazon S3 seguindo os padroes internos de nomenclatura, tags e seguranca da organizacao. O bucket e criado com as quatro flags do Public Access Block bloqueadas, criptografia server-side com AES256, negacao explicita de requisicoes sem `aws:SecureTransport` via bucket policy, e versionamento configuravel por variavel (padrao `Enabled`).

O nome do bucket segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `dev-tcc-s3-logs`.

## 2. Variaveis

| Nome                | Tipo         | Obrigatoria | Descricao                                                                 |
|---------------------|--------------|-------------|----------------------------------------------------------------------------|
| environment          | string       | Sim         | Ambiente de implantacao. Valores permitidos: dev, hml, prd.               |
| system               | string       | Sim         | Nome do sistema ou aplicacao, usado na composicao do nome do bucket.       |
| region               | string       | Nao         | Regiao AWS onde o bucket sera criado. Padrao: us-east-1.                  |
| purpose              | string       | Sim         | Finalidade do bucket, usada na composicao do nome (ex.: logs, artifacts). |
| versioning_status    | string       | Nao         | Status do versionamento (Enabled ou Suspended). Padrao: Enabled.          |
| additional_tags      | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao.            |

## 3. Outputs

| Nome         | Descricao                          |
|--------------|-------------------------------------|
| bucket_name  | Nome do bucket S3 criado.           |
| bucket_arn   | ARN do bucket S3 criado.            |
| bucket_id    | ID do bucket S3 criado.             |

## 4. Exemplo de uso

module "s3_logs" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  purpose     = "logs"
  region      = "us-east-1"

  versioning_status = "Enabled"

  additional_tags = {
    Squad = "plataforma"
  }
}
