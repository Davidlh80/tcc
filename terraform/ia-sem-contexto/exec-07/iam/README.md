Nome
Terraform AWS IAM Policy

Descricao
Blueprint Terraform para criar uma IAM Policy customizada na AWS. Por padrao, aplica:
- Uma negacao explicita para acessos nao-HTTPS (DenyInsecureTransport)
- Permissoes de leitura/descricao para servicos comuns (ex.: EC2, S3, CloudWatch, IAM, etc.)

Voce pode substituir o documento da policy fornecendo um JSON proprio via variavel policy_json.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS configuradas no ambiente (ex.: variaveis de ambiente ou perfil local)

Arquivos
- versions.tf: Versoes e provider AWS
- variables.tf: Variaveis configuraveis com validacoes
- main.tf: Recursos para criar a IAM Policy e anexos opcionais
- outputs.tf: Outputs principais da policy
- README.md: Instrucoes de uso

Como usar (exemplos)
1) Inicializacao e validacao
- terraform init -backend=false
- terraform validate

2) Criar uma policy com o padrao seguro (deny HTTP + leituras comuns)
- terraform apply -auto-approve

3) Definir um nome e anexar a uma role existente
- terraform apply -var "policy_name=ops-readonly" -var "enable_attachments=true" -var 'attach_roles=["my-existing-role"]'

4) Fornecer um documento JSON customizado (substitui o padrao)
Crie um arquivo tfvars com:
policy_name = "minha-policy"
policy_json = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Sid      = "AllowReadS3SpecificBucket"
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        "arn:aws:s3:::meu-bucket",
        "arn:aws:s3:::meu-bucket/*"
      ]
    }
  ]
})
Depois:
- terraform apply -var-file="seus-valores.tfvars"

Variaveis principais
- aws_region: Regiao AWS (padrao: us-east-1)
- policy_name: Nome da policy (padrao: custom-iam-policy)
- policy_description: Descricao da policy
- policy_path: Path da policy (padrao: /)
- policy_json: JSON da policy (string). Se vazio/nulo, usa o padrao seguro
- enable_attachments: Se true, cria anexo para entidades
- attach_users: Lista de usuarios IAM
- attach_roles: Lista de roles IAM
- attach_groups: Lista de grupos IAM
- tags: Tags adicionais (chaves nao podem iniciar com aws:)

Boas praticas e observacoes
- O padrao inclui um Deny para requisicoes sem HTTPS, fortalecendo a seguranca.
- Se optar por anexar a policy, garanta que as entidades (usuarios/roles/grupos) existam.
- Evite curingas amplos em ambientes de producao. Ajuste policy_json para o menor privilegio possivel.
- Este template nao configura backend remoto.

Comandos uteis
- terraform fmt
- terraform init -backend=false
- terraform plan
- terraform apply
- terraform destroy

Saida (outputs) principais
- policy_arn, policy_id, policy_name, policy_path, policy_default_version_id
- policy_document_json
- attachment_name e attachment_entities (quando anexo habilitado)
