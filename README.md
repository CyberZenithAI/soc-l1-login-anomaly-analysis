# 🔐 SOC L1 – Análisis de Anomalías en Inicios de Sesión (2026)

## 📌 Resumen
Proyecto práctico de **portafolio SOC L1** enfocado en detectar, analizar y documentar **actividad sospechosa de inicio de sesión** utilizando **Wazuh SIEM** y registros de autenticación reales dentro de un entorno de laboratorio controlado.

Este repositorio está diseñado para **roles SOC/Blue Team de nivel inicial**, demostrando habilidades prácticas en lugar de solo teoría.

---

## 🎯 Objetivos del Proyecto
- Detectar comportamientos sospechosos de autenticación  
- Analizar registros de seguridad (`auth.log`)  
- Clasificar incidentes por severidad e impacto  
- Aplicar el **flujo de trabajo de escalamiento SOC L1** adecuado  

---

## 🧠 Escenario Simulado
- **Ataque de fuerza bruta SSH**  
- Múltiples intentos fallidos de inicio de sesión  
- Inicio de sesión exitoso posterior  
- Cuenta de usuario local válida  

Este escenario refleja un **caso común del mundo real en SOC L1**.

---

## 🛠️ Herramientas y Tecnologías
- **Wazuh SIEM** (implementación en Docker)  
- Kali Linux  
- SSH  
- Hydra *(usado estrictamente en un laboratorio controlado)*  
- VirusTotal (reputación de IP)  
- AbuseIPDB (inteligencia de amenazas)  
- GitHub (documentación y control de versiones)  

---

## 🧩 Arquitectura del Laboratorio
| Rol | Sistema |
|---|---|
| Analista SOC | Kali Linux |
| Endpoint | Kali Linux (servicio SSH) |
| SIEM | Wazuh (Docker) |

---

## 🔍 Flujo de Trabajo de Análisis SOC L1
1. Revisión de alertas en el Panel de Wazuh  
2. Análisis de registros de autenticación (`auth.log`)  
3. Validación de IP de origen y comportamiento  
4. Correlación de eventos  
5. Clasificación de incidentes  
6. Escalamiento a SOC L2 con evidencia  

---

## 📊 Clasificación del Incidente
- **Tipo:** Fuerza Bruta SSH  
- **Severidad:** Media / Alta  
- **Impacto:** Potencial compromiso de credenciales  
- **Acción Recomendada:** Escalamiento y mitigación  

---

## 📂 Estructura del Repositorio
```
soc-l1-login-anomaly-analysis/
├── 📂 docker/
│   ├── docker-compose.yml          # Orquestación principal
│   ├── Dockerfile                  # Imagen personalizada
│   └── wazuh-config/
│       ├── ossec.conf             # Configuración principal Wazuh
│       ├── local_rules.xml        # Reglas personalizadas
│       └── decoders/
│           └── custom_decoders.xml
├── 📂 scripts/
│   ├── setup/
│   │   ├── install-dependencies.sh
│   │   ├── setup-lab.sh
│   │   └── health-check.sh
│   ├── simulation/
│   │   ├── ssh-brute-force.sh
│   │   ├── port-scan-sim.sh
│   │   └── generate-auth-logs.py
│   ├── threat-intelligence/
│   │   ├── virustotal-api.py
│   │   ├── abuseipdb-api.py
│   │   └── threat-intel-enricher.sh
│   └── soc-workflow/
│       ├── incident-classifier.py
│       ├── alert-triage.sh
│       └── escalation-workflow.md
├── 📂 config/
│   ├── ssh-server/
│   │   ├── sshd_config
│   │   └── authorized_keys
│   ├── kali-attacker/
│   │   └── attack-scripts/
│   └── firewall/
│       └── iptables-rules.sh
├── 📂 docs/
│   ├── SOC-WORKFLOW.md
│   ├── INCIDENT-RESPONSE-GUIDE.md
│   ├── API-INTEGRATION.md
│   └── ETHICAL-GUIDELINES.md
├── 📂 examples/
│   ├── alerts/
│   │   ├── ssh-brute-force-alert.json
│   │   └── port-scan-alert.json
│   ├── dashboards/
│   │   └── kibana-export.ndjson
│   ├── reports/
│   │   ├── incident-report-template.md
│   │   └── soc-daily-report.md
│   └── logs/
│       └── sample-auth.log
├── 📂 tests/
│   ├── test-detection-rules.sh
│   └── test-api-integration.py
├── 📂 monitoring/
│   ├── prometheus/
│   │   └── prometheus.yml
│   └── grafana/
│       └── dashboards/
├── .env.example
├── .gitignore
├── LICENSE
├── README.md
├── CHANGELOG.md
└── CONTRIBUTING.md
```

---

## 🧠 Habilidades Demostradas
✔ Mentalidad operativa SOC L1  
✔ Análisis de registros y triaje de alertas  
✔ Uso adecuado de SIEM  
✔ Clasificación de incidentes y escalamiento  
✔ Documentación clara y profesional  

---

## 🚀 Roles Objetivo
**Analista SOC L1 | Blue Team Junior | Analista Junior de Ciberseguridad**

---

## ⚠️ Aviso Ético
Todas las actividades se realizaron en un **entorno de laboratorio aislado y de propiedad propia** con **fines educativos y profesionales únicamente**.

---

📌 *Este proyecto fue desarrollado como parte de mi preparación para trabajar en un Centro de Operaciones de Seguridad (SOC) real en 2026.*
