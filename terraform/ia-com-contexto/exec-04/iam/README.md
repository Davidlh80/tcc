# IAM Policy

## Visão geral

Este template provisiona uma AWS IAM Policy (customer managed policy) com uma única statement de `Allow`, restrita exclusivamente às actions e recursos informados via variável. O template aplica o princípio do menor privilégio e bloqueia, em tempo de plan/apply, qualquer tentativa de combinar `Action: "*"` com `Resource: "*"` na mesma statement, evitando a criação de policies equivalentes a permissões administrativas irrestritas. Nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) é anexada ou replicada por este template. O nome do recurso segue o padrão organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>` e as tags obrigatórias da organização são aplicadas por padrão.

## Variáveis

| Nome                | Tipo         | Obrigatória | Descrição                                                                                          |
|---------------------|--------------|-------------|------------------------------------------------------------------------------------------------------|
| `environment`       | `string`     | Sim         | Ambiente de implantação (`dev`, `hml` ou `prd`).                                                     |
| `system`             | `string`     | Sim         | Nome do sistema/aplicação ao qual o recurso pertence.                                                |
| `region`             | `string`     | Não         | Região AWS onde o provider será configurado. Padrão: `us-east-1`.                                    |
| `additional_tags`    | `map(string)`| Não         | Tags adicionais mescladas às tags obrigatórias da organização. Padrão: `{}`.                         |
| `policy_name`        | `string`     | Sim         | Finalidade da policy, usada para compor o nome padronizado (`<ambiente>-<sistema>-iam-<finalidade>`).|
| `description`        | `string`     | Não         | Descrição da IAM Policy. Padrão: `"Managed by Terraform."`.                                          |
| `allowed_actions`    | `list(string)`| Sim        | Lista de IAM actions permitidas na statement `Allow`.                                                |
| `allowed_resources`  | `list(string)`| Sim        | Lista de ARNs/recursos permitidos na statement `Allow`.                                              |

## Outputs

| Nome           | Descrição                                    |
|----------------|-----------------------------------------------|
| `policy_name`  | Nome padronizado da IAM Policy criada.        |
| `policy_arn`   | ARN da IAM Policy criada.                     |
| `policy_id`    | ID da IAM Policy criada.                      |

## Exemplo de uso

```hcl
module "iam_readonly_policy" {
  source = "./"

  environment = "dev"
  system      = "tcc"
  region      = "us-east-1"
  policy_name = "readonly"
  description = "Permite leitura de objetos em um bucket específico."

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-logs",
    "arn:aws:s3:::dev-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
