Blueprint Terraform: AWS IAM Policy

Descricao
- Cria uma IAM Policy na AWS.
- Permite definir a policy via documento JSON bruto (policy_json) ou gerar uma declaracao simples a partir de allowed_actions e resources.
- Segue configuracoes seguras por padrao, evitando valores sensiveis fixos.

Arquivos
- versions.tf: Requisitos de Terraform e provider.
- variables.tf: Variaveis de configuracao com validacoes.
- main.tf: Provider, documento da policy e recurso aws_iam_policy.
- outputs.tf: Saidas relevantes, incluindo ARN e versao padrao.
- README.md: Instrucoes de uso.

Como usar
1) Ajuste as variaveis no arquivo variables.tf conforme necessario ou defina-as por -var / tfvars.
2) Execute os comandos:
   - terraform init -backend=false
   - terraform validate
   - terraform plan
   - terraform apply

Exemplos de configuracao

A) Gerar policy simples via variaveis
- Defina:
  policy_name = "my-example-policy"
  effect = "Allow"
  allowed_actions = ["ec2:DescribeInstances"]
  resources = ["*"]

B) Fornecer JSON bruto de policy
- Defina:
  policy_json = '{"Version":"2012-10-17","Statement":[{"Effect":"Deny","Action":["s3:DeleteBucket"],"Resource":"*"}]}'
- Quando policy_json e fornecido, as variaveis effect, allowed_actions e resources sao ignoradas para gerar o documento final.

Variaveis principais
- aws_region: Regiao AWS. Padrao us-east-1.
- policy_name: Nome da policy.
- policy_description: Descricao da policy.
- policy_path: Caminho da policy (ex.: / ou /custom/).
- effect: Allow ou Deny (usado somente quando policy_json for nulo).
- allowed_actions: Lista de acoes (quando policy_json for nulo).
- resources: Lista de ARNs dos recursos (quando policy_json for nulo).
- policy_json: Documento JSON bruto da policy (opcional).

Saidas
- policy_arn: ARN da IAM Policy.
- policy_name: Nome da policy criada.
- policy_id: ID interno da policy.
- default_version_id: Versao padrao da policy.
- rendered_policy_json: Documento JSON final aplicado.

Notas
- Nao e configurado backend remoto.
- Nao ha dependencia de credenciais reais para validacao sintatica.
- Utilize credenciais adequadas somente em ambientes de execucao reais.
