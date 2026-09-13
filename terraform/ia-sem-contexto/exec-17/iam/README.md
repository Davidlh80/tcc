# IAM Policy - Blueprint Terraform

Blueprint Terraform para provisionar uma IAM Policy gerenciada na AWS de forma parametrizavel, sem vinculo com padroes organizacionais especificos.

## Recursos criados

- `aws_iam_policy.this`
- `data.aws_iam_policy_document.this`

## Caracteristicas de seguranca

- Nenhum valor sensivel fixo no codigo; todos os parametros sao configuraveis via variaveis.
- Por padrao, statements com acao wildcard total (`"*"`) sao bloqueados por uma `precondition`. Para permitir explicitamente, defina `allow_wildcard_actions = true`.
- Statement de exemplo padrao segue privilegio minimo (somente uma acao de leitura).
- Suporte a `condition` blocks do IAM Policy Document para restringir ainda mais o escopo de cada permissao.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name        = "app-readonly-policy"
  policy_description = "Permite leitura de instancias EC2 para o time de plataforma."
  policy_path        = "/plataforma/"

  statements = [
    {
      sid       = "AllowDescribeEC2"
      effect    = "Allow"
      actions   = ["ec2:DescribeInstances", "ec2:DescribeTags"]
      resources = ["*"]
    }
  ]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Inputs

| Nome                     | Tipo         | Padrao                              | Descricao                                                          |
|--------------------------|--------------|--------------------------------------|---------------------------------------------------------------------|
| policy_name              | string       | n/a (obrigatorio)                    | Nome da IAM Policy.                                                 |
| policy_description       | string       | "Managed by Terraform."             | Descricao da IAM Policy.                                            |
| policy_path              | string       | "/"                                  | Path da IAM Policy.                                                 |
| allow_wildcard_actions   | bool         | false                                 | Permite ou nao acoes wildcard total (`"*"`).                        |
| statements               | list(object) | statement de exemplo (leitura EC2)  | Lista de statements do IAM Policy Document.                         |
| tags                     | map(string)  | {}                                    | Tags aplicadas ao recurso.                                          |

## Outputs

| Nome                  | Descricao                                  |
|-----------------------|---------------------------------------------|
| policy_arn            | ARN da IAM Policy criada.                   |
| policy_id             | ID da IAM Policy criada.                    |
| policy_name           | Nome da IAM Policy criada.                  |
| policy_path           | Path da IAM Policy criada.                  |
| policy_document_json  | Documento JSON gerado para a policy.        |

## Validacao

```bash
terraform init -backend=false
terraform validate
```
