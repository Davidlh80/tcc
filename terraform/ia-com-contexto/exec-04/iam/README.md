1. Visão geral do recurso
Este template provisiona uma AWS IAM Policy nomeada segundo o padrão <ambiente>-<sistema>-iam-<finalidade>, aplica as tags organizacionais obrigatórias e segue o princípio do menor privilégio. A policy gerada:
- restringe Effect: Allow apenas às ações e recursos informados por variável;
- proíbe qualquer statement que combine Action: "*" com Resource: "*";
- não anexa nem replica o efeito de policies administrativas gerenciadas.

2. Tabela de variáveis
- environment (string, obrigatória): Ambiente de implantação. Valores permitidos: dev, hml, prd.
- system (string, obrigatória): Nome do sistema/aplicação (minúsculas, números e hifens).
- region (string, obrigatória): Região AWS para o provider.
- additional_tags (map(string), opcional): Tags adicionais. As tags obrigatórias sempre prevalecem em caso de conflito.
- policy_name (string, obrigatória): Nome/purpose da policy (parte final no padrão de nome).
- allowed_actions (list(string), obrigatória): Lista de ações a permitir (ex.: ["s3:GetObject", "s3:ListBucket"]). Não usar "*" em conjunto com Resource "*".
- allowed_resources (list(string), obrigatória): Lista de ARNs de recursos permitidos (ex.: ["arn:aws:s3:::bucket", "arn:aws:s3:::bucket/*"]). Não usar "*" em conjunto com Action "*".
- policy_description (string, opcional): Descrição da IAM Policy.

3. Tabela de outputs
- policy_name: Nome completo da IAM Policy criada.
- policy_arn: ARN da IAM Policy criada.
- policy_id: ID interno da IAM Policy criada.

4. Exemplo de uso do módulo/recurso
module "iam_policy_readonly" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"
  policy_description = "Read-only access to a specific S3 bucket"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::my-team-bucket",
    "arn:aws:s3:::my-team-bucket/*"
  ]

  additional_tags = {
    Squad = "platform"
  }
}
