Visão geral do recurso
Este template cria uma IAM Policy com nome padronizado e tags obrigatórias, permitindo apenas as ações e recursos explicitamente informados por variáveis. A blueprint aplica o princípio do menor privilégio e impede a criação de statements com Action "*" combinado com Resource "*", evitando a replicação de políticas administrativas amplas.

Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição |
|-------------------|--------------|-------------|-----------|
| environment       | string       | Sim         | Ambiente alvo (dev, hml, prd). |
| system            | string       | Sim         | Nome do sistema/aplicação (minúsculas, números e hífens). |
| region            | string       | Sim         | Região AWS para o provider (ex.: us-east-1). |
| additional_tags   | map(string)  | Não         | Tags adicionais a serem aplicadas (as obrigatórias têm precedência). |
| policy_name       | string       | Sim         | Finalidade da policy; compõe o nome seguindo o padrão <environment>-<system>-iam-<policy_name>. |
| policy_description| string       | Não         | Descrição da IAM Policy. Padrão seguro e genérico. |
| policy_path       | string       | Não         | Caminho (path) da policy. Deve iniciar e terminar com "/". Padrão: "/". |
| allowed_actions   | list(string) | Sim         | Ações a serem explicitamente permitidas (ex.: ["s3:GetObject"]). |
| allowed_resources | list(string) | Sim         | ARNs dos recursos explicitamente permitidos (ex.: ["arn:aws:s3:::example/*"]). |

Tabela de outputs
| Nome        | Descrição |
|-------------|-----------|
| policy_name | Nome efetivo da IAM Policy criada. |
| policy_arn  | ARN da IAM Policy criada. |
| policy_id   | ID interno da IAM Policy criada. |

Exemplo de uso do módulo/recurso
module "iam_policy_readonly_s3" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "s3-readonly"
  policy_description= "Permite leitura em objetos de um bucket S3 específico."
  policy_path       = "/"
  allowed_actions   = [
    "s3:GetObject",
    "s3:ListBucket"
  ]
  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Squad = "core-platform"
  }
}
