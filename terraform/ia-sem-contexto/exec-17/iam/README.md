Nome
- Blueprint Terraform para provisionar uma AWS IAM Policy gerenciada opcionalmente anexada a roles, users e groups.

Recursos criados
- aws_iam_policy
- aws_iam_role_policy_attachment (opcional por role)
- aws_iam_user_policy_attachment (opcional por user)
- aws_iam_group_policy_attachment (opcional por group)

Como usar
1) Ajuste variáveis no arquivo variables.tf ou via CLI/TFVARS.
2) Inicialize e valide:
   - terraform init -backend=false
   - terraform validate
3) Planeje e aplique:
   - terraform plan
   - terraform apply

Variáveis principais
- aws_region: Região AWS. Padrão: us-east-1
- policy_name: Nome da policy. Padrão: example-iam-policy
- policy_description: Descrição da policy.
- policy_path: Caminho da policy (deve começar e terminar com /). Padrão: /
- policy_statements: Lista de statements. Por padrão inclui uma statement de leitura de informações básicas da conta.
- tags: Mapa de tags para o recurso.
- attach_to_roles, attach_to_users, attach_to_groups: Listas de nomes de entidades IAM para anexar a policy (opcionais).

Estrutura dos statements (exemplo)
policy_statements = [
  {
    sid      = "AllowReadS3"
    effect   = "Allow"
    actions  = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::meu-bucket",
      "arn:aws:s3:::meu-bucket/*"
    ]
    conditions = {
      StringEquals = {
        "aws:RequestedRegion" = ["us-east-1"]
      }
    }
  }
]

Boas práticas incorporadas
- Variáveis com validações de formato e limites.
- Política gerada via jsonencode para evitar erros de sintaxe.
- Anexos a entidades IAM são opcionais e controlados por variáveis.
- Configurações seguras por padrão (sem credenciais embutidas; sem backend remoto).

Saída (outputs)
- policy_arn, policy_name, policy_path, policy_document_json
- attached_roles, attached_users, attached_groups
- attachment_count_total

Notas
- Cada statement deve conter pelo menos um dos campos actions ou not_actions e pelo menos um dos campos resources ou not_resources.
- A validação sintática não requer credenciais reais, mas a aplicação sim.
