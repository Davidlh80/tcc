Blueprint Terraform — AWS IAM Policy

Visao geral
- Cria uma IAM Managed Policy na AWS a partir de um documento gerado com aws_iam_policy_document.
- Parametriza nome, path, descricao, effect, actions, resources, conditions e tags.
- Padrao seguro: acoes somente-leitura em servicos comuns e recursos "*".

Arquivos
- versions.tf: Versoes requeridas do Terraform e provider AWS.
- variables.tf: Variaveis de configuracao.
- main.tf: Provider, documento da policy e recurso aws_iam_policy.
- outputs.tf: Saidas com informacoes da policy criada.

Como usar
1) Inicializar
   terraform init -backend=false

2) Visualizar o plano com valores padrao
   terraform plan

3) Aplicar com valores customizados (exemplos)
   terraform apply \
     -var 'aws_region=us-east-1' \
     -var 'policy_name=my-readonly-policy' \
     -var 'policy_description=Read-only access to selected services' \
     -var 'policy_actions=["ec2:Describe*","s3:Get*","s3:List*"]' \
     -var 'policy_resources=["*"]' \
     -var 'tags={Environment="lab",Owner="devops"}'

4) Destruir
   terraform destroy

Variaveis principais
- aws_region (string): Regiao AWS. Padrao: us-east-1
- policy_name (string): Nome da policy. Padrao: example-managed-policy
- policy_path (string): Path da policy (ex.: /, /custom/). Padrao: /
- policy_description (string): Descricao. Padrao: Managed policy criada via Terraform.
- policy_effect (string): Allow ou Deny. Padrao: Allow
- policy_actions (list(string)): Acoes IAM do statement principal. Padrao: somente-leitura em servicos comuns.
- policy_resources (list(string)): ARNs de recursos aplicaveis. Padrao: ["*"]
- policy_conditions (map): Conditions opcionais do statement principal.
  Exemplo de valor:
  {
    "restrict_by_mfa" = {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
- tags (map(string)): Tags a aplicar. Padrao: {}

Saidas
- iam_policy_arn: ARN da policy.
- iam_policy_name: Nome da policy.
- iam_policy_id: ID (ARN) da policy.
- iam_policy_path: Path da policy.
- iam_policy_document: Documento JSON resultante.

Notas
- Nao ha backend remoto; adequado para validacao local com terraform init -backend=false.
- O template nao depende de credenciais para validacao sintatica; credenciais so sao necessarias para aplicar de fato na AWS.
