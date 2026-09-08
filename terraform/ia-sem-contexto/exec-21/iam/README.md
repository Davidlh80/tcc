# Terraform AWS IAM Policy

Blueprint mínima e segura por padrão para criar uma AWS IAM Policy usando Terraform.

Recursos:
- Gera o documento da policy localmente (sem depender de credenciais).
- Usa variáveis para tornar ações, recursos e condições configuráveis.
- Usa name_prefix por padrão para evitar colisões de nomes.
- Declarações adicionais opcionais.

Pré-requisitos:
- Terraform >= 1.3.0
- Provider AWS >= 5.0

Como usar (exemplo):
terraform init -backend=false
terraform validate
terraform plan
terraform apply

Exemplo de uso básico (main.tf do seu projeto chamando este módulo localmente):
module "iam_policy" {
  source = "./."

  aws_region  = "us-east-1"
  policy_name = "example-readonly"
  tags = {
    Project     = "example"
    Environment = "dev"
  }
}

Para adicionar condições e declarações extras:
module "iam_policy" {
  source = "./."

  policy_name = "custom-access"
  include_base_statement = true

  # Base: Allow com ações e recursos abaixo
  actions   = ["ec2:Describe*", "s3:ListAllMyBuckets", "s3:GetBucketLocation"]
  resources = ["*"]
  conditions = [
    {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  ]

  # Declarações adicionais
  additional_statements = [
    {
      sid       = "AllowSpecificBucketRead"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::my-audit-bucket",
        "arn:aws:s3:::my-audit-bucket/*"
      ]
    }
  ]

  tags = {
    Owner       = "team@example.com"
    CostCenter  = "1234"
    Environment = "prod"
  }
}

Variáveis:
- aws_region (string): Região do provider AWS. Padrão: us-east-1.
- policy_name (string): Nome base da policy (usado como prefixo por padrão).
- use_name_prefix (bool): Se true, usa policy_name como prefixo. Padrão: true.
- policy_description (string): Descrição da policy.
- policy_path (string): Caminho da policy (deve começar e terminar com /). Padrão: "/".
- tags (map(string)): Tags da policy. Padrão: {}.
- effect (string): Efeito da declaração base (Allow ou Deny). Padrão: Allow.
- actions (list(string)): Ações da declaração base. Padrão: conjunto de ações read-only comuns.
- resources (list(string)): Recursos da declaração base. Padrão: ["*"].
- base_statement_sid (string): SID da declaração base. Padrão: AllowReadOnlyAccess.
- conditions (list(object)): Condições opcionais da declaração base.
- include_base_statement (bool): Inclui a declaração base. Padrão: true.
- additional_statements (list(object)): Lista de declarações adicionais com campos:
  - sid (string, opcional)
  - effect (string, opcional; default Allow)
  - actions (list(string), obrigatório)
  - resources (list(string), obrigatório)
  - conditions (list(object), opcional)

Outputs:
- policy_arn: ARN da IAM Policy.
- policy_name: Nome efetivo.
- policy_id: ID interno.
- policy_path: Caminho.
- policy_default_version_id: Versão padrão da policy.
- policy_document_json: Documento JSON da policy.
- policy_tags: Tags aplicadas.

Notas:
- Este template evita o uso de backend remoto e não depende de credenciais reais para validação sintática.
- O documento da policy é montado localmente via aws_iam_policy_document.
- Garante, via precondition, que ao menos uma declaração será criada (base ou adicional).
