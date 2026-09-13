# IAM Policy — Blueprint Terraform

Blueprint standalone para provisionamento de uma IAM Policy na AWS, gerado sem vínculo a padrões organizacionais específicos. Todas as decisões de nomenclatura, privilégio, tags e estrutura seguem boas práticas gerais de mercado para Terraform e AWS.

## Descrição

Este módulo cria uma `aws_iam_policy` a partir de uma lista configurável de statements (`var.statements`), renderizados via `data.aws_iam_policy_document`. O statement padrão fornecido é apenas um exemplo de acesso somente leitura a um bucket S3 e **deve ser substituído** pelas actions/resources reais antes do uso em produção.

## Requisitos

| Nome | Versão |
|---|---|
| terraform | >= 1.5.0 |
| aws | >= 5.0, < 6.0 |

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name        = "app-readonly-s3"
  policy_description = "Acesso somente leitura ao bucket de dados da aplicação X"

  statements = [
    {
      sid       = "AllowReadDataBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::meu-bucket-de-dados",
        "arn:aws:s3:::meu-bucket-de-dados/*",
      ]
    }
  ]

  tags = {
    Environment = "production"
    Owner       = "time-plataforma"
  }
}
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|---|---|---|---|---|
| aws_region | Região AWS do provider | `string` | `"us-east-1"` | não |
| policy_name | Nome da IAM Policy | `string` | — | sim |
| policy_description | Descrição da policy | `string` | texto padrão | não |
| path | Path da IAM Policy | `string` | `"/"` | não |
| tags | Tags aplicadas à policy | `map(string)` | `{}` | não |
| statements | Lista de statements da policy | `list(object)` | exemplo de leitura em S3 | não |

## Outputs

| Nome | Descrição |
|---|---|
| policy_arn | ARN da IAM Policy criada |
| policy_id | ID da IAM Policy criada |
| policy_name | Nome da IAM Policy criada |
| policy_document_json | JSON final do documento de policy |

## Considerações de segurança

- O módulo bloqueia, via `validation`, qualquer statement que combine `actions = ["*"]` com `resources = ["*"]`, evitando a criação acidental de uma policy com privilégio administrativo total.
- Substitua os valores de exemplo (`REPLACE_ME_BUCKET_NAME`) por ARNs reais e restrinja `actions` ao mínimo necessário (princípio de menor privilégio).
- Prefira anexar esta policy a **roles** ou **grupos** IAM em vez de usuários individuais.
- Utilize `tags` para rastreabilidade (owner, ambiente, custo) conforme a governança da sua organização.
- Nenhum valor sensível ou credencial é definido neste módulo; a autenticação do provider AWS deve ser feita externamente (variáveis de ambiente, perfil compartilhado, OIDC, etc.).
- Não há backend remoto configurado; defina um backend adequado ao seu ambiente antes de uso em produção.

## Validação local

```
terraform init -backend=false
terraform validate
```
