# Blueprint — AWS IAM

## Objetivo

Definir um template Terraform que crie uma policy, uma role e a associação entre elas, seguindo o princípio do menor privilégio.

## Estrutura

```text
iam/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── README.md
```

Em `versions.tf`, declarar a versão compatível do Terraform e o provider `hashicorp/aws`. Configurar a região por variável. Em `main.tf`, montar os documentos de permissão e confiança com `aws_iam_policy_document` e criar:

| Recurso Terraform                | Responsabilidade                                              |
| -------------------------------- | ------------------------------------------------------------- |
| `aws_iam_policy`                 | Permitir apenas as ações e os recursos recebidos por variável |
| `aws_iam_role`                   | Restringir `sts:AssumeRole` ao principal informado            |
| `aws_iam_role_policy_attachment` | Anexar a policy à role                                        |

## Variáveis

| Nome                    | Tipo           | Obrigatória | Descrição                                                 |
| ----------------------- | -------------- | ----------- | --------------------------------------------------------- |
| `environment`           | `string`       | Sim         | Ambiente: `dev`, `hml` ou `prd`                           |
| `system`                | `string`       | Sim         | Identificação do sistema                                  |
| `region`                | `string`       | Sim         | Região AWS do provider                                    |
| `additional_tags`       | `map(string)`  | Não         | Tags adicionais; padrão `{}`                              |
| `policy_name`           | `string`       | Sim         | Finalidade usada no nome da policy                        |
| `role_name`             | `string`       | Sim         | Finalidade usada no nome da role                          |
| `trusted_principal_arn` | `string`       | Sim         | Um único ARN de principal AWS autorizado a assumir a role |
| `allowed_actions`       | `list(string)` | Sim         | Ações IAM específicas permitidas                          |
| `allowed_resources`     | `list(string)` | Sim         | ARNs dos recursos autorizados                             |

Validar nomes não vazios, ambiente permitido, listas não vazias e ARN de confiança sem wildcard. Usar o principal do tipo `AWS` na trust policy, conforme a variável exigida pelo contexto organizacional. Rejeitar ações administrativas amplas e o uso de `*` como ação ou recurso no blueprint; escolher ações que suportem restrição por ARN.

## Nomenclatura e tags

Usar `<ambiente>-<sistema>-iam-<finalidade>` para a policy e a role, com finalidades distintas para evitar ambiguidade. Aplicar a ambos as tags obrigatórias: `Project = "tcc-iac-ia"`, `Environment = var.environment`, `ManagedBy = "terraform"`, `Owner = "devops"` e `CostCenter = "academic-research"`. Mesclar tags adicionais antes das obrigatórias para impedir sua sobrescrita.

## Outputs

| Nome          | Valor                 |
| ------------- | --------------------- |
| `policy_name` | Nome da policy criada |
| `policy_arn`  | ARN da policy criada  |
| `policy_id`   | ID da policy criada   |
| `role_name`   | Nome da role criada   |
| `role_arn`    | ARN da role criada    |

## Exemplo de configuração

```hcl
environment           = "dev"
system                = "tcc"
region                = "us-east-1"
policy_name           = "read-logs"
role_name             = "reader-logs"
trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-iam-application"
allowed_actions       = ["s3:GetObject"]
allowed_resources     = ["arn:aws:s3:::dev-tcc-s3-logs/*"]
additional_tags       = {}
```

Substituir o ARN de confiança e o bucket pelos recursos do ambiente. O wildcard no sufixo de objetos delimita o acesso ao bucket especificado, sem autorizar todos os recursos da conta.

## Critérios de aceitação

- A policy está anexada à role, sem permissões além das entradas fornecidas.
- A trust policy contém somente o ARN configurado e a ação `sts:AssumeRole`.
- Nenhuma policy administrativa gerenciada é anexada.
- Nomes, tags, variáveis e outputs atendem ao contexto organizacional.
- O README apresenta visão geral, tabela de variáveis, tabela de outputs e exemplo de uso, nessa ordem.
- Executar `terraform fmt -check`, `terraform init -backend=false` e `terraform validate`; executar Checkov e Trivy conforme o fluxo do repositório e revisar os achados.
