#!/bin/bash
# SOC L1 Lab - Simulación de Escaneo de Puertos

set -e

echo "🔍 Simulando escaneo de puertos..."

TARGET="10.10.10.20"
PORTS="22,80,443,8080,2222"

echo "🎯 Objetivo: $TARGET"
echo "📌 Puertos: $PORTS"

# Usar nmap para escaneo básico
if command -v nmap &> /dev/null; then
    nmap -p $PORTS $TARGET -oN logs/attacks/port-scan-$(date +%Y%m%d-%H%M%S).txt
else
    echo "⚠️ nmap no instalado, simulación manual..."
    for port in ${PORTS//,/ }; do
        echo "Probando puerto $port..."
        timeout 1 bash -c "echo > /dev/tcp/$TARGET/$port" 2>/dev/null && \
            echo "✅ Puerto $port ABIERTO" || \
            echo "❌ Puerto $port CERRADO"
    done
fi

echo "✅ Simulación completada"
