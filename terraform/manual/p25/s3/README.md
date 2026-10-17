# Módulo / Template S3 Terraform

Este repositório contém a automação em Terraform para provisionamento de um bucket Amazon S3 com boas práticas de segurança, governança e conformidade.

## 🚀 Funcionalidades

- **Bucket S3**: Criação do bucket com nome dinâmico.
- **Segurança**: Bloqueio total de acesso público (`aws_s3_bucket_public_access_block`).
- **Criptografia**: Criptografia em repouso nativa habilitada por padrão (SSE-S3 / AES256).
- **Governança**: Versionamento configurável (habilitado/desabilitado via variável) e padronização de tags obrigatórias + tags adicionais.

---

## 📁 Estrutura de Arquivos

```text
.
├── versions.tf        # Requisitos de versão do Terraform e provedor AWS
├── variables.tf       # Variáveis de entrada (inputs)
├── main.tf            # Declaração dos recursos S3 e políticas de segurança
├── outputs.tf         # Dados retornados após o provisionamento
├── terraform.tfvars   # Exemplo de valores para as variáveis (não comitar segredos)
└── README.md          # Documentação do projeto
```

---

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) `>= 1.0.0`
- [AWS CLI](https://aws.amazon.com/cli/) instalado e configurado com permissões adequadas
- Conta na AWS ativa

---

## 🛠️ Como Usar

### 1. Clonar o Repositório

```bash
git clone <URL_DO_SEU_REPOSITORIO>
cd <NOME_DA_PASTA>
```

### 2. Inicializar o Terraform

```bash
terraform init
```

### 3. Planejar as Alterações

```bash
terraform plan
```

### 4. Aplicar a Infraestrutura

```bash
terraform apply
```

*(Confirme com `yes` no terminal para aprovar a execução)*

### 5. Destruir os Recursos (opcional)

```bash
terraform destroy
```

---

## 📥 Variáveis de Entrada (Inputs)

| Nome | Descrição | Tipo | Padrão | Obrigatório? |
| :--- | :--- | :---: | :---: | :---: |
| `bucket_name` | Nome globalmente único do bucket S3 | `string` | — | **Sim** |
| `aws_region` | Região da AWS para o provisionamento | `string` | `"us-east-1"` | Não |
| `environment` | Ambiente de implantação (ex: `dev`, `hml`, `prod`) | `string` | `"dev"` | Não |
| `enable_versioning` | Habilita ou desabilita o versionamento do bucket | `bool` | `true` | Não |
| `additional_tags` | Mapa com tags adicionais personalizadas | `map(string)` | `{}` | Não |

---

## 📤 Outputs

| Nome | Descrição |
| :--- | :--- |
| `bucket_name` | Nome do bucket S3 criado |
| `bucket_arn` | ARN (Amazon Resource Name) do bucket |
| `bucket_id` | ID do bucket S3 |

---

## 📝 Licença

Este projeto está sob a licença [MIT](LICENSE).
