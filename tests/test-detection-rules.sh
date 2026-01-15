#!/bin/bash
# SOC L1 Lab - Pruebas de Reglas de Detección

set -e

echo "🧪 Probando reglas de detección Wazuh..."

# Crear test logs
TEST_LOG="logs/test-auth.log"
cat > "$TEST_LOG" << EOF
Jan 15 10:30:15 ssh-server sshd[1234]: Failed password for invalid user admin from 10.10.10.30 port 54321 ssh2
Jan 15 10:30:16 ssh-server sshd[1235]: Failed password for root from 10.10.10.30 port 54322 ssh2
Jan 15 10:30:17 ssh-server sshd[1236]: Failed password for user test from 10.10.10.30 port 54323 ssh2
Jan 15 10:30:18 ssh-server sshd[1237]: Failed password for invalid user administrator from 10.10.10.30 port 54324 ssh2
Jan 15 10:30:19 ssh-server sshd[1238]: Failed password for root from 10.10.10.30 port 54325 ssh2
Jan 15 10:30:20 ssh-server sshd[1239]: Accepted password for socuser from 10.10.10.30 port 54326 ssh2
EOF

echo "✅ Logs de prueba creados: $TEST_LOG"

# Probar clasificación
echo "🔍 Probando clasificación de incidentes..."
python3 scripts/soc-workflow/incident-classifier.py examples/alerts/ssh-brute-force-alert.json

# Probar scripts
echo "🚀 Probando scripts de simulación..."
chmod +x scripts/simulation/ssh-brute-force.sh
chmod +x scripts/simulation/port-scan-sim.sh

echo "✅ Pruebas completadas"
