Blueprint Terraform: IAM Policy AWS

Descrição
- Cria uma IAM Policy gerenciada na AWS com configurações seguras por padrão.
- Permite definir ações permitidas e, opcionalmente, ações negadas.

Arquivos
- main.tf: Provider, documento da policy e recurso aws_iam_policy.
- variables.tf: Declaração e validação de variáveis.
- outputs.tf: Saídas úteis (ARN, nome, ID, JSON da policy, etc).
- versions.tf: Versões mínimas do Terraform e do provider AWS.
- README.md: Instruções e exemplos.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (para aplicar)

Variáveis principais
- region (string): Região AWS. Padrão: us-east-1
- policy_name (string): Nome da policy. Padrão: tf-iam-policy
- policy_description (string): Descrição. Padrão: Managed by Terraform - example IAM policy
- policy_path (string): Caminho da policy. Padrão: /
- allowed_actions (list(string)): Ações permitidas. Padrão: ["sts:GetCallerIdentity"]
- resource_arns (list(string)): Recursos alvo (ou "*"). Padrão: ["*"]
- deny_actions (list(string)): Ações negadas (opcional). Padrão: []
- deny_resource_arns (list(string)): Recursos alvo para negação (opcional). Padrão: []
- tags (map(string)): Tags para a policy. Padrão: {}

Exemplo de uso
- Ajuste as variáveis conforme necessário, por exemplo via terraform.tfvars:
region = "us-east-1"
policy_name = "example-minimal-policy"
policy_description = "Policy de exemplo criada por Terraform"
allowed_actions = [
  "ec2:DescribeInstances",
  "s3:ListAllMyBuckets"
]
resource_arns = ["*"]
deny_actions = []
deny_resource_arns = []
tags = {
  Project = "terraform-iam-policy"
  Owner   = "devops"
}

Comandos
- Formatar: terraform fmt
- Validar: terraform validate
- Inicializar (sem backend remoto): terraform init -backend=false
- Plano: terraform plan
- Aplicar: terraform apply

Notas
- O exemplo padrão permite apenas sts:GetCallerIdentity em todos os recursos, útil para validação de credenciais.
- Para aumentar privilégio, adicione ações e restrinja resource_arns quando possível.
- Os blocos de negação são opcionais; se informados, uma declaração explícita Deny será criada.
