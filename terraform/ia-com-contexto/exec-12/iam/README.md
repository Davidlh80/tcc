Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-iam-<policy_name>
- Princípio do menor privilégio: somente ações e recursos explicitamente informados são permitidos
- Controle de segurança: é proibida qualquer statement que combine Action "*" com Resource "*"
- Tags obrigatórias são aplicadas automaticamente, com possibilidade de adicionar tags extras

Tabela de variáveis (nome, tipo, obrigatória, descrição)
- region (string) [obrigatória]: Região AWS onde a policy será gerenciada (ex.: us-east-1).
- environment (string) [obrigatória]: Ambiente de implantação. Valores permitidos: dev, hml, prd.
- system (string) [obrigatória]: Identificador do sistema (minúsculas, números e hífens).
- policy_name (string) [obrigatória]: Finalidade da policy, usada na composição do nome.
- allowed_actions (list(string)) [obrigatória]: Ações IAM explicitamente permitidas. Ex.: ["s3:GetObject", "s3:ListBucket"]. Não pode combinar "*" com Resource "*".
- allowed_resources (list(string)) [obrigatória]: Recursos explicitamente permitidos (ARNs específicos ou restritos). Não pode combinar "*" com Action "*".
- policy_path (string) [opcional]: Caminho da policy. Padrão: "/".
- description (string) [opcional]: Descrição da policy. Se omitida, uma descrição padrão é gerada.
- additional_tags (map(string)) [opcional]: Tags adicionais a serem mescladas às tags obrigatórias.

Tabela de outputs (nome, descrição)
- policy_name: Nome da IAM Policy criada.
- policy_arn: ARN da IAM Policy criada.
- policy_id: ID interno da IAM Policy criada.

Exemplo de uso do módulo/recurso
- Exemplo como módulo local:
  module "iam_policy" {
    source = "./"

    region           = "us-east-1"
    environment      = "dev"
    system           = "tcc"
    policy_name      = "readonly"
    policy_path      = "/"
    allowed_actions  = ["s3:GetObject", "s3:ListBucket"]
    allowed_resources = [
      "arn:aws:s3:::example-bucket",
      "arn:aws:s3:::example-bucket/*"
    ]

    additional_tags = {
      Team = "platform"
    }
  }

- Após aplicar:
  - O nome do recurso seguirá: dev-tcc-iam-readonly
  - As tags obrigatórias serão aplicadas automaticamente e mescladas com additional_tags
  - Nenhuma policy gerenciada administrativa será anexada automaticamente
