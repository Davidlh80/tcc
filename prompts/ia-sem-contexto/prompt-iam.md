# Prompt IAM — IA com contexto organizacional

Crie um template Terraform para provisionar uma política IAM na AWS.

Além dos requisitos técnicos abaixo, o template deve seguir o contexto organizacional fornecido separadamente pelo experimento.

O template deve conter os seguintes arquivos:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Requisitos obrigatórios

O template deve:

- criar uma IAM Policy;
- seguir o princípio do menor privilégio;
- evitar permissões administrativas;
- evitar wildcard amplo quando possível;
- permitir configuração das ações IAM por variável;
- permitir configuração dos recursos permitidos por variável;
- seguir o padrão de nomenclatura definido no contexto organizacional;
- aplicar tags quando o recurso suportar;
- utilizar variáveis para valores configuráveis;
- declarar outputs relevantes;
- evitar valores sensíveis fixos;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.

## Variáveis esperadas

O template deve possuir variáveis para:

- nome ou finalidade da policy;
- ambiente;
- sistema ou aplicação;
- descrição da policy;
- ações permitidas;
- recursos permitidos.

## Outputs esperados

O template deve retornar:

- nome da policy;
- ARN da policy;
- ID da policy.

## Observação

O template deve priorizar segurança, padronização e aderência ao contexto organizacional.
