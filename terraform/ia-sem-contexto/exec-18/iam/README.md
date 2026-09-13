# IAM Policy — Blueprint Terraform

Blueprint para provisionamento de uma IAM Policy gerenciada pelo cliente (customer managed policy) na AWS, com foco em menor privilegio: nenhum statement e definido por padrao, obrigando o consumidor do modulo a declarar explicitamente as actions e resources permitidos.

## Recursos criados

- `data.aws_iam_policy_document.this`: monta o documento JSON da policy a partir dos statements informados.
- `aws_iam_policy.this`: cria a IAM Policy com o documento gerado.

## Requisitos

- Terraform >= 1.5.0
- Provider AWS >= 5.0
- Credenciais AWS validas configuradas no ambiente (nao necessarias para `terraform validate`).

## Variaveis principais

| Nome                  | Descricao                                                                 | Obrigatorio | Default                     |
|-----------------------|----------------------------------------------------------------------------|-------------|------------------------------|
| `aws_region`          | Regiao AWS usada pelo provider.                                            | Nao         | `us-east-1`                  |
| `policy_name`         | Nome da IAM Policy.                                                        | Sim         | -                             |
| `policy_description`  | Descricao da policy.                                                       | Nao         | `Gerenciada via Terraform.`  |
| `path`                | Path da policy dentro da conta AWS.                                        | Nao         | `/`                           |
| `statements`          | Lista de statements (sid, effect, actions, resources) da policy.          | Sim         | -                             |
| `tags`                | Tags aplicadas ao recurso.                                                 | Nao         | `{}`                          |

## Boas praticas de seguranca

- Evite o uso de `actions = ["*"]` ou `resources = ["*"]`; declare apenas as permissoes minimas necessarias.
- Utilize `effect = "Deny"` explicitamente para reforcar restricoes criticas quando necessario.
- Prefira ARNs completos e especificos em `resources`, evitando escopos amplos.
- Revise periodicamente as policies criadas para remover permissoes nao utilizadas.

## Exemplo de uso

```hcl
module "iam_policy" {
  source = "./"

  policy_name        = "app-read-only-s3"
  policy_description = "Permite leitura de objetos em um bucket especifico."

  statements = [
    {
      sid       = "AllowReadBucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::exemplo-bucket",
        "arn:aws:s3:::exemplo-bucket/*"
      ]
    }
  ]

  tags = {
    Ambiente = "producao"
    Time     = "plataforma"
  }
}
```

## Validacao

```
terraform init -backend=false
terraform validate
```
