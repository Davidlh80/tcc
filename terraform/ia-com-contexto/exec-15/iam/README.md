# IAM Policy — dev-tcc-iam-<finalidade>

## Visao geral

Este template Terraform provisiona uma IAM Policy gerenciada pelo cliente (customer-managed policy) seguindo o principio do menor privilegio.

A policy contem uma unica statement com `Effect: Allow`, restrita exclusivamente as acoes e aos recursos informados pelas variaveis `allowed_actions` e `allowed_resources`. Nao ha nenhuma statement que combine `Action: "*"` com `Resource: "*"` — essa combinacao e explicitamente proibida por uma precondicao (`lifecycle.precondition`) no recurso `aws_iam_policy.this`, que interrompe o `terraform plan/apply` caso a combinacao seja detectada.

Este template nao anexa nem replica nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) a usuarios, grupos ou roles — apenas cria a policy customizada, cabendo ao consumidor decidir onde anexa-la, sempre observando o menor privilegio.

O nome do recurso segue o padrao organizacional `<ambiente>-<sistema>-<recurso>-<finalidade>`, por exemplo `prd-tcc-iam-readonly`.

## Variaveis

| Nome | Tipo | Obrigatoria | Descricao |
|------|------|-------------|-----------|
| environment | string | Sim | Ambiente de implantacao (`dev`, `hml` ou `prd`). |
| system | string | Sim | Nome curto do sistema proprietario do recurso, usado na composicao do nome padronizado. |
| region | string | Nao (default `us-east-1`) | Regiao AWS onde os recursos serao provisionados. |
| additional_tags | map(string) | Nao (default `{}`) | Tags adicionais mescladas com as tags obrigatorias da organizacao. |
| policy_name | string | Sim | Finalidade da IAM Policy, usada na composicao do nome padronizado. |
| allowed_actions | list(string) | Sim | Lista de acoes IAM permitidas na statement `Allow`. Nao deve ser `["*"]` combinada com `allowed_resources = ["*"]`. |
| allowed_resources | list(string) | Sim | Lista de ARNs de recursos permitidos na statement `Allow`. Nao deve ser `["*"]` combinada com `allowed_actions = ["*"]`. |

## Outputs

| Nome | Descricao |
|------|-----------|
| policy_name | Nome da IAM Policy criada. |
| policy_arn | ARN da IAM Policy criada. |
| policy_id | ID da IAM Policy criada. |

## Exemplo de uso

    module "iam_policy_readonly" {
      source = "./"

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

      additional_tags = {
        Squad = "plataforma"
      }
    }
