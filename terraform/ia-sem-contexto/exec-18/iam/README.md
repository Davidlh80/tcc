Blueprint Terraform: AWS IAM Policy

Descrição
- Este template cria uma IAM Policy gerenciada pelo cliente (Customer Managed Policy) na AWS, com configurações seguras por padrão e opções de customização via variáveis.
- Por padrão, a policy concede permissões de leitura (read-only) a serviços comuns, sem permitir alterações em recursos.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0, < 6.0
- Credenciais AWS exportadas no ambiente (apenas necessárias para terraform plan/apply, não para validação)

Arquivos
- main.tf: definição do provider, locals e recurso aws_iam_policy
- variables.tf: variáveis de entrada com validações
- outputs.tf: saídas úteis (ARN, nome, ID interno, path e JSON da policy)
- versions.tf: versões do Terraform e provider AWS
- README.md: instruções de uso

Como usar (exemplo simples)
- Ajuste variáveis conforme necessário (ex.: policy_name, tags).
- Execute:
  - terraform init -backend=false
  - terraform validate
  - terraform plan
  - terraform apply

Exemplo de configuração inline
- Defina variáveis via terraform.tfvars ou pela CLI:
  region = "us-east-1"
  policy_name = "my-readonly-policy"
  tags = {
    project = "example"
    owner   = "devops"
  }

Personalização de statements
- Use a variável "statements" para definir os blocos de permissões:
  statements = [
    {
      sid       = "AllowDescribeEC2"
      effect    = "Allow"
      actions   = ["ec2:Describe*"]
      resources = ["*"]
      condition = {}
    }
  ]

Uso de policy_json
- Para fornecer um documento JSON completo (substitui "statements"):
  policy_json = <<EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowReadS3",
        "Effect": "Allow",
        "Action": ["s3:GetObject", "s3:ListBucket"],
        "Resource": ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]
      }
    ]
  }
  EOT

Variáveis principais
- region (string): Região AWS. Default: us-east-1.
- create (bool): Controla a criação do recurso. Default: true.
- prevent_destroy (bool): Protege contra destruição acidental (lifecycle.prevent_destroy). Default: false.
- policy_name (string): Nome da policy. Default: example-readonly-policy.
- policy_description (string): Descrição da policy.
- path (string): Caminho da policy (ex.: "/"). Deve iniciar e terminar com "/".
- statements (list(object)): Lista de statements para compor a policy (usado quando policy_json não é fornecido).
- policy_json (string|nullable): Documento JSON completo da policy; se definido e não-vazio, tem precedência sobre "statements".
- tags (map(string)): Tags aplicadas à policy. Chaves não podem começar com "aws:".

Saídas
- iam_policy_arn: ARN da policy.
- iam_policy_name: Nome da policy.
- iam_policy_id: ID interno (policy_id) atribuído pela AWS.
- iam_policy_path: Caminho da policy.
- iam_policy_document_json: JSON efetivo aplicado na policy.

Boas práticas e notas
- Por padrão, esta blueprint cria uma policy somente-leitura em recursos comuns. Ajuste as actions e resources conforme sua necessidade mínima (princípio do menor privilégio).
- Evite usar wildcards amplos como "*" em actions e resources; prefira recursos e ações específicos sempre que possível.
- Tags ajudam governança e custos; utilize-as consistentemente.
