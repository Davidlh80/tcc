Blueprint Terraform — AWS IAM Policy

Descrição
- Este template cria uma IAM Policy gerenciada (Managed Policy) na AWS a partir de uma lista de statements fornecida via variáveis.
- Padrões seguros: nenhum statement padrão é aplicado; você deve declarar explicitamente os statements que deseja.

Arquivos
- versions.tf: Requisitos de versão do Terraform e do provider AWS.
- variables.tf: Variáveis de entrada com validações.
- main.tf: Provider, composição do documento da policy e recurso aws_iam_policy.
- outputs.tf: Saídas úteis da policy criada.
- README.md: Instruções de uso.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais da AWS exportadas no ambiente ou configuradas no provider, quando for aplicar (não necessário para terraform validate).

Variáveis principais
- region (string): Região AWS. Padrão: us-east-1.
- policy_name_prefix (string): Prefixo do nome da policy. O provedor adiciona sufixo único. Padrão: tf-managed-.
- path (string): Path da policy (começa e termina com /). Padrão: /.
- description (string): Descrição da policy.
- statements (list(object)): Lista de statements da policy.
  - sid (opcional, string)
  - effect (string: Allow ou Deny)
  - actions (set(string))
  - resources (set(string))
  - conditions (opcional, map(any))
- tags (map(string)): Tags a aplicar. Padrão inclui ManagedBy=Terraform.

Exemplo de uso (trecho de variables)
- statements:
  - effect: Allow
    actions: ["s3:ListBucket"]
    resources: ["arn:aws:s3:::meu-bucket"]
  - sid: "DenyDangerousDeletes"
    effect: Deny
    actions: ["s3:DeleteBucket", "s3:DeleteObject"]
    resources: ["arn:aws:s3:::meu-bucket", "arn:aws:s3:::meu-bucket/*"]

Como executar
1) Inicialização (sem backend remoto):
- terraform init -backend=false

2) Validação:
- terraform validate

3) Plano (exemplos):
- terraform plan -var='region=us-east-1' \
  -var='policy_name_prefix=myapp-' \
  -var='statements=[{effect="Allow",actions=["ec2:DescribeInstances"],resources=["*"]}]'

4) Aplicação:
- terraform apply -var-file="meu.tfvars"  (ou usando -var conforme acima)

Saídas
- policy_arn: ARN da policy.
- policy_name: Nome final atribuído.
- policy_id: ID interno.
- policy_path: Path configurado.
- policy_description: Descrição.
- policy_document_json: JSON do documento da policy.

Boas práticas
- Conceda apenas as ações necessárias (princípio do menor privilégio).
- Evite recursos "*" quando possível; prefira ARNs específicos.
- Versão controle de alterações do documento de policy.
- Revise periodicamente statements Deny/Allow e condições.

Notas
- Nenhum backend remoto foi configurado.
- A validação sintática não depende de credenciais; contudo, para criar recursos na AWS você precisará de credenciais válidas.
