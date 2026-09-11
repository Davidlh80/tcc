1. Visão geral do recurso
Este template provisiona uma IAM Policy seguindo os padrões organizacionais:
- Nome no formato <environment>-<system>-iam-<policy_name>.
- Tags obrigatórias aplicadas a todos os recursos que suportam tags.
- Princípio do menor privilégio: a policy concede apenas as ações e recursos explicitamente informados por variável.
- Controles de segurança:
  - Proíbe a combinação Action="*" com Resource="*" em uma mesma statement.
  - Não anexa policies gerenciadas administrativas nem replica seus efeitos.
- Compatível com terraform fmt, terraform init -backend=false e terraform validate.

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | Sim | Ambiente alvo: dev, hml ou prd.
- system | string | Sim | Nome do sistema/aplicação (minúsculas, números e hifens).
- region | string | Sim | Região AWS para o provider (ex.: sa-east-1).
- additional_tags | map(string) | Não | Tags adicionais. Chaves reservadas (Project, Environment, ManagedBy, Owner, CostCenter) são ignoradas.
- policy_name | string | Sim | Finalidade/nome curto da policy. Compoe o nome final <environment>-<system>-iam-<policy_name>.
- policy_description | string | Não | Descrição da policy. Padrão seguro.
- path | string | Não | Caminho da policy (ex.: / ou /application/). Padrão: "/".
- allowed_actions | set(string) | Sim | Ações AWS permitidas (Effect: Allow). Evite privilégios amplos.
- allowed_resources | set(string) | Sim | ARNs de recursos permitidos (Effect: Allow). Pode ser "*" apenas se allowed_actions não for "*".

3. Tabela de outputs (nome, descrição)
- policy_name | Nome da IAM Policy criada.
- policy_arn | ARN da IAM Policy criada.
- policy_id | ID da IAM Policy criada (geralmente o ARN).

4. Exemplo de uso do módulo/recurso
module "iam_policy_readonly" {
  source = "./"

  environment      = "dev"
  system           = "tcc"
  region           = "sa-east-1"
  policy_name      = "readonly"
  policy_description = "Permite leitura em S3 e CloudWatch Logs para o sistema TCC em dev."

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket",
    "logs:DescribeLogGroups",
    "logs:DescribeLogStreams",
    "logs:GetLogEvents"
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*",
    "arn:aws:logs:sa-east-1:123456789012:log-group:/aws/lambda/tcc-*",
    "arn:aws:logs:sa-east-1:123456789012:log-group:/aws/lambda/tcc-*:*"
  ]

  additional_tags = {
    Squad = "platform"
  }
}
