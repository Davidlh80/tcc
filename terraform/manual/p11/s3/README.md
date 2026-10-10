# Blueprint Terraform — s3

## Visão geral

Cria um bucket privado com as quatro flags de bloqueio público, criptografia AES256, negação de transporte inseguro e versionamento habilitado por padrão. O nome deve ser globalmente único. Desabilitar versionamento suspende novas versões; versões existentes permanecem. A exclusão não remove objetos automaticamente.

Requer Terraform >= 1.5 e provider AWS ~> 6.0. Configure as credenciais AWS externamente, pelo perfil ou variáveis de ambiente. Nomes seguem o contexto organizacional e tags obrigatórias prevalecem sobre tags adicionais.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
| --- | --- | --- | --- |
| `environment` | `string` | Sim | Ambiente de implantacao. |
| `system` | `string` | Sim | Identificacao do sistema. |
| `region` | `string` | Não | Regiao AWS. |
| `additional_tags` | `map(string)` | Não | Tags adicionais; tags obrigatorias prevalecem. |
| `purpose` | `string` | Sim | Finalidade do bucket; deve tornar o nome globalmente unico. |
| `versioning_enabled` | `bool` | Não | Habilitar versionamento; false suspende novas versoes. |

## Outputs

| Nome | Descrição |
| --- | --- |
| `bucket_name` | bucket_name do recurso criado |
| `bucket_arn` | bucket_arn do recurso criado |
| `bucket_id` | bucket_id do recurso criado |

## Exemplo de uso

Na pasta deste blueprint, copie `terraform.tfvars.example` para `terraform.tfvars` e ajuste os identificadores de exemplo:

```hcl
environment        = "dev"
system             = "tcc"
region             = "us-east-1"
purpose            = "logs-123456789012"
versioning_enabled = true
additional_tags    = {}
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
