1. Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-iam-<policy_name>
- Princípio do menor privilégio: apenas as ações e recursos explicitados por variável são permitidos
- Controle de segurança: bloqueia explicitamente a combinação Action="*" com Resource="*" na mesma statement
- Tags obrigatórias aplicadas automaticamente, com opção de adicionar tags extras

2. Tabela de variáveis
| Nome                  | Tipo          | Obrigatória | Descrição |
|-----------------------|---------------|-------------|-----------|
| environment           | string        | Sim         | Ambiente alvo. Valores permitidos: dev, hml, prd. |
| system                | string        | Sim         | Identificador do sistema (minúsculas, números e hífens). |
| region                | string        | Sim         | Região AWS para o provider (ex.: us-east-1). |
| additional_tags       | map(string)   | Não         | Tags adicionais. As tags obrigatórias têm precedência. |
| policy_name           | string        | Sim         | Finalidade da policy (segmento final do nome), ex.: readonly. |
| allowed_actions       | list(string)  | Sim         | Ações IAM a permitir, ex.: ["s3:GetObject","s3:ListBucket"]. |
| allowed_resource_arns | list(string)  | Sim         | ARNs de recursos a permitir. Pode conter "*" desde que as ações não sejam "*". |
| policy_description    | string        | Não         | Descrição amigável da IAM Policy. |

3. Tabela de outputs
| Nome         | Descrição |
|--------------|-----------|
| policy_name  | Nome completo da IAM Policy criada. |
| policy_arn   | ARN da IAM Policy criada. |
| policy_id    | ID da IAM Policy criada. |

4. Exemplo de uso do módulo/recurso
module "iam_policy" {
  source = "./"

  environment           = "dev"
  system                = "tcc"
  region                = "us-east-1"
  policy_name           = "readonly"
  policy_description    = "Acesso somente leitura a um bucket S3 específico"
  allowed_actions       = ["s3:GetObject", "s3:ListBucket"]
  allowed_resource_arns = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]
  additional_tags = {
    Team = "platform"
  }
}
