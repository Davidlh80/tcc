# IAM Policy anexada a IAM Role

## Visao geral

Este blueprint provisiona uma IAM Role e uma IAM Policy gerenciada, garantindo que a policy seja sempre anexada a role (nunca permanece orfa, sem principal associado). A trust policy (assume role policy) da role e restrita aos principals informados em `trusted_principal_arns`, nunca permitindo `"*"` ou `AWS: "*"`.

## Principais decisoes de seguranca

- A trust policy aceita apenas ARNs explicitos de conta, usuario ou role; curingas sao bloqueados por validacao de variavel.
- A policy anexada nao permite a action curinga total `"*"`, evitando acesso administrativo irrestrito.
- O uso de `"*"` em `allowed_resources` exige a flag explicita `allow_wildcard_resources = true`, reforcando o principio de menor privilegio por padrao.
- Suporte opcional a `external_id` na trust policy, util para cenarios cross-account e mitigacao do problema do "confused deputy".
- Suporte opcional a `permissions_boundary_arn`, permitindo uma camada adicional de controle sobre o que a role pode fazer mesmo que a policy anexada seja alterada no futuro.
- Tags sao aplicadas tanto na role quanto na policy.

## Recursos criados

- `aws_iam_role.this`
- `aws_iam_policy.this`
- `aws_iam_role_policy_attachment.this`

## Variaveis principais

- `role_name`, `policy_name`: nomes obrigatorios da role e da policy.
- `trusted_principal_arns`: lista obrigatoria de ARNs autorizados a assumir a role.
- `allowed_actions`, `allowed_resources`: escopo das permissoes concedidas pela policy.
- `allow_wildcard_resources`: interruptor explicito para permitir recursos curinga, desligado por padrao.
- `external_id`, `permissions_boundary_arn`, `max_session_duration`, `tags`: controles adicionais opcionais.

Consulte `variables.tf` para a lista completa, com descricoes e valores padrao.

## Outputs

- `role_arn`, `role_name`, `role_id`, `role_unique_id`
- `policy_arn`, `policy_name`, `policy_id`
- `policy_attachment_id`: confirma que a policy esta de fato anexada a role.

## Exemplo de uso

Defina as variaveis obrigatorias em um arquivo `terraform.tfvars` (ou via `-var`) informando `role_name`, `policy_name`, `trusted_principal_arns` com o ARN da conta/role/usuario que deve assumir a role, e `allowed_resources` com os ARNs dos recursos que a policy deve liberar. Em seguida execute o fluxo padrao de `terraform init`, `terraform plan` e `terraform apply`.

## Validacao local

Este modulo foi escrito para ser validado sem credenciais reais e sem backend remoto, por meio de `terraform init -backend=false` seguido de `terraform validate`.
