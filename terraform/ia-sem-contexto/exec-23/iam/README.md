Resumo
- Este template provisiona uma IAM Policy na AWS usando Terraform.
- Por padrão, cria uma política mínima de leitura (iam:GetAccountSummary).
- É possível fornecer um JSON de política completo (policy_json) ou definir statements estruturados (statements).

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 4.0 e < 6.0
- Credenciais AWS configuradas no ambiente (não incluídas neste template)

Recursos criados
- aws_iam_policy

Uso básico
- Definindo statements (recomendado para compor políticas no HCL):
  module "iam_policy" {
    source = "./."

    region      = "us-east-1"
    name_prefix = "my-app-"

    statements = [
      {
        sid       = "AllowReadOnlyS3"
        effect    = "Allow"
        actions   = ["s3:GetObject", "s3:ListBucket"]
        resources = [
          "arn:aws:s3:::example-bucket",
          "arn:aws:s3:::example-bucket/*"
        ]
      }
    ]

    tags = {
      Project = "example"
      Env     = "dev"
    }
  }

- Usando a política em JSON bruto (substitui statements):
  module "iam_policy" {
    source = "./."

    region = "us-east-1"
    name   = "my-custom-policy"

    policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid      = "Stmt1"
          Effect   = "Allow"
          Action   = ["ec2:DescribeInstances"]
          Resource = ["*"]
        }
      ]
    })
  }

Entradas
- region (string, default: us-east-1): Região AWS do provider.
- name (string, default: null): Nome da IAM Policy. Se vazio/nulo, usa name_prefix.
- name_prefix (string, default: tf-iam-policy-): Prefixo para gerar nome único quando name não é usado.
- path (string, default: /): Caminho da política. Deve começar e terminar com /.
- description (string, default: Managed by Terraform): Descrição da política.
- tags (map(string), default: {}): Tags para o recurso.
- policy_json (string, default: null): Política em JSON cru. Se fornecida, substitui statements.
- statements (list(object), default: null): Lista de declarações para compor a política quando policy_json não é fornecida.
  - Cada item:
    - sid (string, opcional)
    - effect (string): Allow ou Deny
    - actions (list(string)): Ações permitidas/negadas
    - resources (list(string)): ARNs ou "*"
    - conditions (list(object), opcional):
      - test (string), variable (string), values (list(string))

Saídas
- iam_policy_arn: ARN da IAM Policy.
- iam_policy_id: ID da IAM Policy.
- iam_policy_name: Nome da IAM Policy.
- iam_policy_path: Caminho da IAM Policy.
- iam_policy_document_json: JSON efetivo usado para criar a política.

Notas de segurança
- O template evita privilégios amplos por padrão, usando uma ação de leitura mínima.
- Forneça statements ou policy_json conforme a necessidade do princípio do menor privilégio.
- Evite curingas desnecessários em actions/resources e limite escopos por ARN sempre que possível.

Validação
- Compatível com terraform fmt, terraform init -backend=false e terraform validate.
- Não utiliza backend remoto.
