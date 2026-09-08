Blueprint Terraform — AWS IAM Policy

Descrição
- Este template cria uma IAM Policy (Customer Managed Policy) na AWS, utilizando um documento de policy construído dinamicamente a partir de variáveis.
- Configurações seguras por padrão: política mínima de introspecção (somente leitura para identificação da conta) e sem uso de credenciais embutidas.

Arquivos
- versions.tf: versões mínimas do Terraform e provider AWS.
- variables.tf: variáveis configuráveis com validações.
- main.tf: recursos e data sources para construir e criar a policy.
- outputs.tf: saídas úteis após a criação.
- README.md: instruções de uso.

Pré-requisitos
- Terraform >= 1.5.0
- Provider AWS ~> 5.x
- Credenciais AWS válidas configuradas no ambiente (requeridas apenas para plan/apply).

Como usar (exemplo rápido)
1) Ajuste as variáveis conforme necessário, via terraform.tfvars, variáveis de ambiente, ou -var/-var-file.
2) Exemplo de terraform.tfvars:

aws_region = "us-east-1"
policy_name = "example-readonly-policy"
policy_description = "Policy de exemplo somente leitura para S3 list e CloudWatch logs describe."
policy_path = "/app/prod/"
tags = {
  Project = "example"
  Owner   = "team-infra"
}
statements = [
  {
    sid     = "S3List"
    effect  = "Allow"
    actions = ["s3:ListAllMyBuckets", "s3:ListBucket"]
    resources = ["*"]
  },
  {
    sid     = "CWLogsDescribe"
    effect  = "Allow"
    actions = ["logs:DescribeLogGroups", "logs:DescribeLogStreams"]
    resources = ["*"]
  }
]

3) Inicialize e valide:
- terraform init -backend=false
- terraform validate

4) Planeje e aplique:
- terraform plan
- terraform apply

Notas de segurança e boas práticas
- Defina ações e recursos específicos, evitando wildcards sempre que possível.
- Utilize statements separados para separar responsabilidades e facilitar auditoria.
- Preferir Allow granulares; use Deny explícito apenas para bloqueios intencionais.
- Revise as validações das variáveis para garantir que não use actions e not_actions ao mesmo tempo, assim como resources e not_resources.

Saídas
- policy_arn: ARN da policy criada.
- policy_name: Nome da policy.
- policy_id: ID interno da policy.
- policy_path: Caminho (path) da policy.
- policy_document_json: JSON final do documento da policy.
- policy_tags_all: Tags efetivas aplicadas.

Limitações
- Este módulo não realiza anexos automáticos a usuários, grupos ou roles. Utilize aws_iam_policy_attachment ou recursos específicos (aws_iam_user_policy_attachment, aws_iam_role_policy_attachment, aws_iam_group_policy_attachment) conforme sua necessidade.
