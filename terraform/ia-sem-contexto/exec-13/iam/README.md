# IAM Policy - Blueprint Terraform

## Descricao

Este blueprint provisiona uma IAM Policy gerenciada na AWS (`aws_iam_policy`), com o documento de permissoes construido dinamicamente a partir da variavel `statements`. Nenhum attachment a usuarios, grupos ou roles e realizado por este modulo — a policy e criada de forma desacoplada para ser anexada conforme a necessidade de cada consumidor.

## Principios de seguranca adotados

- Nenhum valor sensivel ou credencial e fixado no codigo.
- O exemplo padrao de `statements` segue o principio de menor privilegio (somente acoes de leitura em um servico especifico), evitando `Action = "*"` e `Resource = "*"`.
- Cada statement e validado para garantir `effect` restrito a `Allow` ou `Deny` e a obrigatoriedade de `actions` e `resources` explicitos.
- Recomenda-se fortemente que, ao customizar `statements`, os `resources` sejam escopados a ARNs especificos em vez de wildcards amplos.

## Uso

```
module "iam_policy" {
  source = "./"

  name        = "minha-policy-customizada"
  description = "Policy de exemplo"

  statements = [
    {
      sid       = "AllowS3ReadOnly"
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
    Owner       = "equipe-plataforma"
  }
}
```

## Inputs

| Nome        | Descricao                                   | Tipo                | Default                  |
|-------------|----------------------------------------------|---------------------|---------------------------|
| aws_region  | Regiao AWS usada pelo provider               | string               | "us-east-1"              |
| name        | Nome da IAM Policy                           | string               | "example-iam-policy"     |
| description | Descricao da IAM Policy                      | string               | "Managed by Terraform"   |
| path        | Path da IAM Policy                           | string               | "/"                      |
| tags        | Tags aplicadas a policy                      | map(string)          | {}                       |
| statements  | Lista de statements (sid, effect, actions, resources) | list(object) | exemplo de leitura em logs |

## Outputs

| Nome             | Descricao                                  |
|------------------|----------------------------------------------|
| policy_arn       | ARN da IAM Policy criada                     |
| policy_id        | ID da IAM Policy criada                      |
| policy_name      | Nome da IAM Policy criada                    |
| policy_document  | Documento JSON da policy gerado              |

## Validacao

Este blueprint foi projetado para ser validado sem credenciais reais e sem backend remoto:

```
terraform init -backend=false
terraform validate
```
