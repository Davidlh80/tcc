# Prompt S3 — IA com contexto organizacional

Crie um template Terraform para provisionar um bucket Amazon S3.

Além dos requisitos técnicos abaixo, o template deve seguir o contexto organizacional fornecido separadamente pelo experimento.

O template deve conter os seguintes arquivos:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Requisitos obrigatórios

O template deve:

- criar um bucket S3;
- bloquear acesso público ao bucket;
- habilitar criptografia server-side;
- permitir configuração de versionamento por variável;
- aplicar tags obrigatórias conforme o contexto organizacional;
- seguir o padrão de nomenclatura definido no contexto organizacional;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome ou finalidade do bucket;
- ambiente;
- sistema ou aplicação;
- habilitação de versionamento;
- tags adicionais, quando aplicável.

## Outputs esperados

O template deve retornar:

- nome do bucket;
- ARN do bucket;
- ID do bucket.

## Observação

O template deve priorizar segurança, padronização e aderência ao contexto organizacional.
