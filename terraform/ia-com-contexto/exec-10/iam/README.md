1. Visao geral do recurso
Este template provisiona uma IAM Policy padronizada, seguindo as normas organizacionais de nomenclatura, tags e seguranca. A policy:
- segue o padrao de nome: <environment>-<system>-iam-<policy_name>;
- aplica as tags obrigatorias do contexto organizacional;
- contem apenas Effect: Allow para as acoes e recursos fornecidos por variavel;
- proibe a combinacao Action: "*" com Resource: "*" na mesma statement;
- nao anexa policies administrativas gerenciadas.

2. Tabela de variaveis
| Nome              | Tipo          | Obrigatoria | Descricao |
|-------------------|---------------|-------------|-----------|
| environment       | string        | Sim         | Ambiente alvo: dev, hml ou prd. |
| system            | string        | Sim         | Identificador do sistema/projeto (minusculo, alfanumerico e hifens). |
| region            | string        | Sim         | Regiao AWS do provider (ex.: us-east-1). |
| policy_name       | string        | Sim         | Finalidade da policy, usada no nome final. |
| allowed_actions   | list(string)  | Sim         | Acoes permitidas (Effect: Allow). Nao combinar Action: "*" com Resource: "*". |
| allowed_resources | list(string)  | Sim         | ARNs dos recursos permitidos (Effect: Allow). Nao combinar Action: "*" com Resource: "*". |
| policy_description| string        | Nao         | Descricao opcional da policy (padrao calculado). |
| policy_path       | string        | Nao         | Caminho (path) da policy, padrao "/". |
| additional_tags   | map(string)   | Nao         | Tags adicionais. Tags obrigatorias sao aplicadas automaticamente. |

3. Tabela de outputs
| Nome        | Descricao |
|-------------|-----------|
| policy_name | Nome da IAM Policy criada. |
| policy_arn  | ARN da IAM Policy criada. |
| policy_id   | ID da IAM Policy criada. |

4. Exemplo de uso do modulo/recurso
module "iam_policy" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"
  policy_description= "Permite leitura em buckets S3 especificos"
  policy_path       = "/"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::meu-bucket-logs",
    "arn:aws:s3:::meu-bucket-logs/*"
  ]

  additional_tags = {
    Squad = "platform"
  }
}
