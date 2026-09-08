# Terraform AWS IAM Policy

Este módulo cria uma IAM Policy gerenciada (customer managed) na AWS de forma segura por padrão.

Principais características:
- Provider AWS com região configurável.
- Política de permissões construída via aws_iam_policy_document.
- Declaração opcional de negação total sem MFA (habilitada por padrão).
- Condições opcionais por região (aws:RequestedRegion) e por IP (aws:SourceIp).
- Variáveis com validações e tags incluídas.
- Sem backend remoto.

Requisitos:
- Terraform >= 1.3.0
- Provider AWS >= 5.0

Arquivos:
- main.tf
- variables.tf
- outputs.tf
- versions.tf
- README.md

Como usar:
1) Ajuste variáveis conforme necessidade (ex.: terraform.tfvars).
2) Execute:
   - terraform init -backend=false
   - terraform validate
   - terraform plan
   - terraform apply

Variáveis principais:
- aws_region: Região do provider (padrão: us-east-1).
- policy_name: Nome da policy (padrão: readonly-s3-policy).
- policy_description: Descrição opcional.
- policy_path: Caminho da policy (padrão: /customer-managed/).
- allowed_actions: Ações permitidas (padrão seguro de leitura S3).
- policy_resources: ARNs de recursos alvo (padrão usa bucket de exemplo).
- allowed_regions: Lista de regiões permitidas (condição opcional).
- allowed_source_ips: Lista de CIDRs IPv4 permitidos (condição opcional).
- enforce_mfa: Se true, nega tudo quando MFA não presente (padrão: true).
- allow_wildcard_actions: Permite uso de curingas em ações (padrão: false).
- allow_wildcard_resources: Permite recurso '*' (padrão: false).
- tags: Tags adicionais para a policy.

Notas de segurança:
- Por padrão, a policy é restritiva e voltada a leitura no S3, sem curingas.
- MFA é exigido por padrão via uma declaração Deny; desative se não se aplicar ao seu caso.
- Condições por região e IP podem ser usadas para reforçar o controle de acesso, mas podem não ser suportadas por todos os serviços.

Saídas:
- iam_policy_arn
- iam_policy_name
- iam_policy_id
- iam_policy_path
- iam_policy_document

Limitações:
- aws:SourceIp pode não ser avaliado para todas as APIs/serviços.
- Ajuste actions/resources conforme o serviço-alvo para obter o efeito desejado.
