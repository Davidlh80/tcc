# Terraform — AWS IAM Policy

Este template cria uma AWS IAM Managed Policy de forma segura e configurável.

Arquivos:
- main.tf: recursos e lógica principal
- variables.tf: variáveis de entrada com validações
- outputs.tf: saídas úteis
- versions.tf: versões mínimas do Terraform e providers
- README.md: instruções de uso

Como usar
1) Ajuste as variáveis necessárias em um arquivo terraform.tfvars (opcional) ou via CLI.
2) Execute:
   - terraform init -backend=false
   - terraform validate
   - terraform plan
   - terraform apply

Exemplo mínimo (terraform.tfvars)
region       = "us-east-1"
name_prefix  = "my-policy"
tags = {
  Project = "demo"
  Owner   = "devops"
}
statements = [
  {
    sid       = "AllowDescribeEC2"
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
]

Exemplo com NotAction e Condition
statements = [
  {
    sid           = "DenyAllButReadOnly"
    effect        = "Deny"
    not_actions   = ["s3:Get*", "s3:List*"]
    resources     = ["*"]
    conditions    = {
      Bool = {
        "aws:SecureTransport" = ["false"]
      }
    }
  }
]

Variáveis principais
- region: Região AWS (padrão: us-east-1)
- policy_name: Nome fixo da policy. Se omitido, é gerado a partir de name_prefix + sufixo aleatório.
- name_prefix: Prefixo do nome quando não há policy_name (padrão: tf-iam-policy)
- description: Descrição da policy (padrão: Terraform managed IAM policy.)
- path: Caminho da policy, deve começar e terminar com "/" (padrão: "/")
- tags: Mapa de tags
- statements: Lista de declarações. Em cada item:
  - effect: Allow ou Deny
  - exatamente um entre: actions ou not_actions
  - exatamente um entre: resources ou not_resources
  - opcional: sid e conditions (mapa: operador => { variavel => [valores] })

Boas práticas adotadas
- Sem credenciais embutidas
- Variáveis com validações
- Padrões seguros e mínimos para facilitar validação sintática
- Geração de nome única quando não especificado

Saídas
- iam_policy_arn
- iam_policy_id
- iam_policy_name
- iam_policy_path
- iam_policy_default_version_id
- iam_policy_document_json

Notas
- Este template não configura backend remoto deliberadamente.
- A validação sintática não requer credenciais reais; credenciais são necessárias apenas para apply.
