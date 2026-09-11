Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nome do recurso: <environment>-<system>-iam-<policy_name>
- Restrições de segurança: proíbe a combinação Action "*" com Resource "*" na mesma statement; permite apenas ações e recursos informados por variável; não anexa policies administrativas.
- Tags obrigatórias aplicadas automaticamente a recursos que suportam tags.

Tabela de variáveis
- environment (string) [obrigatória]: Ambiente de implantação (dev, hml, prd).
- system (string) [obrigatória]: Identificador do sistema/produto (minúsculo, hífens).
- region (string) [obrigatória]: Região AWS para o provider (ex.: us-east-1).
- additional_tags (map(string)) [opcional]: Tags adicionais a serem mescladas; tags obrigatórias prevalecem em caso de conflito.
- policy_name (string) [obrigatória]: Finalidade da policy (compõe o nome <environment>-<system>-iam-<policy_name>).
- allowed_actions (list(string)) [obrigatória]: Ações explícitas a permitir (ex.: ["s3:GetObject", "s3:ListBucket"]).
- allowed_resources (list(string)) [obrigatória]: ARNs de recursos explicitamente permitidos (ex.: ["arn:aws:s3:::bucket", "arn:aws:s3:::bucket/*"]).
- policy_description (string) [opcional]: Descrição da policy IAM.
- policy_path (string) [opcional]: Caminho da policy IAM (inicia com "/").

Tabela de outputs
- policy_name: Nome completo da IAM Policy criada.
- policy_arn: ARN da IAM Policy criada.
- policy_id: ID único da IAM Policy criada.

Exemplo de uso do módulo/recurso
module "iam_policy" {
  source = "."

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"
  policy_description = "Read-only access to specific S3 bucket"
  policy_path       = "/"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Squad = "platform"
  }
}
