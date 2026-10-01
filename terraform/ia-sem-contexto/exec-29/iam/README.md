# IAM Role com IAM Policy dedicada anexada

## Objetivo

Esta blueprint provisiona uma IAM Role na AWS com uma IAM Policy de privilegio minimo criada e anexada exclusivamente a ela, garantindo que a policy nunca fique solta (sem nenhum principal associado).

## Recursos criados

- `aws_iam_role.this`: IAM Role com trust policy (assume role policy) configuravel.
- `aws_iam_policy.this`: IAM Policy com statement de privilegio minimo (sem wildcards em actions ou resources).
- `aws_iam_role_policy_attachment.this`: anexa a policy criada diretamente a role criada.

## Decisoes de seguranca

- O trust policy (assume role) exige explicitamente ao menos um principal confiavel, seja um service principal AWS (`trusted_service_principals`) ou um ARN de conta/role/usuario (`trusted_principal_arns`). Um `precondition` na role impede a criacao de uma trust policy sem nenhum principal definido.
- As variaveis `policy_actions` e `policy_resources` possuem validacoes que rejeitam o uso do wildcard `"*"`, forcando o consumidor do modulo a declarar actions e recursos explicitos.
- Suporte opcional a `external_id` na condicao `sts:ExternalId`, recomendado para cenarios de assume role cross-account.
- Suporte opcional a `permissions_boundary_arn` para reforcar o limite maximo de permissoes da role.
- Nenhum valor sensivel ou credencial real e utilizado; todos os valores configuraveis sao expostos como variaveis com defaults seguros e ilustrativos.

## Uso basico

Defina as variaveis conforme o cenario desejado, por exemplo:

  role_name                  = "minha-app-role"
  trusted_service_principals = ["lambda.amazonaws.com"]
  policy_actions              = ["s3:GetObject"]
  policy_resources             = ["arn:aws:s3:::meu-bucket/*"]

## Validacao local

Este modulo nao utiliza backend remoto e nao depende de credenciais reais para validacao sintatica. E possivel validar com:

  terraform init -backend=false
  terraform validate

## Outputs

- `role_name`, `role_arn`, `role_id`: identificadores da IAM Role criada.
- `policy_name`, `policy_arn`: identificadores da IAM Policy criada.
- `policy_attachment_id`: identificador do vinculo entre a policy e a role.
