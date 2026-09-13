# IAM Policy - Blueprint Terraform

Blueprint autonomo para provisionamento de uma IAM Policy gerenciada pelo cliente (customer-managed policy) na AWS, sem vinculo com padroes organizacionais especificos. Todas as decisoes de nivel de privilegio, nomenclatura e escopo de recursos ficam a cargo de quem instancia o modulo, atraves das variaveis de entrada.

## Recursos criados

- `aws_iam_policy.this`: IAM Policy gerenciada, com documento JSON gerado dinamicamente via `data.aws_iam_policy_document.this`.

## Uso

```
module "iam_policy" {
  source = "./"

  policy_name         = "app-s3-read-only"
  policy_description  = "Permite leitura de objetos em um bucket especifico"
  effect              = "Allow"
  allowed_actions     = ["s3:GetObject", "s3:ListBucket"]
  allowed_resources   = [
    "arn:aws:s3:::meu-bucket",
    "arn:aws:s3:::meu-bucket/*"
  ]

  tags = {
    Environment = "dev"
    Owner       = "team-devops"
  }
}
```

## Inputs

| Nome                | Descricao                                                                 | Tipo         | Default              | Obrigatorio |
|---------------------|----------------------------------------------------------------------------|--------------|-----------------------|-------------|
| aws_region          | Regiao AWS do provider                                                     | string       | "us-east-1"           | nao         |
| policy_name         | Nome da IAM Policy                                                          | string       | -                     | sim         |
| policy_description  | Descricao da IAM Policy                                                    | string       | "Gerenciada via Terraform." | nao   |
| path                | Path da IAM Policy                                                          | string       | "/"                   | nao         |
| effect              | Efeito da statement (Allow ou Deny)                                        | string       | "Allow"               | nao         |
| allowed_actions     | Lista de acoes IAM permitidas/negadas                                       | list(string) | -                     | sim         |
| allowed_resources   | Lista de ARNs de recursos alvo                                              | list(string) | -                     | sim         |
| conditions          | Lista de condicoes IAM adicionais (test, variable, values)                  | list(object) | []                    | nao         |
| tags                | Tags aplicadas ao recurso                                                   | map(string)  | {}                    | nao         |

## Outputs

| Nome                  | Descricao                                          |
|-----------------------|-----------------------------------------------------|
| policy_arn            | ARN da IAM Policy criada                            |
| policy_id             | ID da IAM Policy criada                             |
| policy_name           | Nome da IAM Policy criada                           |
| policy_document_json  | Documento JSON efetivamente gerado para a policy    |

## Consideracoes de seguranca

- `allowed_actions` e `allowed_resources` sao obrigatorios e nao possuem default, forcando uma definicao explicita do escopo — evite usar `"*"` em qualquer um dos dois, exceto quando estritamente necessario e justificado.
- Utilize o bloco `conditions` para restringir a policy por IP de origem, MFA, tags de recurso, etc., sempre que possivel.
- Revise o `policy_document_json` de saida antes de anexar a policy a usuarios, grupos ou roles em ambientes de producao.
- Prefira anexar esta policy a roles (via `aws_iam_role_policy_attachment`) em vez de usuarios individuais.

## Validacao

```
terraform init -backend=false
terraform validate
```
