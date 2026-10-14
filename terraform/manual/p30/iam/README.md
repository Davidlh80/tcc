# IAM Role para workload

## 1. Visão geral do recurso

Este módulo cria uma IAM Role para workload, com política de confiança limitada
a um principal de serviço específico (por padrão, EC2), tags organizacionais e
uma permissions boundary opcional. Uma política customer-managed só é criada
quando há permissões solicitadas: acesso de leitura aos buckets S3 listados e
permissões adicionais explicitamente especificadas por ação e recurso.

A política não concede permissões sem configuração. Ela nunca cria usuários ou
credenciais de longa duração, não concede `iam:*`, `iam:PassRole` ou ações
wildcard de serviço. Por padrão, a policy gerenciada
`AmazonSSMManagedInstanceCore` é anexada para acesso administrativo por SSM. O
instance profile é criado por padrão para associação da Role a uma instância
EC2.

## 2. Tabela de variáveis (nome, tipo, obrigatória, descrição)

| Nome | Tipo | Obrigatória | Descrição |
|---|---|---|---|
| `environment` | `string` | Sim | Ambiente, limitado a `dev`, `hml` ou `prd`. |
| `system` | `string` | Sim | Identificador do sistema usado nos nomes dos recursos IAM. |
| `region` | `string` | Sim | Região AWS usada pelo provider. |
| `additional_tags` | `map(string)` | Não | Tags adicionais opcionais; padrão `{}`. Tags obrigatórias não podem ser sobrescritas. |
| `role_name` | `string` | Sim | Finalidade usada para formar os nomes da Role, da política e do instance profile. |
| `owner` | `string` | Sim | Responsável da tag `Owner`; deve ser `devops`. |
| `required_tags` | `map(string)` | Não | Tags de valor fixo `Project`, `ManagedBy` e `CostCenter`; padrão conforme o contexto organizacional. `Environment` e `Owner` são aplicadas a partir das variáveis correspondentes. |
| `trusted_principal_arn` | `string` | Não | Principal de serviço permitido a assumir a Role; padrão `ec2.amazonaws.com`. O nome segue a convenção organizacional e o valor deve terminar em `.amazonaws.com`. |
| `trust_source_account_id` | `string` | Não | ID de conta opcional (12 dígitos) para `aws:SourceAccount`; padrão `null`. |
| `trust_source_arn` | `string` | Não | ARN opcional para `aws:SourceArn`; padrão `null`. |
| `role_description` | `string` | Sim | Descrição não vazia da Role IAM. |
| `max_session_duration` | `number` | Não | Duração máxima da sessão, inteiro entre 3600 e 43200 segundos; padrão `3600`. |
| `permissions_boundary_arn` | `string` | Não | ARN IAM opcional de uma permissions boundary; padrão `null`. |
| `path` | `string` | Não | Path IAM da Role, política e instance profile; padrão `/`. |
| `s3_read_bucket_arns` | `list(string)` | Não | ARNs de buckets para `s3:ListBucket` e `s3:GetObject`; padrão `[]`. |
| `additional_allowed_actions_by_resource` | `map(object)` | Não | Statements adicionais, cada um com `sid`, `actions` e `resources`; padrão `{}`. Ações IAM/wildcard e recurso exatamente `*` são rejeitados. |
| `enable_ssm_access` | `bool` | Não | Anexa `AmazonSSMManagedInstanceCore`; padrão `true`. |
| `create_instance_profile` | `bool` | Não | Cria o instance profile associado à Role; padrão `true`. |

## 3. Tabela de outputs (nome, descrição)

| Nome | Descrição |
|---|---|
| `role_name` | Nome da Role IAM. |
| `role_arn` | ARN da Role IAM. |
| `role_unique_id` | ID exclusivo da Role IAM. |
| `policy_name` | Nome da política customer-managed, ou `null` se não criada. |
| `policy_arn` | ARN da política customer-managed, ou `null` se não criada. |
| `policy_id` | ID da política customer-managed, ou `null` se não criada. |
| `instance_profile_name` | Nome do instance profile, ou `null` se não criado. |
| `instance_profile_arn` | ARN do instance profile, ou `null` se não criado. |
| `permissions_boundary_arn` | ARN da permissions boundary aplicada, ou `null` se não configurada. |

## 4. Exemplo de uso do módulo/recurso

```hcl
variable "region" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

module "backend_role" {
  source = "./terraform/manual/p30/iam"

  environment  = "dev"
  system       = "tcc"
  region       = var.region
  role_name    = "backend"
  owner        = "devops"
  role_description    = "Role for the EC2 backend workload."

  trust_source_account_id = "123456789012"
  s3_read_bucket_arns     = ["arn:aws:s3:::example-bucket"]

  additional_allowed_actions_by_resource = {
    ReadSpecificParameter = {
      sid       = "ReadSpecificParameter"
      actions   = ["ssm:GetParameter"]
      resources = ["arn:aws:ssm:us-east-1:123456789012:parameter/example"]
    }
  }
}

resource "aws_instance" "backend" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = module.backend_role.instance_profile_name

  # Configure networking, security groups, and other required EC2 settings here.
}
```

O exemplo de instância ilustra apenas o vínculo pelo instance profile; a
criação da EC2 e suas demais configurações ficam fora deste módulo.

## 5. Recomendações fora do escopo do módulo

- Exija MFA para usuários humanos.
- Prefira federação/SSO em vez de IAM users.
- Proteja o usuário root e evite seu uso cotidiano.
- Use SCPs na organização para definir limites máximos de permissões.
- Use IAM Access Analyzer para validar políticas e identificar acesso público
  ou entre contas.
- Revise periodicamente permissões não utilizadas.
- Audite chamadas e alterações via CloudTrail.

## Premissas

- O contexto organizacional não fixa versões de Terraform ou do AWS provider;
  este template usa Terraform `>= 1.5.0` e AWS provider `~> 5.0`, conforme a
  faixa indicada na solicitação.
- A variável obrigatória pelo padrão organizacional
  `trusted_principal_arn` contém o nome DNS do principal de serviço AWS
  (padrão `ec2.amazonaws.com`), pois a política de confiança limita o principal
  ao tipo `Service`.
- A política customizada e seu attachment não são criados quando as listas de
  permissões estão vazias; a Role permanece sem permissões customizadas.
- O ID de conta nos exemplos é fictício e serve apenas como placeholder.
