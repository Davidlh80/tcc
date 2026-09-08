# Blueprint Terraform — Amazon S3 Bucket

Este template provisiona um bucket S3 com padrões seguros:
- Bloqueio completo de acesso público;
- Ownership reforçado (BucketOwnerEnforced) e ACLs desabilitadas;
- Criptografia por padrão (SSE-S3 por padrão, opcional SSE-KMS);
- Versionamento habilitável (on por padrão);
- Política que nega tráfego sem TLS;
- Regra de lifecycle para abortar uploads multipart incompletos;
- Logging opcional para outro bucket.

## Pré-requisitos

- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas exportadas no ambiente (para aplicar), por exemplo via AWS SSO, perfis, etc.

## Uso rápido

Exemplo de execução local:

1) Inicializar (sem backend remoto):
- terraform init -backend=false

2) Validar:
- terraform validate

3) Planejar (substitua pelo nome único do seu bucket):
- terraform plan -var="bucket_name=meu-bucket-unico-global-123" -var="aws_region=us-east-1"

4) Aplicar:
- terraform apply -var="bucket_name=meu-bucket-unico-global-123" -var="aws_region=us-east-1"

## Variáveis principais

- bucket_name (string, obrigatório): Nome único global do bucket.
- aws_region (string, default: us-east-1): Região AWS.
- versioning_enabled (bool, default: true): Habilita versionamento.
- force_destroy (bool, default: false): Permite destruir mesmo com objetos.
- sse_algorithm (string, default: AES256): 'AES256' ou 'aws:kms'.
- kms_key_arn (string, default: null): ARN da CMK para SSE-KMS (se não informado e sse_algorithm=aws:kms, usa a chave gerenciada AWS/S3).
- logging_target_bucket (string, default: null): Bucket de destino para access logs (se definido, habilita logging).
- logging_target_prefix (string, default: null): Prefixo de logs (default efetivo: logs/).
- lifecycle_abort_multipart_days (number, default: 7): Dias para abortar uploads multipart incompletos.
- tags (map(string), default: {}): Tags adicionais.

## Outputs

- bucket_id: Nome do bucket.
- bucket_arn: ARN do bucket.
- bucket_domain_name: Domain público do bucket.
- bucket_regional_domain_name: Domain regional do bucket.

## Notas de segurança

- A política do bucket nega qualquer requisição sem TLS.
- O bloqueio de acesso público está ativado em todas as opções.
- ACLs são desativadas via BucketOwnerEnforced.
- Criptografia em repouso está habilitada por padrão.

## Logging

Para habilitar logging, informe logging_target_bucket apontando para um bucket existente que aceite logs do S3 e, opcionalmente, logging_target_prefix.

## Destruição

Por padrão, force_destroy=false para evitar remoção acidental de buckets com objetos. Ajuste conscientemente se necessário.
