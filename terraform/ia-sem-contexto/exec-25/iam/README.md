# Terraform AWS IAM Policy

Blueprint Terraform para criar uma IAM Policy gerenciada (aws_iam_policy) na AWS, com foco em configuração segura por padrão, variáveis flexíveis e validações úteis.

## Recursos criados
- aws_iam_policy

## Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas no ambiente (para aplicar)

## Uso básico
Exemplo mínimo utilizando o prefixo de nome padrão e o statement padrão seguro (somente leitura de identidade da conta):

- Com os valores padrão, basta:
  - terraform init -backend=false
  - terraform validate
  - terraform plan -out plan.tfplan
  - terraform apply plan.tfplan

## Exemplo customizado
Exemplo definindo nome explícito, caminho e statements adicionais:

module "iam_policy" {
  source = "./" # se estiver usando como módulo local, ajuste conforme necessário

  aws_region         = "us-east-1"
  policy_name        = "example-readonly-policy"
  policy_name_prefix = null
  path               = "/"
  policy_description = "Example read-only access to specific resources"

  statements = [
    {
      sid       = "ReadOnlyS3Bucket"
      effect    = "Allow"
      actions   = ["s3:GetObject", "s3:ListBucket"]
      resources = [
        "arn:aws:s3:::my-example-bucket",
        "arn:aws:s3:::my-example-bucket/*"
      ]
    },
    {
      sid       = "DescribeEC2"
      effect    = "Allow"
      actions   = ["ec2:Describe*"]
      resources = ["*"]
      conditions = [
        {
          test     = "StringEquals"
          variable = "aws:RequestedRegion"
          values   = ["us-east-1"]
        }
      ]
    }
  ]

  tags = {
    Environment = "dev"
    Owner       = "platform-team"
  }
}

Observações:
- Defina policy_name OU policy_name_prefix (não ambos). Por padrão, policy_name_prefix já possui um valor seguro para facilitar validação sem variáveis externas.
- O campo statements possui validação para garantir pelo menos uma action e um resource por statement.

## Variáveis principais
- aws_region (string, default: "us-east-1)
- policy_name (string, default: null)
- policy_name_prefix (string, default: "tf-iam-policy-")
- policy_description (string, default: "Managed IAM policy provisioned by Terraform.")
- path (string, default: "/")
- statements (list(object), default inclui um statement de introspecção de conta)
- tags (map(string), default: {})

## Outputs
- iam_policy_arn: ARN da policy criada
- iam_policy_name: Nome da policy criada
- iam_policy_id: ID da policy
- iam_policy_document_json: Documento JSON final da policy

## Boas práticas incorporadas
- Uso de aws_iam_policy_document para compor o JSON da policy a partir de estrutura tipada.
- Validações para região, nome, prefixo, path e conteúdo dos statements.
- Tags com ManagedBy = Terraform adicionadas por padrão.

## Notas
- Não há backend remoto definido; o estado será local por padrão.
- O template evita depender de credenciais reais para validação sintática (terraform validate) e pode ser inicializado com terraform init -backend=false.
