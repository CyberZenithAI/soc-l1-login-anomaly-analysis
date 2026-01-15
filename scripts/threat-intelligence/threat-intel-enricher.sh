#!/bin/bash
# SOC L1 Lab - Enriquecimiento de Alertas con Threat Intelligence

set -e

echo "🔄 Enriqueciendo alertas con Threat Intelligence..."

ALERT_FILE="${1:-logs/alerts/latest-alert.json}"
OUTPUT_FILE="logs/threat-intel/enriched-$(date +%Y%m%d-%H%M%S).json"

if [ ! -f "$ALERT_FILE" ]; then
    echo "❌ Archivo de alerta no encontrado: $ALERT_FILE"
    exit 1
fi

# Extraer IP del alerta
IP=$(jq -r '.data.srcip' "$ALERT_FILE" 2>/dev/null || echo "")

if [ -z "$IP" ]; then
    echo "⚠️ No se encontró IP en la alerta"
    exit 0
fi

echo "🎯 IP a enriquecer: $IP"

# Crear objeto de enriquecimiento
ENRICHMENT=$(cat <<EOF
{
  "alert_file": "$ALERT_FILE",
  "enrichment_timestamp": "$(date -Iseconds)",
  "source_ip": "$IP",
  "threat_intelligence": {}
}
EOF
)

# VirusTotal
if [ -n "$VIRUSTOTAL_API_KEY" ]; then
    echo "🔍 Consultando VirusTotal..."
    VT_RESULT=$(python3 scripts/threat-intelligence/virustotal-api.py "$IP" 2>/dev/null || echo "{}")
    ENRICHMENT=$(echo "$ENRICHMENT" | jq --argjson vt "$VT_RESULT" '.threat_intelligence.virustotal = $vt')
fi

# AbuseIPDB
if [ -n "$ABUSEIPDB_API_KEY" ]; then
    echo "🔍 Consultando AbuseIPDB..."
    ABUSE_RESULT=$(python3 scripts/threat-intelligence/abuseipdb-api.py "$IP" 2>/dev/null || echo "{}")
    ENRICHMENT=$(echo "$ENRICHMENT" | jq --argjson abuse "$ABUSE_RESULT" '.threat_intelligence.abuseipdb = $abuse')
fi

# Guardar resultado
echo "$ENRICHMENT" | jq . > "$OUTPUT_FILE"

echo "✅ Enriquecimiento completado: $OUTPUT_FILE"
