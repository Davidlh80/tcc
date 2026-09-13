# IAM Policy (Terraform)

Blueprint Terraform para provisionar uma IAM Policy customizada na AWS, com escopo de actions, recursos e condicoes totalmente configuraveis via variaveis.

## Requisitos

- Terraform >= 1.5.0
- Provider `hashicorp/aws` >= 5.0
- Credenciais AWS validas apenas para `terraform apply` (nao necessarias para `terraform validate`)

## Recursos criados

- `aws_iam_policy.this`

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name = "app-s3-read-only"
  description = "Permite leitura de objetos em um bucket especifico"

  effect = "Allow"

  actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*",
  ]

  tags = {
    ambiente = "producao"
    time     = "plataforma"
  }
}
```

## Inputs

| Nome          | Tipo         | Obrigatorio | Default                      | Descricao                                                  |
|---------------|--------------|-------------|-------------------------------|-------------------------------------------------------------|
| policy_name   | string       | sim         | -                              | Nome da IAM Policy                                          |
| description   | string       | nao         | "Gerenciado via Terraform."   | Descricao da policy                                          |
| path          | string       | nao         | "/"                            | Path da IAM Policy                                          |
| sid           | string       | nao         | "PolicyStatement"             | Sid da statement                                             |
| effect        | string       | nao         | "Allow"                        | Allow ou Deny                                                |
| actions       | list(string) | sim         | -                              | Actions IAM da statement                                     |
| resources     | list(string) | sim         | -                              | ARNs de recursos alvo                                        |
| conditions    | list(object) | nao         | []                             | Condicoes IAM opcionais (test/variable/values)                |
| tags          | map(string)  | nao         | {}                             | Tags aplicadas ao recurso                                    |

## Outputs

| Nome                  | Descricao                                    |
|-----------------------|-----------------------------------------------|
| policy_arn            | ARN da IAM Policy criada                      |
| policy_id             | ID da IAM Policy criada                       |
| policy_name           | Nome da IAM Policy criada                     |
| policy_document_json  | JSON da policy renderizado                    |

## Consideracoes de seguranca

- Nao ha valores padrao para `actions` e `resources`: e necessario declarar explicitamente o escopo minimo de permissao.
- Evite usar `"*"` em `actions` ou `resources`; prefira ARNs e actions especificas seguindo o principio de menor privilegio.
- Use o campo `conditions` para restringir ainda mais o acesso (ex.: por IP de origem, MFA, tags de recurso).
- Revise o output `policy_document_json` antes de aplicar em ambientes produtivos.

## Validacao

```bash
terraform fmt
terraform init -backend=false
terraform validate
```
