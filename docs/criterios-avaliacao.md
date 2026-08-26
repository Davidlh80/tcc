# Critérios de Avaliação

## Eficiência operacional

Tempo declarado pelo participante e tempo entre eventos relevantes do Pull Request, descontando pausas registradas.

## Conformidade

Estrutura de arquivos, uso de variáveis e outputs, README e atendimento aos requisitos específicos do recurso.

## Padronização

Nomenclatura, tags obrigatórias, organização dos arquivos e consistência entre recursos.

## Segurança

Exposição pública, permissões excessivas, ausência de criptografia ou bloqueios básicos e alertas de Checkov e Trivy.

## Qualidade funcional

Resultados de `terraform init`, `terraform fmt`, `terraform validate`, `terraform plan` e, quando aplicável, `terraform apply` no ambiente controlado.
