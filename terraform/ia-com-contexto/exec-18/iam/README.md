1. Visão geral do recurso
Este template provisiona uma IAM Policy seguindo os padrões organizacionais:
- Nomenclatura: <environment>-<system>-iam-<policy_name>
- Tags obrigatórias aplicadas a todos os recursos com suporte
- Segurança IAM:
  - Proíbe a criação de uma statement que combine Action:"*" e Resource:"*"
  - Restringe Effect: Allow apenas às ações e recursos informados por variável
  - Evita replicar efeitos de políticas administrativas

2. Tabela de variáveis
| Nome              | Tipo                                                                 | Obrigatória | Descrição                                                                                                 |
|-------------------|----------------------------------------------------------------------|-------------|-------------------------------------------------------------------------------------------------------------|
| environment       | string                                                               | Sim         | Ambiente alvo (dev, hml, prd).                                                                             |
| system            | string                                                               | Sim         | Identificador do sistema/aplicação (minúsculo, números e hífens).                                          |
| region            | string                                                               | Sim         | Região AWS para o provider.                                                                                |
| additional_tags   | map(string)                                                          | Não         | Tags adicionais a serem aplicadas. Tags obrigatórias são sempre mantidas.                                  |
| policy_name       | string                                                               | Sim         | Finalidade da policy (parte final do nome). Ex.: readonly, s3-access.                                      |
| allowed_actions   | list(string)                                                         | Sim         | Ações AWS permitidas (ex.: ["s3:GetObject", "s3:ListBucket"]).                                             |
| allowed_resources | list(string)                                                         | Sim         | ARNs dos recursos permitidos. Pode incluir "*", desde que não combine com Action:"*".                      |
| policy_description| string                                                               | Não         | Descrição da IAM Policy.                                                                                   |
| policy_path       | string                                                               | Não         | Caminho da policy (deve iniciar e terminar com "/").                                                       |
| conditions        | list(object({ test=string, variable=string, values=list(string) }))  | Não         | Condições opcionais aplicadas à statement Allow.                                                           |

3. Tabela de outputs
| Nome        | Descrição                          |
|-------------|------------------------------------|
| policy_name | Nome da IAM Policy criada.         |
| policy_arn  | ARN da IAM Policy criada.          |
| policy_id   | ID interno da IAM Policy criada.   |

4. Exemplo de uso do módulo/recurso
module "iam_policy_readonly" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"
  policy_name       = "readonly"
  policy_description= "Readonly access to specific S3 bucket paths"
  policy_path       = "/app/"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/path/*"
  ]

  conditions = [
    {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  ]

  additional_tags = {
    Application = "example"
    Team        = "platform"
  }
}
