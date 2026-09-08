Nome
Blueprint Terraform — AWS IAM Policy

Descrição
Este template cria uma IAM Policy customizada na AWS utilizando o provider oficial. Por padrão, a policy gerada concede permissões de leitura mínimas no S3 (listar buckets e obter a região de um bucket). Você pode substituir completamente o documento da policy fornecendo um JSON customizado via variável.

Arquivos
- main.tf: provider, documento da policy e recurso aws_iam_policy.
- variables.tf: variáveis configuráveis com validações.
- outputs.tf: saídas úteis, incluindo ARN, versão padrão e JSON efetivo.
- versions.tf: versões mínimas do Terraform e do provider AWS.
- README.md: instruções de uso.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas disponíveis no ambiente (ex: variáveis de ambiente ou AWS CLI), sem necessidade de defini-las no código.

Variáveis principais
- aws_region (string): Região AWS. Padrão: us-east-1.
- policy_name (string): Nome da policy. Padrão: example-readonly-policy.
- policy_description (string): Descrição da policy.
- path (string): Path da policy, ex: "/".
- effect (string): Allow ou Deny para o statement padrão.
- allowed_actions (list(string)): Ações para o statement padrão.
- allowed_resources (list(string)): Recursos para o statement padrão.
- statement_sid (string): SID para o statement padrão.
- policy_json (string): JSON completo da policy (se fornecido, substitui o statement padrão).
- tags (map(string)): Tags adicionais a aplicar.

Uso básico
1) Inicialize e valide:
terraform init -backend=false
terraform validate

2) Planeje/aplique usando os defaults (cria uma policy de leitura mínima no S3):
terraform plan
terraform apply

Exemplos de customização
- Alterar região, nome e incluir tags:
terraform apply \
  -var="aws_region=eu-west-1" \
  -var="policy_name=my-app-readonly" \
  -var='tags={env="dev",owner="platform"}'

- Usar o gerador com ações e recursos próprios:
terraform apply \
  -var='allowed_actions=["ec2:DescribeInstances","ec2:DescribeVpcs"]' \
  -var='allowed_resources=["*"]' \
  -var='effect=Allow' \
  -var='statement_sid=EC2ReadOnly'

- Fornecer um JSON completo da policy (substitui o statement padrão):
Exemplo de valor para policy_json:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AccessOwnBucket",
      "Effect": "Allow",
      "Action": ["s3:GetObject","s3:PutObject"],
      "Resource": ["arn:aws:s3:::my-bucket/*"]
    }
  ]
}
Aplique com:
terraform apply -var='policy_json={"Version":"2012-10-17","Statement":[{"Sid":"AccessOwnBucket","Effect":"Allow","Action":["s3:GetObject","s3:PutObject"],"Resource":["arn:aws:s3:::my-bucket/*"]}]}'

Saídas (outputs)
- iam_policy_arn: ARN da policy criada.
- iam_policy_id: ID interno da policy.
- iam_policy_name: Nome da policy.
- iam_policy_path: Path da policy.
- iam_policy_default_version_id: Versão padrão da policy.
- iam_policy_document_json: Documento JSON efetivo aplicado.
- iam_policy_tags: Tags aplicadas.

Notas
- Não há backend remoto configurado.
- Não há dependência de credenciais no código; o provider usa o mecanismo padrão de credenciais do AWS SDK.
- Os valores padrões são seguros e mínimos; personalize conforme sua necessidade.
