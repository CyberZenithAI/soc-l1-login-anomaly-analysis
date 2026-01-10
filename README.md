# 🔐 SOC L1 – Login Anomaly Analysis (2026)

## 📌 Descripción
Proyecto práctico donde simulo y analizo un **login sospechoso** siguiendo el flujo de trabajo de un **Analista SOC L1 Junior**, utilizando **Wazuh SIEM** y análisis de logs reales en un laboratorio controlado.

Este repositorio está orientado a **portafolio profesional** para roles **SOC L1 / Blue Team Junior**.

---

## 🎯 Objetivo del proyecto
- Detectar actividad de autenticación sospechosa  
- Analizar logs de seguridad  
- Clasificar incidentes según severidad  
- Escalar correctamente como Analista SOC L1  

---

## 🧠 Escenario simulado
- Ataque de **fuerza bruta SSH**
- Múltiples intentos de login fallidos
- Login exitoso posterior
- Usuario válido en el sistema

---

## 🛠️ Herramientas utilizadas
- **Wazuh SIEM** (Docker)
- Kali Linux
- SSH
- Hydra *(solo laboratorio)*
- VirusTotal
- AbuseIPDB
- GitHub (documentación)

---

## 🧩 Arquitectura del laboratorio
| Rol | Sistema |
|---|---|
| SOC Analyst | Kali Linux |
| Endpoint | Kali Linux (SSH) |
| SIEM | Wazuh (Docker) |

---

## 🔍 Flujo de análisis SOC L1
1. Revisión de alertas en Wazuh  
2. Análisis de logs de autenticación (`auth.log`)  
3. Validación de IP y comportamiento  
4. Correlación de eventos  
5. Clasificación del incidente  
6. Escalamiento a SOC L2  

---

## 📊 Clasificación del incidente
- **Tipo:** Brute Force – SSH  
- **Severidad:** Media / Alta  
- **Impacto:** Riesgo de compromiso de credenciales  
- **Acción recomendada:** Escalamiento y mitigación  

---

## 📂 Estructura del repositorio
soc-l1-login-anomaly-analysis/
├── analysis/
│ └── login_case_analysis.md
├── detections/
│ └── wazuh_bruteforce_rule.xml
├── logs/
│ └── sample_auth.log
├── escalation/
│ └── soc_l1_escalation.md
└── screenshots/


---

## 🧠 Qué demuestra este proyecto
✔ Mentalidad SOC L1 real  
✔ Análisis de logs  
✔ Uso correcto de SIEM  
✔ Clasificación y escalamiento  
✔ Documentación profesional  

---

## 🚀 Rol objetivo
**Analista SOC L1 / Blue Team Junior / Analista de Ciberseguridad Junior**

---

## ⚠️ Nota ética
Todas las pruebas fueron realizadas en un **laboratorio propio y controlado**, con fines **educativos y profesionales**.

---

📌 *Proyecto desarrollado como parte de mi preparación para trabajar en un SOC real en 2026.*
