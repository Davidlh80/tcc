1. Visão geral do recurso
Este template provisiona um bucket Amazon S3 seguindo os padrões organizacionais:
- Nomenclatura: <environment>-<system>-s3-<purpose>
- Segurança: bloqueio total de acesso público (quatro flags), criptografia server-side SSE-S3 (AES256) habilitada por padrão e bucket policy que nega tráfego sem aws:SecureTransport.
- Governança: versionamento configurável com padrão Enabled e aplicação das tags obrigatórias.

2. Tabela de variáveis
| Nome               | Tipo         | Obrigatória | Descrição                                                                                 |
|--------------------|--------------|-------------|-------------------------------------------------------------------------------------------|
| environment        | string       | Sim         | Ambiente do recurso. Valores permitidos: dev, hml, prd.                                   |
| system             | string       | Sim         | Identificador do sistema/aplicação (minúsculo, alfanumérico e hífens).                    |
| region             | string       | Sim         | Região AWS onde o bucket será criado (ex.: us-east-1).                                    |
| purpose            | string       | Sim         | Finalidade do recurso (minúsculo, alfanumérico e hífens). Usado na composição do nome.    |
| versioning_enabled | bool         | Não         | Controla o versionamento do bucket. Padrão: true (equivale a Enabled).                    |
| additional_tags    | map(string)  | Não         | Tags adicionais opcionais. Em caso de conflito, as tags obrigatórias prevalecem.         |

3. Tabela de outputs
| Nome         | Descrição                       |
|--------------|----------------------------------|
| bucket_name  | Nome do bucket S3 criado.       |
| bucket_arn   | ARN do bucket S3 criado.        |
| bucket_id    | ID do bucket S3 criado.         |

4. Exemplo de uso do módulo/recurso
module "s3_bucket" {
  source = "./"

  environment        = "dev"
  system             = "tcc"
  region             = "us-east-1"
  purpose            = "logs"
  versioning_enabled = true

  additional_tags = {
    Team = "platform"
  }
}
