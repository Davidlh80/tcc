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

## Segurança por recurso

- S3: bloquear acesso público, habilitar criptografia e permitir versionamento;
- IAM: evitar wildcard amplo e restringir ações e recursos;
- Security Group: restringir portas e origens e evitar `0.0.0.0/0` sem justificativa.
