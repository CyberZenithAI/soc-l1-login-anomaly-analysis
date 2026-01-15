#!/bin/bash
# SOC L1 Lab - Verificación de Salud

set -e

echo "🏥 Verificando estado del laboratorio..."

# Verificar Docker
if ! docker ps &> /dev/null; then
    echo "❌ Docker no está corriendo"
    exit 1
fi

# Verificar servicios
SERVICES=("wazuh_manager" "wazuh_indexer" "wazuh_dashboard" "ssh_target" "kali_attacker")

for service in "${SERVICES[@]}"; do
    if docker ps | grep -q "$service"; then
        echo "✅ $service está corriendo"
    else
        echo "❌ $service NO está corriendo"
    fi
done

# Verificar conexiones
echo "🔍 Verificando conectividad..."

# Wazuh API
if curl -s -k -u admin:admin https://localhost:55000 | grep -q "wazuh"; then
    echo "✅ Wazuh API accesible"
else
    echo "❌ Wazuh API no accesible"
fi

# SSH Server
if nc -z localhost 2222 &> /dev/null; then
    echo "✅ SSH Server accesible"
else
    echo "❌ SSH Server no accesible"
fi

echo "📊 Resumen de estado completado"
