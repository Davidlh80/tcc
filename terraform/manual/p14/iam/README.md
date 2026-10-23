# Template IAM

## Visão geral

Cria uma configuração de permissões seguindo o princípio do menor privilégio:

- uma policy IAM cujas ações e recursos são definidos por variável;
- uma role IAM com trust policy restrita a um único principal (`trusted_principal_arn`);
- o vínculo (attachment) da policy à role;
- validações que impedem o uso de `"*"` nas ações, nos recursos e no principal de confiança;
- tags padrão (`Project`, `Environment`, `ManagedBy`), que podem ser complementadas por `additional_tags`.

## Variáveis

| Nome | Tipo | Obrigatória | Descrição |
| --- | --- | --- | --- |
| `policy_name` | `string` | Sim | Nome da policy IAM com as permissões concedidas |
| `role_name` | `string` | Sim | Nome da role IAM que receberá a policy |
| `trusted_principal_arn` | `string` | Sim | ARN do único principal autorizado a assumir a role (não pode ser `"*"`) |
| `allowed_actions` | `list(string)` | Sim | Lista de ações IAM permitidas pela policy (não pode conter `"*"`) |
| `allowed_resources` | `list(string)` | Sim | Lista de ARNs dos recursos onde as ações são permitidas (não pode conter `"*"`) |
| `environment` | `string` | Não (padrão: `"dev"`) | Ambiente de implantação (`dev`, `hml` ou `prd`) |
| `additional_tags` | `map(string)` | Não (padrão: `{}`) | Tags extras aplicadas a todos os recursos |
| `region` | `string` | Não (padrão: `"us-east-1"`) | Região AWS onde os recursos serão criados |

## Outputs

| Nome | Descrição |
| --- | --- |
| `policy_name` | Nome da policy IAM |
| `policy_arn` | ARN da policy IAM |
| `policy_id` | ID da policy IAM |
| `role_name` | Nome da role IAM |
| `role_arn` | ARN da role IAM |

## Exemplo de uso

```hcl
module "iam" {
  source = "./terraform/manual/p14/iam"

  environment           = "dev"
  policy_name           = "dev-tcc-iam-leitura-s3"
  role_name             = "dev-tcc-iam-role-leitura-s3"
  trusted_principal_arn = "arn:aws:iam::123456789012:root"
  allowed_actions       = ["s3:GetObject", "s3:ListBucket"]
  allowed_resources = [
    "arn:aws:s3:::dev-tcc-s3-exemplo",
    "arn:aws:s3:::dev-tcc-s3-exemplo/*",
  ]
}
```

Para validar direto na pasta do template:

```bash
terraform init
terraform validate
```
