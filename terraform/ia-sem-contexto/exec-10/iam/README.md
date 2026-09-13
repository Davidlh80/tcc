# IAM Policy — Blueprint Terraform

Blueprint Terraform para provisionamento de uma AWS IAM Policy gerenciada, com privilegio minimo aplicado por padrao.

## Decisoes de seguranca

- Todas as `actions` e `resources` de cada statement devem ser declaradas explicitamente pelo consumidor do modulo.
- O uso de `"*"` irrestrito em `actions` ou `resources` e bloqueado por validacao (`variables.tf`), forcando escopo explicito (ex: `s3:GetObject`, `arn:aws:s3:::meu-bucket/*`).
- O documento da policy e construido via `data.aws_iam_policy_document`, evitando JSON manual propenso a erros de sintaxe.
- Nao ha valores sensiveis ou credenciais fixas no codigo.
- Nao ha backend remoto configurado; o estado e local, adequado para validacao (`terraform init -backend=false` / `terraform validate`).

## Uso

```hcl
module "iam_policy_exemplo" {
  source = "./"

  policy_name        = "app-leitura-s3"
  policy_description = "Permite leitura de objetos em um bucket especifico"
  policy_path        = "/"

  statements = [
    {
      sid       = "LeituraS3"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::meu-bucket-exemplo",
        "arn:aws:s3:::meu-bucket-exemplo/*"
      ]
    }
  ]

  tags = {
    ambiente = "producao"
    time     = "plataforma"
  }
}
```

## Requisitos

| Nome      | Versao   |
|-----------|----------|
| terraform | >= 1.5.0 |
| aws       | ~> 5.0   |

## Inputs

| Nome                | Descricao                                                                 | Tipo                 | Padrao                     | Obrigatorio |
|---------------------|----------------------------------------------------------------------------|-----------------------|-----------------------------|:-----------:|
| policy_name          | Nome da IAM Policy (1-128 caracteres, padrao AWS)                          | `string`               | n/a                          | sim          |
| policy_description   | Descricao da IAM Policy                                                    | `string`               | `"Gerenciada via Terraform."` | nao          |
| policy_path          | Path da IAM Policy (deve iniciar e terminar com `/`)                       | `string`               | `"/"`                        | nao          |
| statements           | Lista de statements (sid, effect, actions, resources) da policy            | `list(object)`         | n/a                          | sim          |
| tags                 | Tags aplicadas ao recurso                                                   | `map(string)`          | `{}`                         | nao          |

## Outputs

| Nome                  | Descricao                                      |
|-----------------------|-------------------------------------------------|
| policy_arn             | ARN da IAM Policy criada                        |
| policy_id              | ID da IAM Policy criada                         |
| policy_name            | Nome da IAM Policy criada                       |
| policy_path            | Path da IAM Policy criada                       |
| policy_document_json   | Documento JSON efetivo gerado para a policy     |

## Validacao local

```bash
terraform init -backend=false
terraform validate
```
