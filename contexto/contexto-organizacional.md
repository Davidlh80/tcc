# Contexto Organizacional

Este documento define o contexto organizacional utilizado no cenário de geração de templates por Inteligência Artificial com contexto.

O objetivo é simular padrões internos de uma organização e avaliar se a IA produz templates mais aderentes a requisitos de padronização, segurança e governança.

## Padrão de nomenclatura

Os recursos devem seguir o padrão:

```text
<ambiente>-<sistema>-<recurso>-<finalidade>
```

Exemplos: `dev-tcc-s3-logs`, `prd-tcc-iam-readonly` e `hml-tcc-sg-web`.

## Ambientes permitidos

- `dev`
- `hml`
- `prd`

## Tags obrigatórias

Todos os recursos que suportam tags devem conter:

```hcl
tags = {
	Project     = "tcc-iac-ia"
	Environment = var.environment
	ManagedBy   = "terraform"
	Owner       = "devops"
	CostCenter  = "academic-research"
}
```

## Estrutura esperada dos templates

Cada recurso deve conter `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` e `README.md`.

## Boas práticas gerais

- Evitar valores fixos no código;
- utilizar variáveis para parâmetros configuráveis;
- declarar outputs relevantes;
- conter validação básica de variáveis;
- seguir o princípio do menor privilégio;
- evitar exposição pública desnecessária;
- manter nomes e tags padronizados.

## Nomenclatura obrigatória de variáveis e outputs

Para permitir auditoria e comparação entre execuções, os outputs devem usar exatamente estes nomes:

| Recurso         | Outputs obrigatórios                                        |
|------------------|--------------------------------------------------------------|
| S3               | `bucket_name`, `bucket_arn`, `bucket_id`                     |
| IAM              | `policy_name`, `policy_arn`, `policy_id`                     |
| Security Group   | `security_group_name`, `security_group_arn`, `security_group_id` |

Variáveis mínimas obrigatórias em todos os recursos: `environment`, `system`, `region`, `additional_tags`. Cada recurso ainda deve ter uma variável própria para seu nome ou finalidade (ex.: `purpose` no S3, `policy_name` no IAM, `security_group_name` no Security Group).

## Estrutura obrigatória do README

O `README.md` de cada template deve conter, nesta ordem:

1. Visão geral do recurso;
2. Tabela de variáveis (nome, tipo, obrigatória, descrição);
3. Tabela de outputs (nome, descrição);
4. Exemplo de uso do módulo/recurso.

## Segurança por recurso

- **S3**: bloquear as quatro flags do Public Access Block; habilitar criptografia server-side (SSE-S3/AES256 por padrão); negar explicitamente, via bucket policy, qualquer requisição sem `aws:SecureTransport`; versionamento controlável por variável, com padrão `Enabled`.
- **IAM**: proibir `Action: "*"` combinado com `Resource: "*"` na mesma statement; restringir `Effect: Allow` apenas às ações e recursos informados por variável; não anexar policies gerenciadas administrativas (ex.: `AdministratorAccess`).
- **Security Group**: proibir `0.0.0.0/0` em qualquer porta além da 443/tcp; toda regra de entrada/saída deve ter descrição; egress deve ser explícito, sem liberação irrestrita por padrão.
