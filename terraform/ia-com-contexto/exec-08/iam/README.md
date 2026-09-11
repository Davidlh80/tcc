# Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nomenclatura: <ambiente>-<sistema>-iam-<finalidade> (ex.: prd-tcc-iam-readonly);
- Tags obrigatórias aplicadas automaticamente;
- Princípio do menor privilégio: somente as ações e recursos informados são permitidos;
- Bloqueio de combinações perigosas: é proibido criar uma statement com Action "*" e Resource "*" simultaneamente;
- Não anexa policies gerenciadas administrativas e não replica seu efeito.

A policy criada não é anexada a usuários, grupos ou roles por padrão.

# Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição |
|-------------------|--------------|-------------|-----------|
| environment       | string       | Sim         | Ambiente da implantação (dev, hml, prd). |
| system            | string       | Sim         | Nome do sistema/aplicação (minúsculo, números e hífens). |
| region            | string       | Sim         | Região AWS para o provider (ex.: us-east-1). |
| additional_tags   | map(string)  | Não         | Tags adicionais a serem aplicadas (não sobrescrevem as obrigatórias). |
| policy_name       | string       | Sim         | Finalidade da policy para compor o nome (ex.: readonly, s3-access). |
| policy_path       | string       | Não         | Caminho (path) da IAM Policy. Padrão: "/". |
| policy_description| string       | Não         | Descrição da IAM Policy. Padrão: gerada automaticamente. |
| allowed_actions   | list(string) | Sim         | Lista de ações explícitas permitidas (ex.: ["s3:GetObject","s3:ListBucket"]). |
| allowed_resources | list(string) | Sim         | Lista de ARNs de recursos permitidos. |

# Tabela de outputs
| Nome        | Descrição |
|-------------|-----------|
| policy_name | Nome completo da IAM Policy conforme o padrão organizacional. |
| policy_arn  | ARN da IAM Policy criada. |
| policy_id   | ID interno da IAM Policy. |

# Exemplo de uso
module "iam_policy" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"
  policy_description= "Policy de leitura restrita em S3"
  policy_path       = "/"
  allowed_actions   = ["s3:GetObject", "s3:ListBucket"]
  allowed_resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*"
  ]

  additional_tags = {
    Service = "platform"
    Team    = "devops"
  }
}

Observações:
- A combinação Action "*" com Resource "*" é bloqueada pelo template.
- Este módulo apenas cria a policy; o anexo a Users/Groups/Roles deve ser feito separadamente, conforme necessidade e seguindo o princípio de menor privilégio.
