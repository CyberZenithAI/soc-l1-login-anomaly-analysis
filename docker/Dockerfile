# SOC L1 Lab - Dockerfile personalizado
FROM alpine:latest

LABEL maintainer="Joaquín Ocampo <webdev.student123@outlook.com>"
LABEL version="2.0"
LABEL description="SOC L1 Lab - Login Anomaly Analysis"

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    python3 \
    py3-pip \
    openssl \
    ca-certificates \
    && pip3 install --upgrade pip \
    && pip3 install requests beautifulsoup4

WORKDIR /app

COPY scripts/ /app/scripts/

RUN chmod +x /app/scripts/*.sh

CMD ["/bin/bash"]
