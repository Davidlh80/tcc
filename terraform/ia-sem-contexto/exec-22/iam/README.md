# IAM Policy anexada a IAM Role

Blueprint Terraform para provisionar uma IAM Role com uma trust policy restrita a um principal configuravel, e uma IAM Policy com permissoes explicitamente delimitadas, anexada a essa role via `aws_iam_role_policy_attachment`.

## Visao geral

- A IAM Policy nunca fica solta: ela e criada e imediatamente anexada a role por meio de `aws_iam_role_policy_attachment`.
- A trust policy (assume role policy) e restrita a um unico principal configuravel (`var.trusted_principal_arn`), com validacao que impede o uso de `"*"` ou de um principal vazio.
- Suporte opcional a `sts:ExternalId` na trust policy, para cenarios de acesso cross-account (mitigacao de confused deputy).
- As acoes da policy sao definidas por statements explicitos (`var.policy_statements`); o uso da acao administrativa `"*"` e bloqueado por validacao.
- Tags sao aplicadas tanto na role quanto na policy.

## Uso

```
module "iam_role_with_policy" {
  source = "./"

  role_name              = "app-readonly-role"
  policy_name            = "app-readonly-policy"
  trusted_principal_arn  = "arn:aws:iam::123456789012:role/ci-deploy-role"

  policy_statements = [
    {
      sid       = "AllowReadOnlyS3Access"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = ["arn:aws:s3:::minha-app-bucket", "arn:aws:s3:::minha-app-bucket/*"]
    }
  ]

  tags = {
    ambiente = "producao"
    projeto  = "minha-app"
  }
}
```

## Principais variaveis

| Nome | Descricao | Obrigatoria |
| --- | --- | --- |
| `role_name` | Nome da IAM Role | Sim |
| `policy_name` | Nome da IAM Policy | Sim |
| `trusted_principal_arn` | ARN do principal autorizado a assumir a role (nao pode ser `"*"`) | Sim |
| `external_id` | External ID exigido na trust policy (cross-account) | Nao |
| `policy_statements` | Lista de statements (sid, effect, actions, resources) da policy | Nao (ha default seguro de exemplo) |
| `max_session_duration` | Duracao maxima da sessao assumida (3600 a 43200s) | Nao |
| `permissions_boundary_arn` | ARN de permissions boundary opcional | Nao |
| `tags` | Tags aplicadas a role e a policy | Nao |

## Outputs

| Nome | Descricao |
| --- | --- |
| `role_arn` | ARN da IAM Role criada |
| `role_name` | Nome da IAM Role criada |
| `role_id` | ID da IAM Role criada |
| `policy_arn` | ARN da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_id` | ID da IAM Policy criada |
| `assume_role_policy_json` | JSON da trust policy aplicada |

## Consideracoes de seguranca

- Nunca defina `trusted_principal_arn` como `"*"`; a validacao da variavel bloqueia esse valor, mas o operador deve sempre informar um ARN de conta, role ou usuario especifico.
- Evite declarar statements com a acao `"*"` (bloqueado por validacao) ou com recursos `"*"` quando o servico permitir delimitar ARNs especificos.
- Prefira usar `external_id` em cenarios de acesso cross-account para reduzir o risco de confused deputy.
- Utilize `permissions_boundary_arn` em ambientes que exigem um limite adicional de permissoes para a role.
- Revise periodicamente os `policy_statements` para garantir o principio de menor privilegio.
