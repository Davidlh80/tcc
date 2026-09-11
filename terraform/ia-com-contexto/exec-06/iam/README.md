1. Visão geral do recurso
Este template cria uma IAM Policy gerenciada, nomeada segundo o padrão <ambiente>-<sistema>-<recurso>-<finalidade>, aplicando as tags organizacionais obrigatórias. A policy é construída seguindo o princípio do menor privilégio, permitindo apenas as ações e recursos explicitamente informados via variáveis.
Controles de segurança:
- Proíbe statement com Action "*" combinado com Resource "*".
- Restringe Effect: Allow apenas às ações (permitted_actions) e recursos (permitted_resources) definidos por variável.
- Não anexa nem replica policies administrativas (ex.: AdministratorAccess).
- Nomes e tags seguem o contexto organizacional.

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | Sim | Ambiente alvo. Valores permitidos: dev, hml, prd.
- system | string | Sim | Identificador do sistema/produto (minúsculas, números e hífen).
- region | string | Sim | Região AWS (ex.: us-east-1).
- additional_tags | map(string) | Não | Tags adicionais. Chaves obrigatórias do padrão corporativo prevalecem em caso de conflito.
- policy_name | string | Sim | Finalidade da policy, usada na composição do nome (<env>-<system>-iam-<policy_name>).
- policy_description | string | Não | Descrição opcional da policy.
- permitted_actions | list(string) | Sim | Ações a permitir (ex.: ["s3:GetObject", "s3:ListBucket"]).
- permitted_resources | list(string) | Sim | ARNs dos recursos alvo (ex.: ["arn:aws:s3:::bucket", "arn:aws:s3:::bucket/*"]).

3. Tabela de outputs (nome, descrição)
- policy_name | Nome completo da IAM Policy criada.
- policy_arn | ARN da IAM Policy criada.
- policy_id | ID interno da IAM Policy criada.

4. Exemplo de uso do módulo/recurso
module "iam_policy_readonly" {
  source = "."

  region             = "us-east-1"
  environment        = "dev"
  system             = "tcc"
  policy_name        = "readonly"
  policy_description = "Read-only access to a specific S3 bucket for dev-tcc."

  permitted_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  permitted_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Squad = "core-platform"
  }
}

Após configurar as variáveis conforme necessário, execute:
- terraform init -backend=false
- terraform validate
- terraform plan
