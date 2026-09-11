Visão geral do recurso
Este template cria uma IAM Policy seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-iam-<policy_name>
- Restrições de segurança:
  - Proíbe a combinação Action="*" com Resource="*" na mesma statement.
  - Restringe Effect: Allow apenas às ações e recursos informados por variável.
  - Não anexa policies gerenciadas administrativas.
- Aplica tags obrigatórias e permite a inclusão de tags adicionais.

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment | string | sim | Ambiente alvo: dev, hml ou prd.
- system | string | sim | Identificador do sistema (minúsculas, números e hífens).
- region | string | sim | Região AWS (ex.: us-east-1).
- additional_tags | map(string) | não | Tags adicionais; as tags obrigatórias são sempre aplicadas.
- policy_name | string | sim | Nome/finalidade da policy para composição do nome do recurso.
- allowed_actions | list(string) | sim | Ações permitidas (ex.: ["s3:GetObject", "s3:ListBucket"]); não pode combinar "*" com Resource "*".
- allowed_resources | list(string) | sim | ARNs dos recursos permitidos (ex.: ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]).
- policy_description | string | não | Descrição da policy; se vazio, será gerada automaticamente.
- policy_path | string | não | Caminho da policy (ex.: "/" ou "/app/"); padrão "/".

Tabela de outputs (nome, descrição)
- policy_name | Nome completo da IAM Policy criada.
- policy_arn | ARN da IAM Policy criada.
- policy_id | ID da IAM Policy criada.

Exemplo de uso do módulo/recurso
module "iam_policy" {
  source          = "./"
  environment     = "dev"
  system          = "tcc"
  region          = "us-east-1"

  policy_name        = "readonly"
  allowed_actions    = ["s3:GetObject", "s3:ListBucket"]
  allowed_resources  = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  additional_tags = {
    Team = "platform"
  }
}
