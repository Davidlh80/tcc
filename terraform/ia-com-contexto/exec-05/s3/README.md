Visão geral do recurso
- Este template provisiona um bucket Amazon S3 seguindo os padrões organizacionais:
  - Nome no formato <ambiente>-<sistema>-<recurso>-<finalidade>, onde recurso = s3.
  - Bloqueio completo de acesso público (quatro flags do Public Access Block).
  - Criptografia server-side habilitada com SSE-S3 (AES256).
  - Política que nega qualquer requisição sem aws:SecureTransport (força HTTPS).
  - Versionamento configurável por variável, com padrão Enabled.
  - Tags obrigatórias aplicadas e possibilidade de tags adicionais.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome               | Tipo         | Obrigatória | Descrição                                                                 |
|--------------------|--------------|-------------|---------------------------------------------------------------------------|
| environment        | string       | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd.                   |
| system             | string       | Sim         | Nome do sistema (minúsculo, números e hífens).                            |
| region             | string       | Sim         | Região AWS (ex.: us-east-1).                                              |
| purpose            | string       | Sim         | Finalidade do recurso (segmento final do nome do bucket).                 |
| versioning_enabled | bool         | Não         | Habilita (true) ou suspende (false) o versionamento. Padrão: true.        |
| force_destroy      | bool         | Não         | Permite destruir o bucket com objetos. Padrão: false.                     |
| sse_algorithm      | string       | Não         | Algoritmo SSE. Política exige AES256 (SSE-S3). Padrão: AES256.            |
| additional_tags    | map(string)  | Não         | Tags adicionais. Tags obrigatórias sempre prevalecem.                     |

Tabela de outputs (nome, descrição)
| Nome         | Descrição                         |
|--------------|-----------------------------------|
| bucket_name  | Nome do bucket S3 criado.         |
| bucket_arn   | ARN do bucket S3 criado.          |
| bucket_id    | ID do bucket S3 (igual ao nome).  |

Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment        = "dev"
  system             = "tcc"
  region             = "us-east-1"
  purpose            = "logs"
  versioning_enabled = true
  force_destroy      = false
  sse_algorithm      = "AES256"

  additional_tags = {
    Application = "observability"
    Team        = "platform"
  }
}

output "example_bucket_name" {
  value = module.s3_bucket.bucket_name
}
