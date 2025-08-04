# Terraform AWS Static Site

Este repositório contém um projeto Terraform para implantar um site estático de forma **altamente segura, escalável e de baixo custo** na AWS, utilizando S3, CloudFront, e as melhores práticas de segurança.

O objetivo deste projeto é **democratizar o acesso a uma infraestrutura de ponta**, permitindo que qualquer pessoa, mesmo com pouco conhecimento de AWS, possa ter seu site estático no ar com segurança e performance de nível empresarial.

## ✨ Por que usar este projeto?

*   🔒 **Segurança em Primeiro Lugar:** Configuração robusta de segurança, incluindo:
    *   **AWS WAF:** Firewall de Aplicação Web com regras gerenciadas pela AWS para proteção contra ataques comuns (OWASP Top 10).
    *   **Cabeçalhos de Segurança:** Implementação de `Strict-Transport-Security` (HSTS), `X-Frame-Options`, `X-Content-Type-Options` e `Content-Security-Policy` (CSP) para mitigar vulnerabilidades no lado do cliente.
    *   **Acesso Restrito ao S3:** O bucket S3 é privado e acessível apenas através do CloudFront utilizando Origin Access Control (OAC).
    *   **Redirecionamento para HTTPS:** Todo o tráfego é forçado para HTTPS.
*   🚀 **Alta Performance e Escalabilidade:**
    *   **Amazon CloudFront:** Conteúdo distribuído globalmente para baixa latência e alta velocidade de entrega.
    *   **Amazon S3:** Armazenamento de objetos durável e escalável para os arquivos do seu site.
*   💰 **Custo-Benefício:** Arquitetura serverless que se beneficia do generoso Free Tier da AWS, tornando a hospedagem extremamente barata ou até mesmo gratuita para sites com tráfego moderado.
*   🔄 **Deploy Simplificado com GitHub Actions:**
    *   **Processo de 2 Etapas:** O deploy é dividido em duas etapas para facilitar a configuração de domínios recém-registrados:
        1.  **Criação do DNS:** Cria a zona hospedada no Route 53 e fornece os nameservers.
        2.  **Deploy do Site:** Após a configuração dos nameservers, um simples "aprovar" no GitHub Actions implanta todo o resto da infraestrutura.
    *   **Totalmente Automatizado:** Faça o push para a branch `main` e deixe o GitHub Actions cuidar de todo o processo de deploy.

## 🚀 Começando

### Pré-requisitos

1.  **Conta na AWS:** Você precisará de uma conta na AWS e de credenciais de acesso (`AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`).
2.  **Domínio Registrado:** Um nome de domínio registrado em qualquer provedor (Route 53, GoDaddy, Namecheap, etc.).
3.  **Repositório no GitHub:** Um repositório no GitHub para hospedar seu código e utilizar o GitHub Actions.

### Configuração

1.  **Fork este repositório:** Comece fazendo um fork deste projeto para sua conta no GitHub.
2.  **Configure os Secrets do GitHub:**
    *   No seu repositório, vá em `Settings > Secrets and variables > Actions`.
    *   Crie dois novos secrets:
        *   `AWS_ACCESS_KEY_ID`: Sua chave de acesso da AWS.
        *   `AWS_SECRET_ACCESS_KEY`: Sua chave de acesso secreta da AWS.
3.  **Configure as Variáveis do Terraform:**
    *   Abra o arquivo `src/variables.tf` e ajuste as variáveis conforme necessário, principalmente `domain` e `bucket_name`.
4.  **Adicione os arquivos do seu site:**
    *   Coloque os arquivos do seu site estático (HTML, CSS, JS, etc.) na pasta `src/function`.

### Deploy

1.  **Push para a branch `main`:**
    *   Faça o commit e o push das suas alterações para a branch `main`.
    *   Isso acionará o workflow do GitHub Actions.
2.  **Etapa 1: Deploy do DNS**
    *   O job `deploy-dns` será executado automaticamente.
    *   Ao final da execução, vá nos logs do job e procure pelo output `name_servers`.
    *   Copie os quatro nameservers fornecidos.
3.  **Atualize os Nameservers do seu Domínio:**
    *   Vá até o painel de controle do seu provedor de domínio.
    *   Substitua os nameservers existentes pelos que você copiou do output do Terraform.
    *   **Aguarde a propagação do DNS.** Isso pode levar de alguns minutos a algumas horas.
4.  **Etapa 2: Deploy do Site**
    *   No seu repositório GitHub, vá para a aba `Actions` e encontre o workflow que está aguardando aprovação.
    *   Aprove o job `deploy-site`.
    *   O GitHub Actions agora irá provisionar o restante da infraestrutura: Certificado SSL, CloudFront, S3 e os registros DNS.

Pronto! Seu site estático está no ar, seguro e com alta performance.

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests para melhorar este projeto.
