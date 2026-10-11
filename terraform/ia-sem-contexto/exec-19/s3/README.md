# Blueprint Terraform — Bucket Amazon S3

## Descricao

Modulo Terraform para provisionar um bucket Amazon S3 com configuracoes seguras por padrao:

- Bloqueio total de acesso publico (ACLs e policies publicas negadas).
- Criptografia server-side habilitada (AES256 por padrao, com suporte opcional a SSE-KMS).
- Versionamento configuravel via variavel.
- Aplicacao de tags customizaveis.
- Outputs com identificadores e metadados relevantes do bucket.

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.3.0 |
| aws | >= 5.0 |

## Uso

```
module "s3_bucket" {
  source = "./"

  bucket_name        = "meu-bucket-exemplo-12345"
  aws_region         = "us-east-1"
  versioning_enabled = true
  sse_algorithm      = "AES256"

  tags = {
    Environment = "production"
    Owner       = "team-infra"
  }
}
```

### Usando criptografia com KMS

```
module "s3_bucket" {
  source = "./"

  bucket_name   = "meu-bucket-exemplo-12345"
  sse_algorithm = "aws:kms"
  kms_key_id    = "arn:aws:kms:us-east-1:111111111111:key/chave-exemplo"
}
```

## Inputs

| Nome | Descricao | Tipo | Padrao | Obrigatorio |
|------|-----------|------|--------|-------------|
| aws_region | Regiao AWS onde o bucket sera criado | string | "us-east-1" | nao |
| bucket_name | Nome globalmente unico do bucket S3 | string | n/a | sim |
| versioning_enabled | Habilita (true) ou suspende (false) o versionamento | bool | true | nao |
| sse_algorithm | Algoritmo de criptografia: AES256 ou aws:kms | string | "AES256" | nao |
| kms_key_id | ARN/ID da chave KMS (usado somente com aws:kms) | string | null | nao |
| force_destroy | Permite destruir o bucket mesmo com objetos | bool | false | nao |
| tags | Tags adicionais aplicadas ao bucket | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| bucket_id | Nome do bucket criado |
| bucket_arn | ARN do bucket criado |
| bucket_regional_domain_name | Dominio regional do bucket |
| versioning_status | Status atual do versionamento |
| sse_algorithm | Algoritmo de criptografia aplicado |

## Seguranca

- O bucket nao permite acesso publico (ACLs e policies publicas bloqueadas em todas as camadas).
- A criptografia server-side e obrigatoria para todos os objetos gravados no bucket.
- Nenhum valor sensivel ou credencial e definido neste modulo; a autenticacao AWS deve ser configurada externamente (variaveis de ambiente, perfil ou role).

## Validacao

```
terraform init -backend=false
terraform validate
terraform fmt -check
```
