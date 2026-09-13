# IAM Policy — Blueprint Terraform

Blueprint autonomo para provisionar uma IAM Policy gerenciada na AWS, com statements totalmente configuraveis via variavel.

## Recursos criados

- `aws_iam_policy.this`
- `data.aws_iam_policy_document.this`

## Decisoes de design

- Nenhum contexto organizacional foi assumido; os valores padrao seguem boas praticas gerais de mercado (menor privilegio, sem wildcard em `Action` ou `Resource`).
- O default de `var.statements` concede apenas `s3:GetObject` e `s3:ListBucket` sobre um bucket de exemplo (`example-bucket`), sem usar `"*"` em recursos ou acoes.
- Cada statement suporta `sid`, `effect` (default `Allow`), `actions`, `resources` e uma lista opcional de `conditions`, permitindo restringir ainda mais o acesso (ex.: `aws:SourceIp`, `aws:PrincipalTag`) sem alterar o codigo.
- Tags sao aplicadas por padrao para rastreabilidade (`ManagedBy = "Terraform"`).
- Nenhuma credencial real e necessaria para `terraform init -backend=false` e `terraform validate`; o provider `aws` usa apenas `var.aws_region`.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name        = "app-readonly-policy"
  policy_description = "Permite leitura de objetos em um bucket especifico"

  statements = [
    {
      sid       = "ReadAppBucket"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::app-bucket",
        "arn:aws:s3:::app-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default |
|---|---|---|---|
| aws_region | Regiao AWS do provider | string | "us-east-1" |
| policy_name | Nome da IAM Policy | string | "example-readonly-policy" |
| policy_description | Descricao da IAM Policy | string | "Policy gerenciada via Terraform..." |
| policy_path | Path da IAM Policy | string | "/" |
| tags | Tags aplicadas ao recurso | map(string) | { ManagedBy = "Terraform" } |
| statements | Lista de statements do documento de policy | list(object) | ver `variables.tf` |

## Outputs

| Nome | Descricao |
|---|---|
| policy_arn | ARN da IAM Policy criada |
| policy_id | ID da IAM Policy criada |
| policy_name | Nome da IAM Policy criada |
| policy_document | Documento JSON gerado a partir dos statements |

## Consideracoes de seguranca

- Evite adicionar `"*"` em `actions` ou `resources` nos statements; prefira ARNs especificos e acoes minimas necessarias.
- Utilize `conditions` para restringir ainda mais o alcance da policy (ex.: por IP, VPC endpoint ou tag).
- Revise o `policy_document` de saida antes de anexar a policy a usuarios, grupos ou roles.
