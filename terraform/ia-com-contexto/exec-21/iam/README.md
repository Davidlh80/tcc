# IAM Policy anexada a IAM Role

## 1. Visao geral do recurso

Este template provisiona uma IAM Policy de minimo privilegio e uma IAM Role dedicada, com a policy anexada diretamente a role (nenhuma policy fica solta, sem principal associado).

Principais garantias de seguranca aplicadas:

- a trust policy (assume role policy) da role fica restrita a um unico principal, definido pela variavel `trust_principal_arn`; nao e permitido `Principal = "*"` nem `"AWS" = "*"`;
- a statement da policy nao pode combinar `Action = "*"` com `Resource = "*"` na mesma regra (validado via precondition);
- o `Effect = Allow` fica restrito apenas as actions e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada;
- nomenclatura e tags seguem o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`.

## 2. Tabela de variaveis

| Nome                  | Tipo         | Obrigatoria | Descricao                                                                                   |
|------------------------|--------------|:-----------:|-----------------------------------------------------------------------------------------------|
| environment             | string       | sim          | Ambiente de implantacao (`dev`, `hml` ou `prd`).                                               |
| system                  | string       | sim          | Nome do sistema/aplicacao dono do recurso.                                                     |
| region                  | string       | sim          | Regiao AWS onde os recursos serao provisionados.                                               |
| additional_tags         | map(string)  | nao          | Tags adicionais mescladas as tags obrigatorias. Padrao: `{}`.                                  |
| policy_name             | string       | sim          | Finalidade da policy/role, usada na nomenclatura (ex.: `readonly`, `deploy`).                  |
| allowed_actions         | list(string) | sim          | IAM actions permitidas na policy. Nao pode conter `"*"`.                                       |
| allowed_resources       | list(string) | sim          | ARNs de recursos permitidos na policy. Nao pode conter `"*"`.                                  |
| trust_principal_arn     | string       | sim          | ARN do principal autorizado a assumir a role via `sts:AssumeRole`. Nao pode ser `"*"`.          |

## 3. Tabela de outputs

| Nome        | Descricao                                             |
|-------------|--------------------------------------------------------|
| policy_name | Nome da IAM Policy criada.                              |
| policy_arn  | ARN da IAM Policy criada.                                |
| policy_id   | ID da IAM Policy criada.                                 |
| role_name   | Nome da IAM Role criada, a qual a policy esta anexada.  |
| role_arn    | ARN da IAM Role criada.                                  |
| role_id     | ID unico da IAM Role criada.                             |

## 4. Exemplo de uso do modulo/recurso

    module "iam_readonly" {
      source = "./caminho/para/este/modulo"

      environment = "dev"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      allowed_actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]

      allowed_resources = [
        "arn:aws:s3:::dev-tcc-s3-logs",
        "arn:aws:s3:::dev-tcc-s3-logs/*"
      ]

      trust_principal_arn = "arn:aws:iam::123456789012:role/ci-cd-pipeline"

      additional_tags = {
        Squad = "plataforma"
      }
    }
