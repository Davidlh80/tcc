Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nome do recurso: <environment>-<system>-iam-<policy_name>
- Tags obrigatórias aplicadas ao recurso
- Princípio do menor privilégio: apenas ações e recursos explicitamente informados são permitidos
- Proibido combinar Action "*" com Resource "*" em uma mesma statement
- Não anexa policies administrativas gerenciadas

Tabela de variáveis
- environment (string) [Obrigatória]: Ambiente alvo. Valores permitidos: dev, hml, prd.
- system (string) [Obrigatória]: Nome do sistema (ex.: tcc). Somente [a-z0-9-].
- region (string) [Obrigatória]: Região AWS (ex.: us-east-1).
- additional_tags (map(string)) [Opcional]: Tags adicionais a aplicar no recurso.
- policy_name (string) [Obrigatória]: Finalidade da policy (ex.: readonly). Comporá o nome final.
- allowed_actions (list(string)) [Obrigatória]: Ações explícitas que serão permitidas. Ex.: ["s3:GetObject", "s3:ListBucket"]. Não use "*" junto de Resource "*".
- allowed_resources (list(string)) [Obrigatória]: ARNs de recursos para os quais as ações serão permitidas. Ex.: ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"].
- description (string) [Opcional]: Descrição da policy. Padrão: "IAM policy managed by Terraform."

Tabela de outputs
- policy_name: Nome da policy IAM criada.
- policy_arn: ARN da policy IAM criada.
- policy_id: ID único da policy IAM criada.

Exemplo de uso
module "iam_policy" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"
  description       = "Read-only access to specific S3 resources"
  allowed_actions   = ["s3:GetObject", "s3:ListBucket"]
  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Squad = "core-platform"
  }
}
