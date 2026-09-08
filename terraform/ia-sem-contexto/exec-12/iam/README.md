Blueprint Terraform — AWS IAM Policy

Descricao
Este template cria uma IAM Policy gerenciada (customer managed) na AWS com um conjunto de statements configuraveis via variaveis. Por padrao, e criada uma policy somente-leitura para EC2 (ec2:Describe*) aplicada a todos os recursos.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (ex.: variaveis de ambiente ou arquivo de credenciais)

Arquivos
- versions.tf: Versao do Terraform e providers.
- variables.tf: Variaveis de configuracao.
- main.tf: Definicao do provider, documento da policy e recurso aws_iam_policy.
- outputs.tf: Saidas principais.
- README.md: Instrucoes de uso.

Como usar
1) Ajuste variaveis conforme necessario (opcional). Exemplos rapidos:
   - Definir regiao: terraform plan -var="aws_region=us-west-2"
   - Alterar nome da policy: terraform plan -var="policy_name=my-custom-policy"
2) Inicialize e valide:
   - terraform init -backend=false
   - terraform validate
3) Visualize o plano:
   - terraform plan
4) Aplique:
   - terraform apply

Variaveis principais
- aws_region (string): Regiao AWS. Default: us-east-1.
- policy_name (string): Nome da policy. Default: ec2-readonly-policy.
- description (string): Descricao da policy. Default: EC2 ReadOnly policy managed by Terraform.
- path (string): Caminho (path) que deve iniciar e terminar com /. Default: /service-control/.
- tags (map(string)): Tags adicionais. Default inclui ManagedBy=Terraform.
- statements (list(object)):
  - effect (Allow|Deny)
  - actions (list(string))
  - resources (list(string))
  - conditions (opcional) lista de objetos com: test, variable, values (list(string))

Exemplo de customizacao de statements (em terraform.tfvars):
statements = [
  {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::meu-bucket/*"]
    conditions = [
      {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["true"]
      }
    ]
  }
]

Outputs
- policy_arn: ARN da policy criada.
- policy_name: Nome da policy.
- policy_id: ID da policy.
- policy_path: Path da policy.
- policy_document_json: JSON final da policy aplicada.
- policy_tags: Tags aplicadas.

Notas
- O template evita valores sensiveis hardcoded. Ajuste variaveis conforme seu ambiente.
- O documento da policy e montado via aws_iam_policy_document, garantindo sintaxe valida.
- Por padrao, o exemplo cria uma policy de leitura para EC2, segura e de baixo risco. Ajuste para seu caso de uso.
