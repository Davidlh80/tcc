1. Visão geral do recurso
Este template provisiona uma AWS IAM Policy seguindo o padrão organizacional:
- Nome: <ambiente>-<sistema>-iam-<finalidade> (ex.: prd-tcc-iam-readonly)
- Tags obrigatórias aplicadas em todos os recursos que suportam tags
- Princípio do menor privilégio
- Controles de segurança específicos de IAM:
  - Proíbe explicitamente statements que combinem Action="*" com Resource="*"
  - Restringe Effect: Allow apenas às ações e recursos informados por variável
  - Não anexa nem replica policies administrativas (ex.: AdministratorAccess)

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
| Nome              | Tipo          | Obrigatória | Descrição                                                                                           |
|-------------------|---------------|-------------|-----------------------------------------------------------------------------------------------------|
| environment       | string        | Sim         | Ambiente do recurso (dev, hml, prd).                                                                |
| system            | string        | Sim         | Identificador do sistema/projeto (minúsculo, números e hífens).                                     |
| region            | string        | Sim         | Região AWS para o provider (ex.: us-east-1).                                                        |
| additional_tags   | map(string)   | Não         | Tags adicionais (não sobrescrevem as obrigatórias).                                                 |
| policy_name       | string        | Sim         | Finalidade da política. Usado no nome: <env>-<system>-iam-<policy_name> (ex.: readonly).            |
| policy_description| string        | Não         | Descrição da IAM Policy.                                                                            |
| allowed_actions   | list(string)  | Sim         | Lista de ações a permitir (Effect: Allow).                                                          |
| allowed_resources | list(string)  | Sim         | Lista de ARNs de recursos onde as ações serão permitidas.                                           |
| policy_path       | string        | Não         | Caminho da policy. Deve iniciar com '/' e ser '/' ou terminar com '/'. Padrão: "/".                 |

Observações de segurança:
- A combinação Action="*" e Resource="*" é rejeitada pela blueprint.
- Utilize sempre escopos específicos de ação e recurso para aderir ao princípio do menor privilégio.

3. Tabela de outputs (nome, descrição)
| Nome         | Descrição                            |
|--------------|--------------------------------------|
| policy_name  | Nome completo da IAM Policy criada.  |
| policy_arn   | ARN da IAM Policy criada.            |
| policy_id    | ID único da IAM Policy criada.       |

4. Exemplo de uso do módulo/recurso
provider "aws" {
  region = "us-east-1"
}

module "iam_policy_readonly" {
  source = "./"

  environment        = "dev"
  system             = "tcc"
  region             = "us-east-1"
  policy_name        = "readonly"
  policy_description = "Permissões de leitura em objetos de um bucket específico."
  policy_path        = "/team-a/"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Squad = "core-platform"
  }
}

Saída esperada:
- module.iam_policy_readonly.policy_name
- module.iam_policy_readonly.policy_arn
- module.iam_policy_readonly.policy_id
