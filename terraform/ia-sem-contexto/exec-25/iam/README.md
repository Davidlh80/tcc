# IAM Policy - Blueprint Terraform

Blueprint standalone para provisionamento de uma IAM Policy na AWS, gerado sem vinculo a padroes organizacionais especificos, com base em boas praticas gerais de mercado para Terraform e AWS.

## Descricao

Este modulo cria uma unica `aws_iam_policy` a partir de um documento IAM (`aws_iam_policy_document`) construido dinamicamente com base nas variaveis de entrada:

- Effect (Allow/Deny)
- Actions
- Resources
- Condicoes opcionais (`condition`)

## Postura de seguranca

- O valor padrao de `resources` aponta para ARNs especificos de exemplo (nao usa `"*"` como padrao), forcando o consumidor do modulo a definir explicitamente o escopo real antes de aplicar em producao.
- O valor padrao de `actions` contem apenas acoes de leitura em S3, evitando privilegios amplos por padrao.
- A variavel `effect` e validada para aceitar somente `Allow` ou `Deny`.
- Suporte a `condition` permite restringir ainda mais o uso da policy (ex.: `aws:SourceIp`, `aws:PrincipalOrgID`, `s3:x-amz-server-side-encryption`, etc.).
- Recomenda-se sempre revisar o output `policy_document_json` antes de anexar a policy a roles, users ou groups.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name        = "app-s3-read-only"
  policy_description = "Permite leitura de objetos em bucket especifico"
  actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]
  resources = [
    "arn:aws:s3:::meu-bucket-real",
    "arn:aws:s3:::meu-bucket-real/*",
  ]

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Nome                 | Tipo           | Padrao                                   | Descricao                                            |
|----------------------|----------------|-------------------------------------------|-------------------------------------------------------|
| aws_region           | string         | "us-east-1"                              | Regiao AWS do provider                                |
| policy_name          | string         | "custom-iam-policy"                      | Nome da IAM Policy                                    |
| policy_description   | string         | "IAM policy gerenciada via Terraform..." | Descricao da policy                                   |
| policy_path          | string         | "/"                                      | Path da policy no IAM                                 |
| effect               | string         | "Allow"                                  | Effect da statement (Allow ou Deny)                   |
| actions              | list(string)   | ["s3:GetObject", "s3:ListBucket"]        | Actions IAM cobertas pela policy                      |
| resources            | list(string)   | ARNs de exemplo de bucket S3             | ARNs alvo da policy                                   |
| conditions           | list(object)   | []                                       | Condicoes IAM opcionais                               |
| tags                 | map(string)    | { ManagedBy = "terraform" }              | Tags aplicadas ao recurso                             |

## Outputs

| Nome                  | Descricao                                              |
|-----------------------|---------------------------------------------------------|
| policy_arn            | ARN da IAM Policy criada                                |
| policy_id             | ID da IAM Policy criada                                 |
| policy_name           | Nome da IAM Policy criada                               |
| policy_document_json  | Documento JSON renderizado da policy                    |

## Validacao

```
terraform init -backend=false
terraform validate
```

Nenhuma credencial real e necessaria para validacao sintatica, pois nao ha dependencia de chamadas de API neste modulo.
