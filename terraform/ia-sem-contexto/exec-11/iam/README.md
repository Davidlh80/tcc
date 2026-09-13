# IAM Policy — Blueprint Terraform

Blueprint para provisionamento de uma IAM Policy gerenciada pela AWS (customer managed policy), construida a partir de uma lista configuravel de statements.

## Visao geral

Este modulo cria:

- Um documento de policy (`data.aws_iam_policy_document`) montado dinamicamente a partir da variavel `policy_statements`.
- Uma IAM Policy (`aws_iam_policy`) com o documento acima, nome, path, descricao e tags configuraveis.

## Decisoes de design

- **Sem wildcard em actions**: por padrao e por validacao, o uso de `"*"` no campo `actions` de qualquer statement e bloqueado, forcando a especificacao explicita das permissoes necessarias (principio do menor privilegio).
- **Statements configuraveis**: a variavel `policy_statements` permite compor a policy com multiplos statements (`Allow`/`Deny`, actions, resources e `sid` opcional), sem alterar o codigo do modulo.
- **Nenhum valor sensivel fixo**: nenhum ARN de conta, chave de acesso ou identificador real esta hardcoded; o exemplo padrao usa um bucket fictício (`example-bucket`) apenas para fins de validacao sintatica.
- **Tags padronizadas**: a tag `ManagedBy = "Terraform"` e sempre aplicada, alem das tags customizadas fornecidas em `tags`.

## Uso

```hcl
module "iam_policy" {
  source = "./"

  name        = "app-readonly-policy"
  description = "Permite leitura de objetos em um bucket especifico"

  policy_statements = [
    {
      sid       = "AllowReadSpecificBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::minha-conta-bucket",
        "arn:aws:s3:::minha-conta-bucket/*"
      ]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "time-plataforma"
  }
}
```

## Inputs

| Nome | Descricao | Tipo | Default | Obrigatorio |
|---|---|---|---|---|
| `region` | Regiao AWS do provider | `string` | `"us-east-1"` | nao |
| `name` | Nome da IAM Policy | `string` | - | sim |
| `description` | Descricao da IAM Policy | `string` | `"Managed by Terraform"` | nao |
| `path` | Path da IAM Policy | `string` | `"/"` | nao |
| `tags` | Tags adicionais | `map(string)` | `{}` | nao |
| `policy_statements` | Lista de statements do documento de policy | `list(object)` | ver `variables.tf` | nao |

## Outputs

| Nome | Descricao |
|---|---|
| `policy_arn` | ARN da IAM Policy criada |
| `policy_id` | ID da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_document` | Documento JSON da policy gerada |

## Validacao

```bash
terraform init -backend=false
terraform validate
```

## Seguranca

- Nao inclua credenciais, ARNs de contas reais ou identificadores sensiveis diretamente no codigo; utilize variaveis e, preferencialmente, um arquivo `terraform.tfvars` fora do controle de versao.
- Revise sempre `actions` e `resources` de cada statement antes de aplicar em ambientes produtivos, garantindo aderencia ao principio do menor privilegio.
- Esta policy nao e anexada automaticamente a nenhuma role, user ou group — o attachment deve ser feito por um modulo/recurso separado (`aws_iam_role_policy_attachment`, `aws_iam_user_policy_attachment` ou `aws_iam_group_policy_attachment`), conforme o principio de separacao de responsabilidades.
