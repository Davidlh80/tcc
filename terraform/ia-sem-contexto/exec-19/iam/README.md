# IAM Policy — Blueprint Terraform

Blueprint Terraform autonomo para provisionamento de uma IAM Policy na AWS, sem dependencia de padroes organizacionais especificos.

## O que este blueprint cria

- 1x `aws_iam_policy`, com documento gerado dinamicamente a partir da variavel `statements` usando `data.aws_iam_policy_document`.

## Principios de seguranca adotados

- Nenhum valor sensivel fixo no codigo; toda configuracao e feita via variaveis.
- Uso de wildcard (`*`) em `actions` ou `resources` e bloqueado por `validation` nas variaveis, forcando permissoes explicitas (least privilege).
- Nome e path da policy sao validados contra os padroes aceitos pela AWS antes do `apply`.
- Tag `ManagedBy = Terraform` e sempre aplicada, junto com tags adicionais definidas pelo usuario.
- Nao ha backend remoto configurado; o estado deve ser gerenciado conforme a politica de cada ambiente.

## Requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` ~> 5.0
- Credenciais AWS validas apenas para `apply`/`plan` (nao necessarias para `init`/`validate`).

## Uso

```
module "iam_policy" {
  source = "./"

  name        = "app-readonly-s3"
  description = "Permite leitura de objetos em um bucket especifico."

  statements = [
    {
      sid       = "AllowReadSpecificBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::meu-bucket",
        "arn:aws:s3:::meu-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Variaveis principais

| Nome          | Descricao                                              | Obrigatoria | Default                          |
|---------------|---------------------------------------------------------|:-----------:|-----------------------------------|
| `aws_region`  | Regiao AWS do provider                                  | Nao         | `us-east-1`                       |
| `name`        | Nome da IAM Policy                                       | Sim         | -                                  |
| `description` | Descricao da policy                                      | Nao         | "Politica de IAM gerenciada..."   |
| `path`        | Path da policy na conta AWS                              | Nao         | `/`                                |
| `tags`        | Tags adicionais                                          | Nao         | `{}`                               |
| `statements`  | Lista de statements (effect, actions, resources, sid)    | Nao         | statement de exemplo (S3 leitura) |

## Outputs

| Nome                    | Descricao                                  |
|-------------------------|---------------------------------------------|
| `policy_arn`            | ARN da IAM Policy criada                     |
| `policy_id`             | ID da IAM Policy criada                      |
| `policy_name`           | Nome da IAM Policy criada                    |
| `policy_path`           | Path da IAM Policy criada                    |
| `policy_document_json`  | Documento JSON final da policy               |

## Validacao local

```
terraform init -backend=false
terraform validate
```
