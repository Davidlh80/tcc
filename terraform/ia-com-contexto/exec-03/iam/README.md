1. Visão geral do recurso
Este template provisiona uma AWS IAM Policy seguindo os padrões organizacionais:
- Nomenclatura: <environment>-<system>-iam-<policy_name>
- Princípio do menor privilégio por padrão
- Impede a criação de uma statement que combine Action:"*" com Resource:"*"
- Não anexa policies administrativas gerenciadas
- Aplica as tags obrigatórias do contexto organizacional

2. Tabela de variáveis (nome | tipo | obrigatória | descrição)
- environment | string | sim | Ambiente alvo (dev, hml, prd).
- system | string | sim | Identificador do sistema/produto (minúsculas, números e hifens).
- region | string | sim | Região AWS onde o provider irá operar (ex.: us-east-1).
- policy_name | string | sim | Finalidade da policy, usada na composição do nome.
- allowed_actions | list(string) | sim | Ações IAM a permitir (Effect: Allow).
- allowed_resources | list(string) | sim | ARNs de recursos aos quais as ações serão permitidas.
- policy_path | string | não | Caminho da policy IAM; padrão "/"; deve iniciar e terminar com "/".
- policy_description | string | não | Descrição da policy IAM.
- additional_tags | map(string) | não | Tags adicionais; não podem sobrescrever as obrigatórias.

3. Tabela de outputs (nome | descrição)
- policy_name | Nome da IAM Policy criada.
- policy_arn | ARN da IAM Policy criada.
- policy_id | ID da IAM Policy criada.

4. Exemplo de uso do módulo/recurso
module "iam_policy" {
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
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Application = "demo"
  }
}

Após aplicar, utilize os outputs para referenciar a policy criada.
