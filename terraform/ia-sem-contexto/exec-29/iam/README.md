Blueprint Terraform — AWS IAM Policy

Descrição
- Este template cria uma IAM Policy gerenciada (customer managed policy) na AWS.
- O documento da policy pode ser gerado a partir de variáveis tipadas (effect, actions, resources e additional_statements) ou definido diretamente via policy_json (que substitui o documento gerado).

Pré-requisitos
- Terraform >= 1.0.0
- Provider AWS ~> 5.x
- Credenciais AWS válidas configuradas no ambiente (ex.: variáveis de ambiente AWS ou perfil local). Não são definidas neste template.

Arquivos
- versions.tf: versões mínimas do Terraform e do provider.
- variables.tf: variáveis configuráveis com validações.
- main.tf: provider, documento da policy e recurso aws_iam_policy.
- outputs.tf: saídas úteis após a criação.
- README.md: instruções e notas.

Como usar
1) Ajuste as variáveis necessárias, por exemplo:
- aws_region (padrão: us-east-1)
- policy_name
- policy_description
- path
- effect, actions, resources
- additional_statements (lista de declarações extras)
- OU forneça policy_json com um documento IAM completo em JSON para substituir o documento gerado
- tags (mapa de chaves/valores)

2) Execute os comandos:
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Padrões seguros adotados
- Efeito padrão Allow com ações de leitura não privilegiadas (iam:GetAccountSummary) e resources = ["*"].
- Possibilidade de usar Deny e restringir por recursos conforme necessidade.
- Tags padrão incluem ManagedBy=terraform e Component=iam-policy (pode ser mesclado com tags customizadas).

Variáveis principais
- aws_region: Região AWS (ex.: us-east-1).
- policy_name: Nome da policy. Respeita o padrão AWS [\\w+=,.@-]{1,128}.
- path: Caminho da policy. Deve iniciar e terminar com “/”.
- policy_description: Descrição da policy.
- effect: Allow ou Deny para a declaração principal.
- actions: Lista de ações para a declaração principal.
- resources: Lista de recursos para a declaração principal.
- additional_statements: Lista de objetos com effect, actions e resources para compor mais declarações.
- policy_json: JSON completo opcional que, se fornecido, será usado no lugar do documento gerado.
- tags: Tags adicionais.

Outputs
- iam_policy_arn: ARN da policy.
- iam_policy_name: Nome da policy.
- iam_policy_id: ID da policy.
- iam_policy_path: Path da policy.
- iam_policy_document: JSON efetivo da policy.
- iam_policy_tags: Tags aplicadas.

Notas
- Este template não configura backend remoto e não depende de credenciais reais para validação sintática.
- Para produção, personalize actions/resources para o princípio do menor privilégio.
