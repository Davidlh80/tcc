1. Visão geral do recurso
Este template provisiona uma IAM Policy seguindo o padrão organizacional:
- Nomenclatura: <environment>-<system>-iam-<finalidade>
- Ambientes válidos: dev, hml, prd
- Aplica tags obrigatórias em todos os recursos suportados
- Implementa princípio do menor privilégio
- Proíbe explicitamente a combinação Action:"*" com Resource:"*" na mesma statement
- Não anexa/replica policies administrativas (ex.: AdministratorAccess)
- Permite configurar ações e recursos via variáveis

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo         | Obrigatória | Descrição                                                                                  |
|-------------------|--------------|-------------|--------------------------------------------------------------------------------------------|
| region            | string       | Sim         | Região AWS (ex.: us-east-1).                                                               |
| environment       | string       | Sim         | Ambiente (dev, hml, prd).                                                                  |
| system            | string       | Sim         | Identificador do sistema/aplicação (minúsculas, números e hífens).                         |
| additional_tags   | map(string)  | Não         | Tags adicionais. Tags obrigatórias sempre serão aplicadas e prevalecem em caso de conflito.|
| policy_name       | string       | Sim         | Nome da policy no padrão <environment>-<system>-iam-<finalidade> (ex.: dev-tcc-iam-readonly). |
| policy_description| string       | Não         | Descrição da policy. Default: "Managed by Terraform - least privilege policy".             |
| allowed_actions   | list(string) | Sim         | Ações permitidas (ex.: ["s3:GetObject", "s3:ListBucket"]).                                 |
| allowed_resources | list(string) | Sim         | ARNs de recursos permitidos (evitar usar \"*\" junto com ações \"*\").                     |

3. Tabela de outputs (nome, descrição)
| Nome         | Descrição                       |
|--------------|---------------------------------|
| policy_name  | Nome da IAM Policy criada.      |
| policy_arn   | ARN da IAM Policy criada.       |
| policy_id    | ID da IAM Policy criada.        |

4. Exemplo de uso do módulo/recurso
    module "iam_policy" {
      source  = "./"
      region  = "us-east-1"

      environment = "dev"
      system      = "tcc"

      policy_name        = "dev-tcc-iam-readonly"
      policy_description = "Least privilege S3 read-only for project tcc"

      allowed_actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]

      allowed_resources = [
        "arn:aws:s3:::example-bucket",
        "arn:aws:s3:::example-bucket/*"
      ]

      additional_tags = {
        Squad = "platform"
      }
    }

Notas:
- O template valida e impede a criação de statement com Action:"*" e Resource:"*".
- Utilize ARNs específicos nos recursos sempre que possível para reforçar o menor privilégio.
