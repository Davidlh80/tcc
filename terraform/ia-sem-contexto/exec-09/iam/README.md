Nome
Blueprint Terraform — AWS IAM Policy (Managed Policy)

Descrição
Este módulo cria uma IAM Managed Policy na AWS com foco em segurança por padrão (somente leitura em serviços comuns) e permite, opcionalmente, anexá-la a usuários, roles e grupos existentes.

Recursos criados
- aws_iam_policy
- aws_iam_user_policy_attachment (opcional)
- aws_iam_role_policy_attachment (opcional)
- aws_iam_group_policy_attachment (opcional)

Uso rápido
- Clone ou copie os arquivos para um diretório.
- Ajuste variáveis conforme necessário em um tfvars ou diretamente via CLI.

Exemplo mínimo
- Permissão somente leitura básica em EC2/IAM e listagem de buckets S3 (padrão do módulo).

variables.tf principal
- aws_region: "us-east-1"
- policy_name: "tf-readonly-policy"
- policy_path: "/"
- policy_description: "Managed by Terraform - Read-only baseline policy"
- actions: ["ec2:Describe*", "s3:ListAllMyBuckets", "iam:Get*", "iam:List*"]
- resources: ["*"]
- deny_actions: []
- deny_resources: ["*"]
- attach_to_users: []
- attach_to_roles: []
- attach_to_groups: []
- tags: {}

Exemplo de customização
- Definir ações específicas e anexar a uma role existente:
terraform apply -var='policy_name=app-logs-read' -var='actions=["logs:GetLogEvents","logs:FilterLogEvents","logs:DescribeLogStreams","logs:DescribeLogGroups"]' -var='resources=["*"]' -var='attach_to_roles=["my-existing-role"]'

Fluxo de execução
1) Inicialização local (sem backend remoto):
   terraform init -backend=false

2) Validação estática:
   terraform validate

3) Plano:
   terraform plan -out=plan.tfplan

4) Aplicação:
   terraform apply plan.tfplan

5) Destruir (quando necessário):
   terraform destroy

Boas práticas e notas
- Least privilege: utilize recursos e ações mais específicos quando possível.
- Condições: este blueprint oferece uma política de Allow e, opcionalmente, uma de Deny. Para cenários complexos (conditions, not_actions, principals), adapte o data.aws_iam_policy_document conforme necessário.
- Anexos: garantir que usuários, roles e grupos já existam na conta antes de aplicar.
- Tags: inclua tags relevantes para rastreabilidade (ex.: Owner, CostCenter, Environment).

Saída (outputs)
- policy_arn: ARN da policy criada.
- policy_name: Nome da policy.
- policy_path: Caminho da policy.
- policy_id: ID único da policy.
- default_version_id: Versão padrão da policy.
- policy_document_json: Documento JSON final da policy.
- attached_users / attached_roles / attached_groups: Entidades às quais a policy foi solicitada para anexo.
- attachments_count: Soma total dos anexos.

Compatibilidade
- Terraform >= 1.0
- Provider AWS >= 4.0 e < 6.0

Limitações conhecidas
- Não cria usuários/roles/grupos; apenas anexa a existentes.
- Não utiliza backend remoto (compatível com init -backend=false).
