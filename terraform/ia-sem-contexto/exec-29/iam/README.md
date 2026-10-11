# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Policy de minimo privilegio anexada a uma IAM Role na AWS, com trust policy restrita a um principal configuravel.

## O que este modulo cria

- Uma `aws_iam_role` com uma trust policy (`assume_role_policy`) que permite `sts:AssumeRole` apenas para o principal informado em `trusted_principal_arn`. Nenhum wildcard (`"*"` ou `AWS: "*"`) e aceito nesse campo.
- Uma `aws_iam_policy` com permissoes definidas por `policy_actions` e `policy_resources`. Nenhuma das duas listas pode conter `"*"`, evitando permissoes amplas ou administrativas acidentais.
- Um `aws_iam_role_policy_attachment` que anexa a policy diretamente a role, garantindo que a policy nunca fique solta sem um principal associado.

## Uso

```
module "restricted_role" {
  source = "./"

  role_name              = "minha-role"
  policy_name            = "minha-policy"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/outra-role"
  policy_actions         = ["s3:GetObject", "s3:ListBucket"]
  policy_resources       = ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]

  tags = {
    Ambiente = "dev"
  }
}
```

## Inputs principais

| Nome                     | Descricao                                                                 | Obrigatorio |
|--------------------------|----------------------------------------------------------------------------|-------------|
| `trusted_principal_arn`  | ARN do principal autorizado a assumir a role. Nao pode ser wildcard.      | Sim         |
| `policy_resources`       | ARNs de recursos aos quais a policy se aplica. Nao pode ser `"*"`.        | Sim         |
| `policy_actions`         | Actions permitidas pela policy. Nao pode conter `"*"`.                    | Nao         |
| `role_name`              | Nome da IAM Role.                                                         | Nao         |
| `policy_name`            | Nome da IAM Policy.                                                       | Nao         |
| `max_session_duration`   | Duracao maxima da sessao assumida, em segundos (3600 a 43200).           | Nao         |
| `tags`                   | Tags aplicadas a role e a policy.                                         | Nao         |

## Outputs principais

- `role_arn`, `role_name`, `role_unique_id`
- `policy_arn`, `policy_name`
- `policy_attachment_id`

## Seguranca

- A trust policy exige um principal especifico; valores com wildcard (`"*"`) sao rejeitados por validacao da variavel.
- As actions e os resources da policy sao validados para impedir o uso de `"*"`, reduzindo o risco de permissoes administrativas ou excessivamente amplas.
- Nenhum valor sensivel ou credencial e fixado no codigo; todos os valores configuraveis sao expostos via variaveis.

## Validacao

Este modulo pode ser validado sem credenciais reais e sem backend remoto:

```
terraform init -backend=false
terraform validate
```
