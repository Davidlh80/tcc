# Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nome do recurso: <environment>-<system>-iam-<policy_name>;
- Tags obrigatórias aplicadas a todos os recursos com suporte a tags;
- Segurança de IAM: proíbe a combinação de Action="*" com Resource="*" e restringe Effect: Allow apenas às ações e recursos informados por variável, evitando replicar efeitos administrativos amplos.

# Tabela de variáveis
| Nome              | Tipo          | Obrigatória | Descrição |
|-------------------|---------------|-------------|-----------|
| environment       | string        | Sim         | Ambiente alvo. Valores permitidos: dev, hml, prd. |
| system            | string        | Sim         | Identificador do sistema/aplicação (minúsculo, letras, números e hífens). |
| region            | string        | Sim         | Região AWS onde a policy será gerenciada. |
| additional_tags   | map(string)   | Não         | Tags adicionais a serem aplicadas ao recurso. As tags obrigatórias são sempre aplicadas e prevalecem. |
| policy_name       | string        | Sim         | Finalidade/nome curto da policy (minúsculo, letras, números e hífens). Ex.: readonly, s3-access. |
| allowed_actions   | list(string)  | Sim         | Lista de ações explícitas a serem permitidas (Effect: Allow). Ex.: ["s3:GetObject", "s3:ListBucket"]. |
| allowed_resources | list(string)  | Sim         | Lista de ARNs de recursos a serem permitidos. Ex.: ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]. |
| description       | string        | Não         | Descrição da IAM Policy. Padrão: "IAM policy gerenciada via Terraform seguindo o princípio do menor privilégio." |

# Tabela de outputs
| Nome         | Descrição |
|--------------|-----------|
| policy_name  | Nome final da IAM Policy criada. |
| policy_arn   | ARN da IAM Policy criada. |
| policy_id    | ID da IAM Policy criada. |

# Exemplo de uso do módulo/recurso
module "iam_policy_example" {
  source = "./"

  region      = "us-east-1"
  environment = "dev"
  system      = "tcc"
  policy_name = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::exemplo-bucket",
    "arn:aws:s3:::exemplo-bucket/*"
  ]

  additional_tags = {
    Squad = "platform"
  }

  # Opcional
  description = "Policy de leitura em bucket S3 específico."
}
