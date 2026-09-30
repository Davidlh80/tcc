# IAM Policy anexada a IAM Role

## 1. Visao geral

Este modulo cria uma IAM Policy de minimo privilegio e uma IAM Role dedicada, anexando a policy a role por meio de `aws_iam_role_policy_attachment` (a policy nunca fica solta, sem principal associado).

Caracteristicas de seguranca aplicadas por padrao:

- a trust policy (assume role policy) da role e restrita a um unico principal, informado pela variavel `trusted_principal_arn` — nao e permitido `Principal = "*"` nem `"AWS" = "*"`;
- a statement `Effect = "Allow"` da policy fica restrita exatamente as acoes (`allowed_actions`) e aos recursos (`allowed_resources`) informados por variavel;
- uma precondicao (`lifecycle.precondition`) bloqueia a criacao da policy caso `allowed_actions` contenha `"*"` e `allowed_resources` contenha `"*"` simultaneamente;
- nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) e anexada ou replicada pelo modulo;
- nomenclatura de recursos segue o padrao `<ambiente>-<sistema>-<recurso>-<finalidade>` (ex.: `prd-tcc-iam-readonly` para a policy e `prd-tcc-iam-role-readonly` para a role);
- todos os recursos que suportam tags recebem o conjunto obrigatorio de tags da organizacao.

## 2. Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|---|---|---|---|
| environment | string | sim | Ambiente de implantacao do recurso (dev, hml ou prd). |
| system | string | sim | Nome do sistema/aplicacao dono do recurso, usado na nomenclatura padronizada. |
| region | string | nao (default `us-east-1`) | Regiao AWS onde os recursos serao provisionados. |
| additional_tags | map(string) | nao (default `{}`) | Tags adicionais a serem mescladas as tags obrigatorias da organizacao. |
| policy_name | string | sim | Finalidade/nome da policy, usado na nomenclatura padronizada (ex.: readonly, deploy). |
| allowed_actions | list(string) | sim | Lista de acoes IAM permitidas na statement Allow da policy. |
| allowed_resources | list(string) | sim | Lista de ARNs de recursos permitidos na statement Allow da policy. |
| trusted_principal_arn | string | sim | ARN do principal autorizado a assumir a role via trust policy. Nao pode ser "*". |

## 3. Outputs

| Nome | Descricao |
|---|---|
| policy_name | Nome da IAM Policy criada. |
| policy_arn | ARN da IAM Policy criada. |
| policy_id | ID da IAM Policy criada. |
| role_name | Nome da IAM Role criada e anexada a policy. |
| role_arn | ARN da IAM Role criada e anexada a policy. |
| role_id | ID da IAM Role criada e anexada a policy. |

## 4. Exemplo de uso

    module "iam_readonly" {
      source = "./iam"

      environment = "prd"
      system      = "tcc"
      region      = "us-east-1"
      policy_name = "readonly"

      allowed_actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]

      allowed_resources = [
        "arn:aws:s3:::prd-tcc-s3-logs",
        "arn:aws:s3:::prd-tcc-s3-logs/*"
      ]

      trusted_principal_arn = "arn:aws:iam::123456789012:role/prd-tcc-ci-deploy"

      additional_tags = {
        Squad = "plataforma"
      }
    }
