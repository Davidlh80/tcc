# IAM Policy

## 1. Visao geral do recurso

Este modulo cria uma IAM Policy (`aws_iam_policy`) seguindo o padrao de nomenclatura `<ambiente>-<sistema>-<recurso>-<finalidade>` da organizacao (ex.: `prd-tcc-iam-readonly`).

A policy gerada contem uma unica statement com `Effect = "Allow"`, cujas `actions` e `resources` sao definidas exclusivamente pelas variaveis `allowed_actions` e `allowed_resources`. Uma precondition no `data.aws_iam_policy_document.this` bloqueia a criacao caso a combinacao `Action = "*"` e `Resource = "*"` esteja presente na mesma statement, impedindo acesso irrestrito por acidente.

O modulo nao anexa, cria nem replica nenhuma policy gerenciada administrativa (ex.: `AdministratorAccess`) — apenas o recurso `aws_iam_policy` e criado, sem `aws_iam_policy_attachment`, `aws_iam_role_policy_attachment` ou `aws_iam_user_policy_attachment`.

Tags obrigatorias da organizacao (`Project`, `Environment`, `ManagedBy`, `Owner`, `CostCenter`) sao aplicadas automaticamente e podem ser complementadas via `additional_tags`.

## 2. Variaveis

| Nome                  | Tipo           | Obrigatoria | Descricao                                                                 |
|-----------------------|----------------|-------------|-----------------------------------------------------------------------------|
| environment           | string         | Sim         | Ambiente de implantacao (dev, hml ou prd).                                  |
| system                | string         | Sim         | Nome do sistema ou projeto ao qual o recurso pertence.                      |
| region                | string         | Nao         | Regiao AWS onde o provider sera configurado. Padrao: us-east-1.             |
| additional_tags       | map(string)    | Nao         | Tags adicionais mescladas as tags obrigatorias. Padrao: {}.                 |
| policy_name           | string         | Sim         | Finalidade da IAM Policy, usada na composicao do nome (ex.: readonly).      |
| policy_description    | string         | Nao         | Descricao funcional da IAM Policy.                                         |
| allowed_actions       | list(string)   | Sim         | Lista de acoes IAM permitidas na statement Allow.                          |
| allowed_resources     | list(string)   | Sim         | Lista de ARNs de recursos aos quais as acoes permitidas se aplicam.        |

## 3. Outputs

| Nome         | Descricao                          |
|--------------|-------------------------------------|
| policy_name  | Nome da IAM Policy criada.          |
| policy_arn   | ARN da IAM Policy criada.           |
| policy_id    | ID da IAM Policy criada.            |

## 4. Exemplo de uso

module "iam_policy" {
  source = "./"

  environment = "prd"
  system      = "tcc"
  region      = "us-east-1"

  policy_name        = "readonly"
  policy_description = "Permite leitura de objetos em um bucket especifico."

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
