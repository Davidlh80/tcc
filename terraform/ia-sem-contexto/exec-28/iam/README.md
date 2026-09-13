# IAM Policy - Blueprint Terraform

Blueprint para provisionar uma IAM Policy na AWS seguindo o principio de menor privilegio.

## Decisoes de design

- Os statements da policy sao construidos via `data.aws_iam_policy_document`, garantindo sintaxe JSON valida e permitindo revisao declarativa das permissoes.
- Wildcard `*` isolado em `actions` ou `resources` e bloqueado por `validation` nas variaveis, forcando o consumidor do modulo a declarar explicitamente as acoes e os ARNs permitidos.
- Nenhum valor sensivel ou credencial e fixado no codigo; a autenticacao do provider AWS deve ser feita externamente (variaveis de ambiente, perfil de credenciais, etc.).
- Nao ha backend remoto configurado, permitindo validacao local com `terraform init -backend=false`.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name        = "app-s3-read-only"
  policy_description = "Permite leitura de objetos em um bucket especifico"

  policy_statements = [
    {
      sid       = "AllowS3Read"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::my-app-bucket",
        "arn:aws:s3:::my-app-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|---|---|---|---|---|
| aws_region | Regiao AWS usada pelo provider | string | "us-east-1" | nao |
| policy_name | Nome da IAM Policy | string | - | sim |
| policy_description | Descricao da IAM Policy | string | "Managed by Terraform" | nao |
| path | Path da IAM Policy | string | "/" | nao |
| policy_statements | Lista de statements (sid, effect, actions, resources) | list(object) | - | sim |
| tags | Tags aplicadas ao recurso | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|---|---|
| policy_arn | ARN da IAM Policy criada |
| policy_id | ID da IAM Policy criada |
| policy_name | Nome da IAM Policy criada |

## Validacao

```bash
terraform init -backend=false
terraform validate
```

## Consideracoes de seguranca

- Prefira `actions` e `resources` especificos em vez de prefixos amplos (ex: `s3:*`) sempre que possivel.
- Revise periodicamente as policies geradas com ferramentas de analise estatica (ex: `checkov`, `tfsec`) para identificar excesso de privilegio.
- Anexe esta policy a roles ou usuarios via `aws_iam_role_policy_attachment` ou `aws_iam_user_policy_attachment`, que nao fazem parte deste blueprint.
