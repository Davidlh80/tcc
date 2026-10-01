# IAM Role com IAM Policy Anexada

Blueprint Terraform que provisiona uma IAM Role e uma IAM Policy dedicada, anexadas entre si via aws_iam_role_policy_attachment. A policy nunca fica solta: ela e criada e anexada a uma role especifica na mesma execucao.

## Recursos criados

- aws_iam_role.this: role com trust policy (assume role policy) configuravel.
- aws_iam_policy.this: policy com permissoes minimas, escopadas por padrao a um CloudWatch Log Group especifico (sem uso de wildcard "*" em Action ou Resource por padrao).
- aws_iam_role_policy_attachment.this: anexa a policy criada a role criada.

## Principal de confianca (trust policy)

O principal autorizado a assumir a role e definido por duas variaveis combinaveis:

- trusted_service_principals: lista de service principals AWS (padrao: ["ec2.amazonaws.com"]).
- trusted_aws_principals: lista de ARNs de contas/roles/usuarios AWS.

Pelo menos uma das duas listas deve conter valores, caso contrario a trust policy ficara sem Principal valido e o provider AWS rejeitara a criacao da role. Ajuste essas variaveis conforme o servico ou conta que ira assumir a role (por exemplo, lambda.amazonaws.com para funcoes Lambda, ou o ARN de outra conta para acesso cross-account).

## Privilegios da policy

Por padrao, a policy concede apenas as actions logs:CreateLogGroup, logs:CreateLogStream e logs:PutLogEvents, restritas ao ARN do log group definido em log_group_name. Para adaptar a outros casos de uso, ajuste as variaveis policy_actions e log_group_name, ou edite o bloco Statement em main.tf para adicionar novos recursos, sempre evitando Resource = "*" e Action = "*" sempre que possivel.

## Variaveis principais

- aws_region: regiao usada pelo provider AWS.
- role_name / role_description: identificacao da role.
- max_session_duration: duracao maxima da sessao assumida (3600 a 43200 segundos).
- permissions_boundary_arn: ARN opcional de permissions boundary.
- trusted_service_principals / trusted_aws_principals: definem quem pode assumir a role.
- policy_name / policy_description: identificacao da policy.
- log_group_name: recurso ao qual a policy e restrita.
- policy_actions: actions permitidas pela policy.
- tags: tags aplicadas a role e a policy.

## Outputs

- role_arn, role_name, role_id: identificadores da IAM Role.
- policy_arn, policy_name: identificadores da IAM Policy.
- policy_attachment_id: identificador do anexo entre policy e role.

## Validacao local

Este modulo nao usa backend remoto e nao depende de credenciais reais para validacao sintatica:

  terraform init -backend=false
  terraform validate
  terraform fmt -check

Para aplicar de fato, configure credenciais AWS validas e ajuste as variaveis conforme o ambiente de destino.

## Boas praticas aplicadas

- Nenhum valor sensivel fixo no codigo; toda configuracao e feita via variaveis.
- Policy escopada por recurso especifico em vez de wildcard, por padrao.
- Role exige explicitamente um principal de confianca, nunca fica sem Principal associado.
- Suporte a permissions boundary para reforcar limites de privilegio quando necessario.
- Tags configuraveis para rastreabilidade e governanca de custos/seguranca.
