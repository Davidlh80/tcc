# Terraform AWS IAM Policy

Blueprint simples e segura para criar uma AWS IAM Policy gerenciada via Terraform.

Principais caracteristicas:
- Provider AWS oficial
- Variaveis para valores configuraveis
- Policy document gerado com aws_iam_policy_document
- Suporte opcional a conditions
- Tags padrao ManagedBy=Terraform (mescladas com suas tags)

Como usar (exemplo rapido):
1) Defina variaveis (ex.: em terraform.tfvars)
policy_name   = "example-readonly"
actions       = ["s3:ListAllMyBuckets", "s3:ListBucket"]
resource_arns = ["*"]
aws_region    = "us-east-1"

2) Execute
terraform init -backend=false
terraform validate
terraform plan
terraform apply

Variaveis principais:
- aws_region (string, default: us-east-1)
- policy_name (string, obrigatoria)
- policy_path (string, default: "/")
- description (string, default: "IAM policy gerenciada pelo Terraform.")
- policy_effect (string, default: "Allow", valores: Allow|Deny)
- statement_sid (string, default: "PrimaryStatement")
- actions (list(string), obrigatoria)
- resource_arns (list(string), obrigatoria)
- conditions (list(object), opcional)
- tags (map(string), opcional)

Outputs:
- policy_arn
- policy_name
- policy_id
- policy_path
- policy_document_json

Notas:
- Este template evita backend remoto e nao depende de credenciais reais para validacao sintatica.
- Ajuste actions e resource_arns conforme sua necessidade de privilegios minimos.
