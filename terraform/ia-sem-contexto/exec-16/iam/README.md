Blueprint Terraform — AWS IAM Policy

Descricao
- Provisiona uma IAM Policy com configuracoes seguras por padrao.
- Inclui por padrao uma negacao global para trafego nao seguro (sem TLS) usando a condicao aws:SecureTransport.
- Permite adicionar declaracoes (Allow/Deny) extras via variavel allow_statements.

Arquivos
- versions.tf: Versoes minimas do Terraform e provider AWS.
- variables.tf: Variaveis configuraveis e validacoes.
- main.tf: Provider AWS, documento da policy e recurso aws_iam_policy.
- outputs.tf: Saidas relevantes.
- README.md: Instrucoes de uso.

Como usar
1) Ajuste variaveis no arquivo variables.tf via terraform.tfvars ou -var/-var-file, por exemplo:
- aws_region: Regiao AWS, ex: us-east-1
- policy_name: Nome da policy
- policy_description: Descricao
- policy_path: Caminho, ex: /
- tags: Tags de recursos
- allow_statements: Lista de declaracoes adicionais

2) Exemplo de allow_statements (adicione em terraform.tfvars ou via -var):
allow_statements = [
  {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::example-bucket"]
    conditions = [
      {
        test     = "StringEquals"
        variable = "s3:prefix"
        values   = [""]
      }
    ]
  },
  {
    actions   = ["s3:GetObject", "s3:ListBucketMultipartUploads"]
    resources = ["arn:aws:s3:::example-bucket/*"]
  }
]

3) Comandos basicos
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Padrao seguro
- A policy criada contem uma declaracao Deny com condicao BoolIfExists para aws:SecureTransport == false, bloqueando chamadas sem HTTPS, sem afetar servicos que nao expõem essa chave de condicao.

Variaveis principais
- aws_region (string): Regiao AWS. Padrao: us-east-1
- policy_name (string): Nome da policy. Padrao: iam-secure-transport-policy
- policy_description (string): Descricao da policy.
- policy_path (string): Caminho IAM. Deve iniciar e terminar com / . Padrao: /
- allow_statements (list(object)): Declaracoes adicionais (Allow/Deny), com actions, resources e conditions opcionais.
- tags (map(string)): Tags aplicadas ao recurso.

Outputs
- policy_arn: ARN da policy
- policy_id: ID da policy
- policy_name: Nome da policy
- policy_path: Caminho da policy
- policy_default_version_id: Versao default da policy
- policy_document_json: Documento JSON renderizado

Notas
- Nenhum backend remoto e configurado.
- O template nao depende de credenciais reais para validacao sintatica (terraform validate).
- Ajuste allow_statements para conceder apenas os acessos estritamente necessarios (princípio do menor privilegio).
