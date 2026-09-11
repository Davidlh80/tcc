Visão geral do recurso
Este template cria uma IAM Policy gerenciada seguindo o padrão de nomenclatura <environment>-<system>-iam-<policy_name> e as boas práticas organizacionais. A policy:
- Proíbe a combinação de Action "*" com Resource "*" na mesma statement (pré-condição de recurso).
- Restringe Effect: Allow apenas às ações e recursos informados por variável (princípio do menor privilégio).
- Aplica as tags obrigatórias do contexto organizacional.
- Não anexa policies gerenciadas administrativas nem replica seus efeitos.

Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição |
|-------------------|--------------|-------------|-----------|
| environment       | string       | Sim         | Ambiente alvo: dev, hml ou prd. |
| system            | string       | Sim         | Identificador do sistema (ex.: tcc). Somente [a-z0-9-]. |
| region            | string       | Sim         | Região AWS para o provider (ex.: sa-east-1). |
| additional_tags   | map(string)  | Não         | Tags adicionais. Tags obrigatórias prevalecem em caso de conflito. |
| policy_name       | string       | Sim         | Finalidade da policy. Compoe o nome como <environment>-<system>-iam-<policy_name>. |
| allowed_actions   | list(string) | Sim         | Ações IAM explicitamente permitidas. |
| allowed_resources | list(string) | Sim         | ARNs dos recursos explicitamente permitidos. Não combine Resource "*" com Action "*" na mesma statement. |
| policy_description| string       | Não         | Descrição opcional da policy. |
| path              | string       | Não         | Caminho da policy (padrão "/"). |

Tabela de outputs
| Nome        | Descrição |
|-------------|-----------|
| policy_name | Nome completo da IAM Policy criada. |
| policy_arn  | ARN da IAM Policy criada. |
| policy_id   | ID interno da IAM Policy criada. |

Exemplo de uso do módulo/recurso
module "iam_policy_readonly_s3" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "sa-east-1"
  policy_name       = "s3-readonly"
  allowed_actions   = [
    "s3:GetObject",
    "s3:ListBucket"
  ]
  allowed_resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*"
  ]

  additional_tags = {
    Application = "demo"
  }
}
