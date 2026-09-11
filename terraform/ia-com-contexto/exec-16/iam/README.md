1. Visão geral do recurso
Este template provisiona uma AWS IAM Policy seguindo o padrão organizacional:
- Nome: <environment>-<system>-iam-<policy_name>
- Princípio do menor privilégio: apenas ações e recursos informados são permitidos (Effect: Allow).
- Controle de segurança: validação que proíbe a combinação Action "*" com Resource "*".
- Não anexa nem replica o efeito de políticas administrativas gerenciadas.
- Aplica as tags obrigatórias do contexto organizacional, além de permitir tags adicionais.

2. Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição                                                                 |
|-------------------|--------------|-------------|---------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente alvo (dev, hml, prd).                                            |
| system            | string       | Sim         | Identificador do sistema/produto (minúsculas, números e hífens).          |
| region            | string       | Sim         | Região AWS para o provider.                                               |
| additional_tags   | map(string)  | Não         | Tags adicionais (as obrigatórias são aplicadas e prevalecem).             |
| policy_name       | string       | Sim         | Finalidade da policy, compõe o nome final do recurso.                     |
| allowed_actions   | list(string) | Sim         | Lista de ações IAM permitidas (Effect: Allow).                            |
| allowed_resources | list(string) | Sim         | Lista de ARNs de recursos permitidos (Effect: Allow).                     |
| description       | string       | Não         | Descrição da IAM Policy.                                                  |

3. Tabela de outputs
| Nome         | Descrição                          |
|--------------|------------------------------------|
| policy_name  | Nome da IAM Policy criada.         |
| policy_arn   | ARN da IAM Policy criada.          |
| policy_id    | ID da IAM Policy criada.           |

4. Exemplo de uso do módulo/recurso
module "iam_policy" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "sa-east-1"
  policy_name       = "readonly"
  description       = "Policy de leitura restrita a S3 do projeto TCC"
  allowed_actions   = [
    "s3:GetObject",
    "s3:ListBucket"
  ]
  allowed_resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*"
  ]

  additional_tags = {
    Application = "catalog"
    Squad       = "core"
  }
}
