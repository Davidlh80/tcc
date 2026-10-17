# Bucket Amazon S3

## 1. Visão geral do recurso

Este módulo cria um bucket S3 cujo nome segue o padrão
`<ambiente>-<sistema>-s3-<finalidade>`. O bucket aplica as tags obrigatórias do
padrão organizacional e tags adicionais opcionais. Também configura:

- bloqueio de acesso público nas quatro opções do Public Access Block;
- criptografia server-side SSE-S3 com AES256;
- bucket policy que nega requisições sem transporte seguro (`aws:SecureTransport`);
- versionamento com estado configurável.

## 2. Tabela de variáveis (nome, tipo, obrigatória, descrição)

| Nome | Tipo | Obrigatória | Descrição |
|---|---|---|---|
| `environment` | `string` | Sim | Ambiente, limitado a `dev`, `hml` ou `prd`; usado no nome e na tag `Environment`. |
| `system` | `string` | Sim | Identificador do sistema usado no nome do bucket. |
| `region` | `string` | Sim | Região AWS onde o bucket será criado. |
| `additional_tags` | `map(string)` | Não | Tags adicionais opcionais; padrão `{}`. Tags obrigatórias não podem ser sobrescritas. |
| `purpose` | `string` | Sim | Finalidade usada no nome do bucket. |
| `versioning_status` | `string` | Não | Estado do versionamento: `Enabled` ou `Suspended`; padrão `Enabled`. |
| `required_tags` | `map(string)` | Não | Tags organizacionais `Project`, `ManagedBy`, `Owner` e `CostCenter`, com valores obrigatórios predefinidos. |

## 3. Tabela de outputs (nome, descrição)

| Nome | Descrição |
|---|---|
| `bucket_name` | Nome do bucket S3. |
| `bucket_arn` | ARN do bucket S3. |
| `bucket_id` | ID do bucket S3. |
| `bucket_region` | Região AWS do bucket S3. |
| `bucket_domain_name` | Nome de domínio regional do bucket S3. |

## 4. Exemplo de uso do módulo/recurso

```hcl
variable "region" {
  type = string
}

module "s3_bucket" {
  source = "./terraform/manual/p30/s3"

  environment = "dev"
  system      = "tcc"
  region      = var.region
  purpose     = "logs"
}
```

## Premissas

- O contexto organizacional não fixa versões de Terraform ou do AWS provider;
  este template usa Terraform `>= 1.5.0` e AWS provider `~> 5.0`, conforme a
  faixa segura indicada na solicitação.
- SSE-S3 usa o algoritmo `AES256`; por isso, nenhum recurso ou ARN de KMS é
  necessário.
- `required_tags` permite configurar as quatro tags de valor fixo exigidas pelo
  contexto, mas sua validação impede alterações ou remoções. A tag
  `Environment` é derivada de `environment`.
