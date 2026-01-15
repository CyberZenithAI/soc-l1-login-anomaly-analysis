#!/bin/bash
# SOC L1 Lab - Triage de Alertas
# Proceso de triaje para alertas de seguridad

set -e

echo "🚨 Iniciando proceso de triaje de alertas..."

ALERT_DIR="logs/alerts"
TRIAGE_DIR="logs/triage"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

mkdir -p "$TRIAGE_DIR"

# Buscar alertas recientes (últimas 24 horas)
RECENT_ALERTS=$(find "$ALERT_DIR" -name "*.json" -mtime -1)

if [ -z "$RECENT_ALERTS" ]; then
    echo "📭 No hay alertas recientes"
    exit 0
fi

echo "📊 Alertas encontradas: $(echo "$RECENT_ALERTS" | wc -l)"

# Procesar cada alerta
for alert in $RECENT_ALERTS; do
    echo "🔍 Procesando: $(basename "$alert")"
    
    # Clasificar alerta
    CLASSIFICATION=$(python3 scripts/soc-workflow/incident-classifier.py "$alert" 2>/dev/null)
    
    # Extraer severidad
    SEVERITY=$(echo "$CLASSIFICATION" | jq -r '.severity' 2>/dev/null || echo "UNKNOWN")
    
    # Crear registro de triaje
    TRIAGE_RECORD=$(cat <<EOF
{
  "triage_id": "TRIAGE_$TIMESTAMP",
  "alert_file": "$alert",
  "triage_timestamp": "$(date -Iseconds)",
  "analyst": "SOC_L1_ANALYST",
  "severity_assigned": "$SEVERITY",
  "classification": $(echo "$CLASSIFICATION" | jq '.classification' || echo '"UNKNOWN"'),
  "initial_assessment": "Requires further investigation",
  "action_taken": "Alert logged for review",
  "next_steps": [
    "Verify source IP",
    "Check affected systems",
    "Review related logs"
  ],
  "status": "PENDING"
}
EOF
)
    
    # Guardar triaje
    TRIAGE_FILE="$TRIAGE_DIR/triage-$(basename "$alert" .json)-$TIMESTAMP.json"
    echo "$TRIAGE_RECORD" | jq . > "$TRIAGE_FILE"
    
    echo "✅ Triaje guardado: $TRIAGE_FILE"
done

echo "🏁 Proceso de triaje completado"
echo "📁 Resultados en: $TRIAGE_DIR"
