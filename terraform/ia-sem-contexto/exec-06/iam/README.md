# Terraform AWS IAM Policy

Blueprint Terraform para criar uma IAM Policy gerenciada na AWS com configurações seguras por padrão e alta flexibilidade via variáveis.

Arquivos:
- main.tf
- variables.tf
- outputs.tf
- versions.tf
- README.md

Requisitos:
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas (por exemplo via `AWS_PROFILE`, `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`, ou `~/.aws/credentials`)

Recursos criados:
- aws_iam_policy (policy gerenciada)

Inputs principais:
- aws_region: Região AWS (padrão: us-east-1)
- aws_profile: Perfil de credenciais (opcional)
- policy_name: Nome da policy
- policy_description: Descrição da policy
- policy_path: Path da policy
- tags: Mapa de tags
- statements: Lista de statements (Least-Privilege recomendado)

Outputs:
- iam_policy_arn
- iam_policy_name
- iam_policy_id
- iam_policy_path
- iam_policy_tags
- iam_policy_document_json

Uso básico:
1) Ajuste variáveis em terraform.tfvars (opcional) ou via CLI.
2) Comandos:
   - terraform init -backend=false
   - terraform validate
   - terraform plan
   - terraform apply

Exemplo de configuração (terraform.tfvars):
aws_region  = "us-east-1"
policy_name = "s3-readonly-with-mfa"

tags = {
  Environment = "dev"
  Owner       = "team-example"
}

# Exemplo: leitura restrita a um bucket S3, exigindo MFA para GetObject
statements = [
  {
    sid     = "AllowListBucket"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::my-example-bucket"
    ]
  },
  {
    sid     = "AllowGetObjectWithMFA"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::my-example-bucket/*"
    ]
    conditions = [
      {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    ]
  }
]

Notas:
- A configuração padrão cria uma policy mínima permitindo apenas sts:GetCallerIdentity em "*", útil para validação e segurança.
- Adapte os statements conforme sua necessidade, mantendo o princípio de menor privilégio.
- Evite incluir Principals; policies gerenciadas por IAM não suportam o bloco principal (aplica-se a políticas baseadas em recurso).
