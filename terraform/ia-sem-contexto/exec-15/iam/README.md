Blueprint Terraform — AWS IAM Policy

Descrição
- Cria uma IAM Policy gerenciada (aws_iam_policy) na AWS.
- A política é construída dinamicamente a partir da variável policy_statements, usando aws_iam_policy_document.
- Configuração segura por padrão e personalizável via variáveis.

Pré-requisitos
- Terraform >= 1.4.0
- Provider AWS ~> 5.0
- Credenciais AWS disponíveis no ambiente (por exemplo, variáveis de ambiente ou perfil local). Não é necessário definir backend remoto.

Arquivos
- main.tf: Provider, documento da política e recurso aws_iam_policy.
- variables.tf: Declaração das variáveis com validações e valores padrão.
- outputs.tf: Saídas úteis da política criada.
- versions.tf: Versões mínimas do Terraform e do provider AWS.
- README.md: Instruções de uso.

Variáveis principais
- aws_region (string): Região AWS. Padrão: us-east-1.
- policy_name (string): Nome da Policy. Obrigatória.
- policy_description (string): Descrição da Policy. Padrão informativo.
- policy_path (string): Caminho da Policy, deve iniciar e terminar com /. Padrão: /.
- policy_statements (list(object)): Lista de statements com effect, actions, resources.
- tags (map(string)): Tags aplicadas ao recurso. Padrão inclui ManagedBy e IaC.

Exemplo de uso rápido (terraform.tfvars)
policy_name = "example-readonly-policy"
policy_description = "Exemplo de política gerenciada criada por Terraform."
policy_path = "/application/"
aws_region = "us-east-1"

policy_statements = [
  {
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
    resources = ["*"]
  },
  {
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances", "ec2:DescribeRegions"]
    resources = ["*"]
  }
]

tags = {
  ManagedBy   = "Terraform"
  Environment = "dev"
  Project     = "iam-policy-blueprint"
}

Comandos básicos
- Inicializar: terraform init -backend=false
- Validar: terraform validate
- Plano: terraform plan
- Aplicar: terraform apply
- Destruir: terraform destroy

Boas práticas
- Princípio do menor privilégio: limite actions e resources ao mínimo necessário, evitando curingas amplos como "*".
- Utilize tags para identificar propriedade, ambiente e finalidade.
- Revise e versiona o documento gerado (policy_document_json) antes de aplicar em produção.

Notas
- Este template não configura backend remoto por design.
- O template não cria anexos a usuários, grupos ou roles. O anexo pode ser feito separadamente conforme necessidade (por exemplo, com aws_iam_policy_attachment ou aws_iam_role_policy_attachment).
