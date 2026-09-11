Visao geral do recurso
- Este template provisiona um bucket Amazon S3 seguindo as diretrizes organizacionais:
  - Nome no padrao <ambiente>-<sistema>-<recurso>-<finalidade>, onde recurso = s3.
  - Bloqueio completo de acesso publico (quatro flags).
  - Criptografia server-side habilitada com SSE-S3 (AES256).
  - Policy que nega qualquer requisicao sem aws:SecureTransport.
  - Versionamento configuravel (padrao Enabled).
  - Tags obrigatorias aplicadas com possibilidade de tags adicionais.

Tabela de variaveis
- environment (string) | obrigatoria: sim | Ambiente alvo. Valores: dev, hml, prd.
- system (string) | obrigatoria: sim | Identificador do sistema (minusculo, numeros e hifens).
- purpose (string) | obrigatoria: sim | Finalidade do bucket (minusculo, numeros e hifens).
- region (string) | obrigatoria: sim | Regiao AWS para o provider.
- additional_tags (map(string)) | obrigatoria: nao | Tags adicionais a serem mescladas.
- versioning_status (string) | obrigatoria: nao | Estado do versionamento (Enabled ou Suspended). Padrao: Enabled.
- force_destroy (bool) | obrigatoria: nao | Permite destruir o bucket mesmo com objetos. Padrao: false.

Tabela de outputs
- bucket_name | Nome do bucket S3 criado.
- bucket_arn | ARN do bucket S3 criado.
- bucket_id | ID do bucket S3 criado (igual ao nome).

Exemplo de uso
- Exemplo minimo de uso como modulo local:
module "s3_bucket" {
  source           = "./"
  environment      = "dev"
  system           = "tcc"
  purpose          = "logs"
  region           = "us-east-1"
  versioning_status = "Enabled"
  additional_tags  = {
    Application = "demo-app"
  }
}

- Variaveis podem ser definidas via terraform.tfvars:
environment      = "hml"
system           = "tcc"
purpose          = "artifacts"
region           = "us-east-1"
versioning_status = "Enabled"
additional_tags = {
  Application = "ci-cd"
  Squad       = "platform"
}
