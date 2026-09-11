1. Visão geral do recurso
Este template provisiona uma AWS IAM Policy seguindo os padrões organizacionais:
- Nomenclatura: <environment>-<system>-iam-<policy_name> (ex.: prd-tcc-iam-readonly).
- Ambientes permitidos: dev, hml, prd.
- Tags obrigatórias aplicadas automaticamente: Project, Environment, ManagedBy, Owner, CostCenter.
- Segurança IAM:
  - Proíbe explicitamente a combinação de Action: "*" com Resource: "*".
  - Restringe Effect: Allow somente às actions e aos resources informados via variáveis.
  - Não replica nem anexa policies administrativas gerenciadas (ex.: AdministratorAccess).

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo          | Obrigatória | Descrição                                                                                 |
|-------------------|---------------|-------------|-------------------------------------------------------------------------------------------|
| environment       | string        | Sim         | Ambiente alvo: dev, hml, prd.                                                             |
| system            | string        | Sim         | Identificador do sistema (ex.: tcc). Somente [a-z0-9-].                                   |
| region            | string        | Sim         | Região AWS (ex.: us-east-1).                                                              |
| additional_tags   | map(string)   | Não         | Tags adicionais a serem mescladas às tags obrigatórias.                                   |
| policy_name       | string        | Sim         | Nome lógico/finalidade da policy (ex.: readonly).                                         |
| allowed_actions   | list(string)  | Sim         | Lista de actions permitidas (ex.: ["s3:GetObject", "s3:ListBucket"]).                     |
| allowed_resources | list(string)  | Sim         | Lista de ARNs de recursos permitidos ou "*" quando aplicável.                             |
| policy_description| string        | Não         | Descrição da IAM Policy. Default: "IAM policy gerenciada por Terraform...".               |
| policy_path       | string        | Não         | Caminho da policy. Deve iniciar e terminar com '/'. Default: "/".                         |

3. Tabela de outputs (nome, descrição)
| Nome         | Descrição                            |
|--------------|--------------------------------------|
| policy_name  | Nome completo da IAM Policy criada.  |
| policy_arn   | ARN da IAM Policy criada.            |
| policy_id    | ID da IAM Policy criada.             |

4. Exemplo de uso do módulo/recurso
module "iam_policy" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"

  policy_name = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Team = "platform"
  }
}
