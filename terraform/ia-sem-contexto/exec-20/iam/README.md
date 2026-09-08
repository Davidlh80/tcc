# Terraform AWS IAM Policy

Este modulo cria uma IAM Policy customizada na AWS com configuracoes seguras por padrao (acesso read-only a servicos comuns). Ele permite personalizar os statements conforme sua necessidade.

## Requisitos
- Terraform 1.3.0 ou superior
- Provider AWS ~> 5.x
- Credenciais AWS configuradas no ambiente (variaveis de ambiente, arquivo de credenciais, etc.). Nao e necessario para validacao sintatica.

## Arquivos
- main.tf: definicao do provider, documento da policy e recurso aws_iam_policy.
- variables.tf: variaveis de configuracao.
- outputs.tf: saidas relevantes.
- versions.tf: versoes requeridas do Terraform e provider.
- README.md: instrucoes de uso.

## Como usar
1) Inicializar o diretorio (sem backend remoto):
terraform init -backend=false

2) Validar a configuracao:
terraform validate

3) Visualizar o plano:
terraform plan

4) Aplicar:
terraform apply

5) Remover recursos quando nao forem mais necessarios:
terraform destroy

## Variaveis principais
- aws_region: regiao AWS. Padrao: us-east-1
- name: nome da policy. Padrao: ro-viewer
- description: descricao da policy.
- path: caminho da policy. Padrao: /
- statements: lista de statements (effect, actions, resources). Padrao concede acesso read-only a servicos comuns.
- tags: tags do recurso (por exemplo, ManagedBy=Terraform).

Cada statement exige:
- effect: Allow ou Deny (case-insensitive).
- actions: lista de acoes IAM.
- resources: lista de ARNs ou "*".

## Exemplo de customizacao
Exemplo de arquivo terraform.tfvars para ajustar nome e adicionar uma restricao de deletar S3:
name = "custom-viewer"
statements = [
  {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  },
  {
    effect    = "Allow"
    actions   = ["s3:Get*", "s3:List*"]
    resources = ["*"]
  },
  {
    effect    = "Deny"
    actions   = ["s3:DeleteBucket", "s3:DeleteObject", "s3:DeleteObjectVersion"]
    resources = ["*"]
  }
]

## Saidas
- policy_arn: ARN da policy criada.
- policy_name: nome da policy.
- policy_id: ID interno da policy.
- policy_document: JSON da policy gerado pelo Terraform.

## Notas de seguranca
- Revise os statements antes de aplicar em ambientes de producao.
- Prefira restringir resources por ARN especifico quando possivel ao inves de usar "*".
- Utilize Deny explicito para bloquear acoes criticas quando necessario.
