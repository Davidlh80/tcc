Visão geral do recurso
Este template provisiona uma AWS IAM Policy gerenciada, nomeada conforme o padrão organizacional <ambiente>-<sistema>-iam-<finalidade>, aplicando as tags obrigatórias. A policy é construída pelo princípio do menor privilégio, permitindo apenas as ações e recursos explicitamente informados via variáveis. É proibida a criação de uma statement que combine Action: "*" com Resource: "*", em conformidade com a diretriz de segurança.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment, string, sim, Ambiente de implantação do recurso. Valores permitidos: dev, hml, prd.
- system, string, sim, Identificador do sistema (componente/aplicação) responsável pelo recurso.
- region, string, sim, Região AWS onde os recursos serão gerenciados (ex.: sa-east-1).
- additional_tags, map(string), não, Mapa de tags adicionais a serem aplicadas ao recurso.
- policy_name, string, sim, Finalidade da policy (usada no padrão de nome: <environment>-<system>-iam-<policy_name>).
- allowed_actions, list(string), sim, Lista de ações explícitas a serem permitidas (ex.: ["s3:GetObject","s3:ListBucket"]).
- allowed_resources, list(string), sim, Lista de ARNs dos recursos aos quais as ações serão permitidas (ex.: ["arn:aws:s3:::meu-bucket","arn:aws:s3:::meu-bucket/*"]). Pode incluir "*".
- policy_description, string, não, Descrição opcional da policy IAM.
- policy_path, string, não, Caminho da policy IAM (ex.: "/" ou "/service-role/").

Tabela de outputs (nome, descrição)
- policy_name, Nome final da IAM Policy criada seguindo o padrão organizacional.
- policy_arn, ARN da IAM Policy criada.
- policy_id, ID exclusivo da IAM Policy criada.

Exemplo de uso do módulo/recurso
module "iam_policy_readonly" {
  source = "."

  environment       = "dev"
  system            = "tcc"
  region            = "sa-east-1"
  policy_name       = "readonly"
  policy_description= "Read-only access to specific S3 bucket"
  policy_path       = "/"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  additional_tags = {
    Squad = "core"
  }
}
