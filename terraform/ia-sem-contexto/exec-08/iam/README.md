# IAM Policy anexada a IAM Role

Blueprint Terraform autonoma, sem vinculo com padroes organizacionais especificos, para provisionar uma IAM Role e uma IAM Policy gerenciada anexada a ela. A policy nunca fica solta: e sempre criada junto com o `aws_iam_role_policy_attachment` que a vincula a role.

## Recursos criados

- `aws_iam_role.this`: role com trust policy (assume role policy) construida a partir de `aws_iam_policy_document`.
- `aws_iam_policy.this`: policy gerenciada com o conjunto de permissoes definido pelo consumidor do modulo.
- `aws_iam_role_policy_attachment.this`: anexa a policy a role.

## Decisoes de seguranca adotadas

- Nenhum valor sensivel ou credencial real e usado; toda configuracao e feita via variaveis.
- O trust policy (quem pode assumir a role) e explicito e configuravel via `assume_role_service_principals` (principals de servico AWS) e, opcionalmente, `trusted_account_ids` para cenarios cross-account.
- Quando `trusted_account_ids` e usado, recomenda-se preencher `external_id` para mitigar o problema do "confused deputy" em cenarios cross-account.
- A variavel `policy_actions` bloqueia, via `validation`, o uso do wildcard total `"*"` como action, forcando a listagem explicita de permissoes (privilegio minimo).
- `policy_resources` e obrigatoriamente uma lista nao vazia, evitando policies aplicadas a todos os recursos por omissao.
- `max_session_duration` e limitado ao intervalo valido da AWS (3600 a 43200 segundos).
- Nenhum backend remoto e configurado; o estado permanece local, adequado para validacao sintatica isolada.

## Variaveis principais

- `role_name`, `policy_name`, `role_path`: nomenclatura e path dos recursos IAM.
- `assume_role_service_principals`: service principals autorizados a assumir a role (padrao: `ec2.amazonaws.com`).
- `trusted_account_ids` e `external_id`: habilitam assume role cross-account de forma opcional e segura.
- `policy_actions` e `policy_resources`: definem o escopo de permissoes concedido pela policy.
- `max_session_duration`, `force_detach_policies`, `tags`: ajustes operacionais da role e da policy.

## Uso

1. Ajuste as variaveis conforme o caso de uso real (principals de confianca, actions e resources necessarios).
2. Execute `terraform init -backend=false` para inicializar o provider AWS sem backend remoto.
3. Execute `terraform validate` para checagem sintatica e de consistencia interna, sem necessidade de credenciais reais.
4. Para aplicar em um ambiente real, configure credenciais AWS validas e revise cuidadosamente `policy_actions` e `policy_resources` para o principio de privilegio minimo antes de `terraform apply`.

## Observacoes

- Os valores padrao (bucket S3 de exemplo, principal EC2) sao apenas ilustrativos e devem ser substituidos por valores reais do ambiente de destino antes de qualquer uso em producao.
- Este modulo nao presume nenhum padrao organizacional de nomenclatura, tags ou governanca; essas decisoes ficam a criterio de quem o consome.
