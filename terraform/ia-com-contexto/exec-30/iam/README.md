# IAM Policy anexada a IAM Role

## 1. Visao geral

Este template provisiona um conjunto minimo de IAM para a organizacao:

- uma **IAM Policy** de minimo privilegio, com uma unica statement `Effect: Allow` restrita exclusivamente as `Actions` e `Resources` informados por variavel (nunca `Action: "*"` combinado com `Resource: "*"`);
- uma **IAM Role**, cuja trust policy (assume role policy) restringe o principal autorizado a assumi-la a um unico ARN configuravel (`trusted_principal_arn`), proibindo `Principal: "*"` ou `"AWS": "*"`;
- o anexo (attachment) da IAM Policy criada a IAM Role criada, garantindo que a policy nao fique solta, sem nenhum principal associado;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada.

Os nomes dos recursos seguem o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `prd-tcc-iam-policy-readonly` e `prd-tcc-iam-role-readonly`.

## 2. Variaveis

| Nome                     | Tipo           | Obrigatoria | Descricao                                                                                  |
|--------------------------|----------------|-------------|----------------------------------------------------------------------------------------------|
| `environment`            | `string`       | Sim         | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                             |
| `system`                 | `string`       | Sim         | Nome curto do sistema/aplicacao proprietaria do recurso.                                     |
| `region`                 | `string`       | Nao         | Regiao AWS utilizada pelo provider. Padrao: `us-east-1`.                                     |
| `additional_tags`        | `map(string)`  | Nao         | Tags adicionais mescladas as tags obrigatorias da organizacao. Padrao: `{}`.                 |
| `policy_name`            | `string`       | Sim         | Finalidade/nome usado na composicao do nome padronizado da policy e da role.                 |
| `trusted_principal_arn`  | `string`       | Sim         | ARN unico do principal autorizado a assumir a Role (trust policy). Nao aceita `*`.            |
| `allowed_actions`        | `list(string)` | Sim         | IAM Actions permitidas na policy (`Effect: Allow`).                                           |
| `allowed_resources`      | `list(string)` | Sim         | Recursos (ARNs) permitidos na policy (`Effect: Allow`).                                       |
| `max_session_duration`   | `number`       | Nao         | Duracao maxima, em segundos, da sessao assumida pela Role (3600 a 43200). Padrao: `3600`.    |

## 3. Outputs

| Nome          | Descricao                              |
|---------------|------------------------------------------|
| `policy_name` | Nome da IAM Policy criada.                |
| `policy_arn`  | ARN da IAM Policy criada.                 |
| `policy_id`   | ID da IAM Policy criada.                  |
| `role_name`   | Nome da IAM Role criada.                  |
| `role_arn`    | ARN da IAM Role criada.                   |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./caminho/para/este/modulo"

      environment = "prd"
      system      = "tcc"
      region      = "us-east-1"

      policy_name            = "readonly"
      trusted_principal_arn  = "arn:aws:iam::123456789012:role/pipeline-ci"

      allowed_actions = [
        "s3:GetObject",
        "s3:ListBucket",
      ]

      allowed_resources = [
        "arn:aws:s3:::prd-tcc-s3-logs",
        "arn:aws:s3:::prd-tcc-s3-logs/*",
      ]

      max_session_duration = 3600

      additional_tags = {
        Squad = "plataforma"
      }
    }
