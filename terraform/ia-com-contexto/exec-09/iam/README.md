1. Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nomenclatura: <ambiente>-<sistema>-iam-<finalidade>
- Princípio do menor privilégio: apenas ações e recursos explicitamente informados são permitidos
- Controles de segurança:
  - Proibição explícita de um statement com Action "*" combinado com Resource "*"
  - Não anexa policies gerenciadas administrativas
- Tags obrigatórias aplicadas automaticamente a recursos que suportam tags

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo          | Obrigatória | Descrição                                                                                 |
|-------------------|---------------|-------------|-------------------------------------------------------------------------------------------|
| environment       | string        | Sim         | Ambiente alvo (dev, hml, prd).                                                            |
| system            | string        | Sim         | Identificador do sistema/projeto (minúsculas, dígitos e hifens).                          |
| region            | string        | Sim         | Região AWS para o provider (ex.: us-east-1).                                              |
| additional_tags   | map(string)   | Não         | Tags adicionais para anexar aos recursos compatíveis.                                     |
| policy_name       | string        | Sim         | Finalidade/nome lógico da policy (usado como sufixo na nomenclatura).                     |
| description       | string        | Não         | Descrição da IAM Policy.                                                                  |
| path              | string        | Não         | Caminho da IAM Policy (ex.: / ou /service-role/).                                         |
| allowed_actions   | list(string)  | Sim         | Lista de ações explícitas que serão permitidas (ex.: ["s3:GetObject"]).                   |
| allowed_resources | list(string)  | Sim         | Lista de ARNs de recursos aos quais as ações serão aplicadas (ex.: ["arn:aws:s3:::..."]). |

3. Tabela de outputs (nome, descrição)
| Nome        | Descrição                           |
|-------------|-------------------------------------|
| policy_name | Nome final da IAM Policy criada.    |
| policy_arn  | ARN da IAM Policy criada.           |
| policy_id   | ID da IAM Policy criada.            |

4. Exemplo de uso do módulo/recurso
module "iam_policy" {
  source = "./"

  environment       = "dev"
  system            = "tcc"
  region            = "us-east-1"

  policy_name       = "readonly"
  description       = "Permissões de leitura em bucket S3 específico"
  path              = "/"

  allowed_actions   = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Application = "demo"
  }
}

# Após aplicar:
# - A policy será nomeada: dev-tcc-iam-readonly
# - Nenhuma combinação Action '*' com Resource '*' será aceita
