Nome
Blueprint Terraform para criar uma IAM Policy na AWS, com opcoes para documento JSON customizado e anexos opcionais a Roles, Users e Groups.

Recursos criados
- aws_iam_policy (obrigatorio)
- aws_iam_role_policy_attachment (opcional, por item)
- aws_iam_user_policy_attachment (opcional, por item)
- aws_iam_group_policy_attachment (opcional, por item)

Padroes seguros
- Politica padrao de privilegio minimo permitindo apenas sts:GetCallerIdentity, caso um documento JSON nao seja fornecido.
- Variaveis com validacoes para evitar erros comuns.

Como usar (exemplo rapido)
1) Ajuste variaveis no terraform.tfvars (opcional) ou via -var/-var-file.
2) Inicie e valide:
   - terraform init -backend=false
   - terraform validate
3) Planeje e aplique:
   - terraform plan
   - terraform apply

Exemplos de configuracao

Exemplo A: Usar politica padrao minima
- Defina somente:
  aws_region = "us-east-1"
  policy_name = "my-managed-policy"

Resultado: Criara uma policy que permite apenas sts:GetCallerIdentity no recurso "*".

Exemplo B: Fornecer documento JSON customizado
- Defina policy_document_json com o JSON completo da policy.
- Quando policy_document_json for fornecido, as variaveis default_actions e default_resources sao ignoradas.

Exemplo C: Anexar a entidades IAM existentes
- Informe listas em attach_to_roles, attach_to_users e/ou attach_to_groups com nomes existentes na conta.

Variaveis principais
- aws_region: Regiao do provider (default: us-east-1).
- policy_name: Nome da policy.
- policy_description: Descricao.
- policy_path: Caminho (path), ex: "/" ou "/aplicacao/projeto/".
- tags: Tags aplicadas ao recurso.
- policy_document_json: JSON completo da policy (opcional).
- policy_sid: SID do statement padrao quando nao for fornecido JSON.
- default_actions: Lista de acoes do statement padrao (default: ["sts:GetCallerIdentity"]).
- default_resources: Lista de recursos do statement padrao (default: ["*"]).
- attach_to_roles: Conjunto de nomes de roles para anexar (opcional).
- attach_to_users: Conjunto de nomes de users para anexar (opcional).
- attach_to_groups: Conjunto de nomes de groups para anexar (opcional).

Outputs
- policy_arn, policy_name, policy_path, policy_id, default_version_id
- effective_policy_document
- attached_to_roles, attached_to_users, attached_to_groups

Observacoes
- Este template nao configura backend remoto.
- A validacao sintatica nao depende de credenciais reais, mas a aplicacao em conta AWS exigira credenciais com permissoes adequadas.
- Anexos exigem que as entidades (roles/users/groups) ja existam. Caso contrario, a aplicacao falhara ao anexar. Se nao deseja anexar, deixe as variaveis correspondentes vazias.
