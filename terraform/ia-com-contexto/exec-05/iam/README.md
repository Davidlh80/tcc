1. Visão geral do recurso
Este template provisiona uma IAM Policy seguindo os padrões organizacionais:
- Nomenclatura: <ambiente>-<sistema>-iam-<finalidade> (ex.: prd-tcc-iam-readonly)
- Tags obrigatórias aplicadas automaticamente e mescladas com additional_tags
- Princípio do menor privilégio: somente as ações e recursos informados são permitidos
- Controle de segurança: proíbe a combinação Action "*" com Resource "*" na mesma policy
- Não anexa policies gerenciadas administrativas

2. Tabela de variáveis
| Nome              | Tipo         | Obrigatória | Descrição                                                                 |
|-------------------|--------------|-------------|---------------------------------------------------------------------------|
| environment       | string       | Sim         | Ambiente de deploy (dev, hml, prd).                                      |
| system            | string       | Sim         | Identificador do sistema (minúsculas, números e hifens).                 |
| region            | string       | Sim         | Região AWS para o provider (ex.: sa-east-1).                              |
| additional_tags   | map(string)  | Não         | Tags adicionais para mesclar às tags organizacionais obrigatórias.       |
| policy_name       | string       | Sim         | Finalidade da policy (compõe o nome, ex.: readonly).                      |
| allowed_actions   | list(string) | Sim         | Ações IAM permitidas na policy (ex.: ["s3:GetObject"]).                   |
| allowed_resources | list(string) | Sim         | ARNs de recursos aos quais as ações serão permitidas.                     |
| policy_description| string       | Não         | Descrição da IAM Policy.                                                  |
| policy_path       | string       | Não         | Caminho/path da policy no IAM (ex.: "/" ou "/app/").                      |

3. Tabela de outputs
| Nome        | Descrição                              |
|-------------|----------------------------------------|
| policy_name | Nome completo da IAM Policy criada.    |
| policy_arn  | ARN da IAM Policy criada.              |
| policy_id   | ID interno da IAM Policy criada.       |

4. Exemplo de uso do módulo/recurso
module "iam_policy" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "sa-east-1"
  policy_name       = "s3-readonly"
  policy_description= "Permissões de leitura em bucket S3 específico"
  policy_path       = "/app/"

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
