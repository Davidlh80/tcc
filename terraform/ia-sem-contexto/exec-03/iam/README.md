# IAM Policy - Blueprint Terraform

Blueprint autonomo para provisionamento de uma IAM Policy na AWS, gerado sem vinculo com padroes organizacionais especificos, seguindo boas praticas gerais de mercado para Terraform e AWS.

## Objetivo

Criar uma `aws_iam_policy` com uma statement unica, construida via `aws_iam_policy_document`, permitindo configurar effect, actions, resources, nome, path, descricao e tags por meio de variaveis.

## Decisoes de seguranca

- Nao ha valores de credenciais fixos no codigo; toda configuracao sensivel deve ser fornecida via variaveis ou variaveis de ambiente do provider AWS.
- As variaveis `actions` e `resources` possuem validacao que bloqueia o uso de `*` isolado, forcando o autor da configuracao a declarar explicitamente as permissoes e recursos necessarios (principio do menor privilegio).
- O valor padrao de `actions`/`resources` e apenas um exemplo ilustrativo de acesso restrito a um bucket S3 especifico; ajuste conforme a necessidade real antes de aplicar em um ambiente real.
- Tags sao opcionais e ficam a criterio de quem consome o modulo.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name = "app-read-only-s3"
  description = "Permite leitura de objetos em um bucket especifico"
  effect      = "Allow"
  actions     = ["s3:GetObject", "s3:ListBucket"]
  resources   = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  tags = {
    ambiente = "producao"
    time     = "plataforma"
  }
}
```

## Requisitos

| Nome | Versao |
|------|--------|
| terraform | >= 1.5.0 |
| aws | ~> 5.0 |

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|------|-----------|------|---------|-------------|
| aws_region | Regiao AWS do provider | string | "us-east-1" | nao |
| policy_name | Nome da IAM Policy | string | "example-least-privilege-policy" | nao |
| description | Descricao da IAM Policy | string | "Policy gerenciada via Terraform seguindo o principio do menor privilegio." | nao |
| path | Path da IAM Policy | string | "/" | nao |
| effect | Effect da statement (Allow/Deny) | string | "Allow" | nao |
| actions | Lista de actions da policy | list(string) | ["s3:GetObject", "s3:ListBucket"] | nao |
| resources | Lista de ARNs de recursos | list(string) | ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"] | nao |
| tags | Tags aplicadas ao recurso | map(string) | {} | nao |

## Outputs

| Nome | Descricao |
|------|-----------|
| policy_id | ID da IAM Policy criada |
| policy_arn | ARN da IAM Policy criada |
| policy_name | Nome da IAM Policy criada |
| policy_document_json | Documento JSON da policy gerado |

## Validacao local

```
terraform init -backend=false
terraform validate
```

Nenhum backend remoto e nenhuma credencial real sao necessarios para executar os comandos acima.
