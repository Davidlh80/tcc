Nome
Blueprint Terraform para criar uma AWS IAM Policy gerenciada.

Visão geral
Esta configuração Terraform provisiona uma IAM Policy gerenciada na AWS com:
- Provider AWS configurável por região
- Documento de política gerado via aws_iam_policy_document
- Variáveis para nome, descrição, path, tags e declarações (statements)
- Validações básicas de variáveis
- Tags aplicadas por padrão (ManagedBy, Environment)
- Outputs úteis (ARN, ID, versão, etc.)

Requisitos
- Terraform >= 1.3
- Provider AWS >= 5.0
- Credenciais AWS válidas no ambiente de execução (por exemplo, variáveis de ambiente AWS)

Arquivos
- versions.tf: Versões mínimas de Terraform e provider.
- variables.tf: Variáveis configuráveis.
- main.tf: Provider, data source do documento da policy e recurso da IAM Policy.
- outputs.tf: Saídas relevantes.
- README.md: Instruções e informações.

Como usar
1) Ajuste as variáveis conforme necessário (via tfvars ou -var).
   Exemplos de customização:
   - Definir a região:
     -var 'region=us-east-1'
   - Alterar nome/descrição da policy:
     -var 'policy_name=my-custom-policy' -var 'policy_description=Policy criada via Terraform'
   - Alterar o path:
     -var 'policy_path=/service-role/'
   - Adicionar tags:
     -var 'tags={Owner="team-x",CostCenter="1234"}'

2) Customizar as declarações (statements) da policy:
   As declarações aceitam:
   - sid: string identificadora (pode ser vazia)
   - effect: Allow ou Deny
   - actions: lista de ações IAM (ex.: ["ec2:Describe*"])
   - resources: lista de ARNs ou "*"
   - conditions: lista de objetos { test, variable, values }
   Exemplo em tfvars:
   statements = [
     {
       sid       = "AllowReadCWLogs"
       effect    = "Allow"
       actions   = ["logs:DescribeLogGroups", "logs:DescribeLogStreams", "logs:GetLogEvents", "logs:FilterLogEvents"]
       resources = ["*"]
       conditions = []
     }
   ]

3) Executar:
   terraform init -backend=false
   terraform validate
   terraform plan
   terraform apply

Padrões seguros
- Nenhum dado sensível é fixado em código.
- Política padrão com permissões de leitura mínimas (S3 listagem de buckets).
- Tags padrão facilitam governança e inventário.

Saídas
- iam_policy_arn: ARN da policy.
- iam_policy_id: ID estável da policy.
- iam_policy_name: Nome final da policy.
- iam_policy_path: Path configurado.
- iam_policy_default_version_id: Versão padrão da policy.
- iam_policy_document_json: Documento JSON renderizado.

Notas
- Esta blueprint não configura backend remoto.
- A política é criada, mas não é anexada automaticamente a usuários, grupos ou roles; isso pode ser feito em outra configuração conforme necessidade.
