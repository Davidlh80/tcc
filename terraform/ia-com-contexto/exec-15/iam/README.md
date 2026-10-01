# IAM Policy anexada a IAM Role

## 1. Visao geral

Este modulo Terraform cria uma IAM Policy e uma IAM Role na AWS, anexando a policy diretamente a role por meio de `aws_iam_role_policy_attachment`, de forma que a policy nunca fica solta sem um principal associado.

Principais caracteristicas de seguranca:

- a trust policy (`assume_role_policy`) da role restringe o principal autorizado a assumir a role a um unico ARN, configurado via `trusted_principal_arn` (proibido `Principal: "*"`);
- a policy criada permite apenas as acoes (`allowed_actions`) e recursos (`allowed_resources`) informados por variavel, com `Effect: Allow` restrito a esses valores;
- e proibida, por meio de `precondition`, qualquer combinacao de `Action: "*"` com `Resource: "*"` na mesma statement;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada pelo modulo;
- nomenclatura e tags seguem o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`.

## 2. Variaveis

| Nome                     | Tipo         | Obrigatoria | Descricao                                                                                  |
|--------------------------|--------------|:-----------:|---------------------------------------------------------------------------------------------|
| `environment`            | string       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                            |
| `system`                 | string       | Sim         | Identificador do sistema/projeto, usado na nomenclatura padronizada.                        |
| `region`                 | string       | Sim         | Regiao AWS onde os recursos serao criados.                                                  |
| `additional_tags`        | map(string)  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: `{}`.                 |
| `policy_name`            | string       | Sim         | Finalidade/nome usado na nomenclatura da IAM Policy e da IAM Role.                           |
| `trusted_principal_arn`  | string       | Sim         | ARN unico do principal autorizado a assumir a IAM Role. Nao pode ser wildcard.               |
| `allowed_actions`        | list(string) | Sim         | Lista de acoes IAM permitidas na policy.                                                     |
| `allowed_resources`      | list(string) | Sim         | Lista de recursos (ARNs) aos quais as acoes permitidas se aplicam.                           |

## 3. Outputs

| Nome          | Descricao                              |
|---------------|-----------------------------------------|
| `policy_name` | Nome da IAM Policy criada.              |
| `policy_arn`  | ARN da IAM Policy criada.               |
| `policy_id`   | ID da IAM Policy criada.                |
| `role_name`   | Nome da IAM Role criada.                |
| `role_arn`    | ARN da IAM Role criada.                 |

## 4. Exemplo de uso

```hcl
module "iam_readonly" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name            = "readonly"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-cd-deployer"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::prd-tcc-s3-logs",
    "arn:aws:s3:::prd-tcc-s3-logs/*"
  ]

  additional_tags = {
    Squad = "plataforma"
  }
}
```
