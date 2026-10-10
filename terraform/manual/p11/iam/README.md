# Blueprint Terraform — iam

## Visão geral

Cria uma policy IAM restrita às ações e ARNs informados, uma role com principal de confiança configurável e o vínculo entre elas. O principal deve ser uma role ou um usuário IAM existente. Escolha ações compatíveis com restrição por ARN e revise a combinação de permissões antes de aplicar.

Requer Terraform >= 1.5 e provider AWS ~> 6.0. Configure as credenciais AWS externamente, pelo perfil ou variáveis de ambiente. Nomes seguem o contexto organizacional e tags obrigatórias prevalecem sobre tags adicionais.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
| --- | --- | --- | --- |
| `environment` | `string` | Sim | Ambiente de implantacao. |
| `system` | `string` | Sim | Identificacao do sistema. |
| `region` | `string` | Não | Regiao AWS. |
| `additional_tags` | `map(string)` | Não | Tags adicionais; tags obrigatorias prevalecem. |
| `policy_name` | `string` | Sim | Finalidade que compoe o nome. |
| `role_name` | `string` | Sim | Finalidade que compoe o nome. |
| `trusted_principal_arn` | `string` | Sim | ARN unico do principal AWS autorizado a assumir a role. |
| `allowed_actions` | `list(string)` | Sim | Acoes especificas autorizadas. |
| `allowed_resources` | `list(string)` | Sim | ARNs autorizados; wildcard apenas no sufixo de um recurso delimitado. |

## Outputs

| Nome | Descrição |
| --- | --- |
| `policy_name` | policy_name do recurso criado |
| `policy_arn` | policy_arn do recurso criado |
| `policy_id` | policy_id do recurso criado |
| `role_name` | role_name do recurso criado |
| `role_arn` | role_arn do recurso criado |

## Exemplo de uso

Na pasta deste blueprint, copie `terraform.tfvars.example` para `terraform.tfvars` e ajuste os identificadores de exemplo:

```hcl
environment           = "dev"
system                = "tcc"
region                = "us-east-1"
policy_name           = "read-logs"
role_name             = "reader-logs"
trusted_principal_arn = "arn:aws:iam::123456789012:role/dev-tcc-iam-application"
allowed_actions       = ["s3:GetObject"]
allowed_resources     = ["arn:aws:s3:::dev-tcc-s3-logs-123456789012/*"]
additional_tags       = {}
```

Execute:

```sh
terraform fmt -check
terraform init -backend=false
terraform validate
terraform plan -var-file=terraform.tfvars
```

Revise o plano antes de executar `terraform apply -var-file=terraform.tfvars`, que cria recursos na conta configurada. Este blueprint pode ser executado de forma independente na sua própria pasta.

Consulte o [fluxo de validações](../../../docs/como-executar-validacoes.md) para os critérios de segurança e análise com Checkov e Trivy.
