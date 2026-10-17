# Blueprint IAM

Cria uma role IAM, uma policy customer-managed e o attachment entre elas. A
trust policy permite `sts:AssumeRole` somente ao servico definido em
`trusted_service`. A policy de permissao exige a configuracao de acoes e ARNs
especificos; a validacao rejeita acoes wildcard e o recurso global `*`.

## Variaveis

| Variavel | Tipo | Obrigatoria | Descricao |
|---|---|---:|---|
| `aws_region` | `string` | Sim | Regiao AWS do provider. |
| `role_name` | `string` | Sim | Nome da role IAM. |
| `policy_name` | `string` | Sim | Nome da policy IAM. |
| `environment` | `string` | Sim | `dev`, `staging` ou `prod`. |
| `trusted_service` | `string` | Sim | Principal de servico AWS confiavel, como `ec2.amazonaws.com`. |
| `allowed_actions` | `list(string)` | Sim | Acoes IAM sem curingas. |
| `allowed_resources` | `list(string)` | Sim | ARNs especificos permitidos. |
| `additional_tags` | `map(string)` | Nao | Tags adicionais; padrao `{}`. Tags padrao do projeto prevalecem. |

## Outputs

`policy_name`, `policy_arn`, `policy_id`, `role_name` e `role_arn`.

## Exemplo

```hcl
aws_region        = "us-east-1"
role_name         = "p31-app-reader"
policy_name       = "p31-app-reader-policy"
environment       = "dev"
trusted_service   = "ec2.amazonaws.com"
allowed_actions   = ["s3:GetObject"]
allowed_resources = ["arn:aws:s3:::app-data/private/*"]
```

Coloque os valores em `terraform.tfvars` local, sem incluir credenciais AWS no
arquivo.
