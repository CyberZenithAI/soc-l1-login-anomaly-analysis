#!/bin/bash
# SOC L1 Lab - Instalación de Dependencias
# Para Ubuntu/Debian/Kali/Parrot

set -e

echo "🔧 Instalando dependencias del sistema..."

# Actualizar repositorios
apt-get update

# Instalar Docker y Docker Compose
if ! command -v docker &> /dev/null; then
    echo "📦 Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

if ! command -v docker-compose &> /dev/null; then
    echo "📦 Instalando Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Instalar herramientas necesarias
echo "📦 Instalando herramientas de seguridad..."
apt-get install -y \
    jq \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    openssh-client \
    nmap \
    net-tools \
    iputils-ping

# Instalar Python dependencies
echo "🐍 Instalando dependencias de Python..."
pip3 install requests beautifulsoup4 virustotal-api

echo "✅ Dependencias instaladas correctamente!"
