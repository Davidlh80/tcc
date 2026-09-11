Visão geral do recurso
- Este template provisiona uma IAM Policy seguindo o padrão organizacional de nomenclatura <ambiente>-<sistema>-<recurso>-<finalidade>, resultando em nomes como dev-tcc-iam-readonly.
- Segurança:
  - Proíbe a criação de statements com Action "*" combinada com Resource "*".
  - Restringe Effect: Allow apenas às ações e recursos informados via variáveis.
  - Não anexa policies gerenciadas administrativas (ex.: AdministratorAccess).
- Governança:
  - Aplica tags obrigatórias (Project, Environment, ManagedBy, Owner, CostCenter) e permite tags adicionais.
  - Usa variáveis obrigatórias padronizadas: environment, system, region, additional_tags e a variável específica do recurso: policy_name.

Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição |
|-------------------|--------------|-------------|-----------|
| environment       | string       | Sim         | Ambiente alvo do recurso. Valores permitidos: dev, hml, prd. |
| system            | string       | Sim         | Identificador do sistema/aplicação (minúsculas, números e hífens). |
| region            | string       | Sim         | Região AWS para o provider (ex.: us-east-1). |
| additional_tags   | map(string)  | Não         | Tags adicionais a serem aplicadas. Tags internas obrigatórias prevalecem. |
| policy_name       | string       | Sim         | Finalidade da policy, compõe o nome: <environment>-<system>-iam-<policy_name>. |
| allowed_actions   | list(string) | Sim         | Lista de ações IAM a permitir (ex.: ["s3:GetObject"]). |
| allowed_resources | list(string) | Sim         | Lista de ARNs de recursos permitidos (ex.: ["arn:aws:s3:::bucket/*"]). |
| policy_description| string       | Não         | Descrição da policy. Padrão define menor privilégio. |
| path              | string       | Não         | Caminho (path) da policy (padrão "/"). |

Tabela de outputs
| Nome         | Descrição |
|--------------|-----------|
| policy_name  | Nome final da IAM Policy criada. |
| policy_arn   | ARN da IAM Policy. |
| policy_id    | ID interno da IAM Policy. |

Exemplo de uso do módulo/recurso
module "iam_policy" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"

  allowed_actions   = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  policy_description = "Permite leitura em um bucket S3 específico."
  path               = "/app/"

  additional_tags = {
    Squad = "core"
  }
}

Notas
- A validação interna impede a combinação Action "*" e Resource "*" na mesma statement.
- Siga o princípio do menor privilégio ao definir allowed_actions e allowed_resources para não replicar efeitos de policies administrativas.
