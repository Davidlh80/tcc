# IAM Policy — Blueprint Terraform

Blueprint standalone para provisionamento de uma IAM Policy na AWS, gerada de forma autonoma sem vinculo a padroes organizacionais especificos. Todas as decisoes de escopo (actions, resources, effect, condicoes) sao definidas via variaveis, forcando declaracao explicita e evitando wildcards acidentais.

## Recursos criados

- `aws_iam_policy.this`: a IAM Policy propriamente dita, com o documento gerado pelo data source `aws_iam_policy_document`.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name        = "app-s3-read-only"
  policy_description = "Permite leitura de objetos em um bucket especifico."
  effect             = "Allow"

  actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]

  resources = [
    "arn:aws:s3:::meu-bucket-exemplo",
    "arn:aws:s3:::meu-bucket-exemplo/*",
  ]

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Nome                  | Descricao                                                                 | Tipo           | Default                     | Obrigatorio |
|-----------------------|----------------------------------------------------------------------------|----------------|------------------------------|:-----------:|
| aws_region            | Regiao AWS usada pelo provider.                                           | `string`       | `"us-east-1"`                | nao          |
| policy_name           | Nome da IAM Policy.                                                       | `string`       | -                             | sim          |
| policy_description    | Descricao da IAM Policy.                                                  | `string`       | `"Gerenciada via Terraform."`| nao          |
| policy_path           | Path da IAM Policy (deve iniciar/terminar com `/`).                       | `string`       | `"/"`                         | nao          |
| statement_sid         | SID da statement da policy.                                               | `string`       | `"Statement1"`                | nao          |
| effect                | `Allow` ou `Deny`.                                                        | `string`       | `"Allow"`                     | nao          |
| actions               | Lista de actions IAM no formato `servico:Acao`.                          | `list(string)` | -                             | sim          |
| resources             | Lista de ARNs ou padroes de ARN.                                          | `list(string)` | -                             | sim          |
| conditions            | Lista de condicoes IAM (`test`, `variable`, `values`).                   | `list(object)` | `[]`                          | nao          |
| tags                  | Tags aplicadas ao recurso.                                                | `map(string)`  | `{}`                          | nao          |

## Outputs

| Nome                  | Descricao                                    |
|-----------------------|-----------------------------------------------|
| policy_arn            | ARN da IAM Policy criada.                     |
| policy_id             | ID da IAM Policy criada.                      |
| policy_name           | Nome da IAM Policy criada.                    |
| policy_document_json  | Documento JSON da policy gerado.              |

## Consideracoes de seguranca

- `actions` e `resources` sao obrigatorios e sem default, evitando que a policy seja criada acidentalmente com escopo amplo.
- Validacoes de variaveis rejeitam listas vazias e formatos invalidos de action.
- Recomenda-se fortemente evitar `"*"` em `actions` e `resources`; utilize ARNs e acoes especificas sempre que possivel.
- Utilize `conditions` para restringir ainda mais o uso da policy (ex.: `aws:SourceIp`, `aws:PrincipalTag`, `s3:prefix`).
- Este blueprint nao anexa a policy a nenhuma role, usuario ou grupo — o anexo deve ser feito separadamente conforme o principio do menor privilegio.

## Validacao

```bash
terraform init -backend=false
terraform validate
```
