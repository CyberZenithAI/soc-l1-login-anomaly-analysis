# 🚀 Flujo de Trabajo SOC L1

## 📋 Visión General
Este documento describe el flujo de trabajo estándar para analistas SOC Nivel 1 en el laboratorio.

## 🔄 Proceso de Triage

### 1. Recepción de Alerta
- Monitorizar panel de Wazuh Dashboard
- Revisar alertas en tiempo real
- Priorizar por severidad

### 2. Análisis Inicial
- Verificar fuente de la alerta
- Revisar logs relacionados
- Consultar Threat Intelligence

### 3. Clasificación
- Determinar severidad (Low/Medium/High/Critical)
- Categorizar tipo de incidente
- Asignar tiempo de respuesta

### 4. Documentación
- Registrar en sistema de tickets
- Documentar hallazgos iniciales
- Capturar evidencias

### 5. Escalamiento
- Determinar necesidad de escalamiento
- Transferir a SOC L2 con contexto completo
- Mantener seguimiento del caso

## 🛠️ Herramientas Utilizadas

### Monitoreo
- **Wazuh Dashboard**: Alertas en tiempo real
- **Kibana**: Análisis de logs y visualización
- **Prometheus**: Métricas del sistema
- **Grafana**: Dashboards de monitoreo

### Análisis
- **SSH Brute Force Scripts**: Simulación de ataques
- **Log Analysis**: Análisis de logs de autenticación
- **Network Tools**: nmap, netstat, tcpdump

### Threat Intelligence
- **VirusTotal API**: Reputación de IPs/hashes
- **AbuseIPDB API**: Reportes de abuso
- **Custom Scripts**: Automatización de consultas

## 📊 Métricas Clave

### Tiempos de Respuesta
- **Tiempo de Detección (MTTD)**: < 5 minutos
- **Tiempo de Respuesta (MTTR)**: < 30 minutos
- **Tiempo de Resolución (MTTC)**: < 4 horas

### Efectividad
- **Tasa de Detección**: > 95%
- **Falsos Positivos**: < 5%
- **Alertas Escaladas**: < 20%

## 📝 Plantillas

### Reporte de Incidente
```markdown
# Incidente: [ID]
**Fecha**: [YYYY-MM-DD HH:MM]
**Severidad**: [Low/Medium/High/Critical]

## Resumen
[Descripción breve del incidente]

## Detección
- Fuente: [Wazuh/Manual/Otra]
- Hora de detección: [HH:MM]
- Alertas relacionadas: [IDs]

## Análisis
- IP de origen: [IP]
- Técnicas utilizadas: [Lista]
- Sistemas afectados: [Lista]

## Impacto
- Categoría: [Brute Force/Malware/Scanning]
- Severidad estimada: [1-10]
- Usuarios afectados: [Número]

## Respuesta
- Acciones tomadas: [Lista]
- Tiempo de respuesta: [Minutos]
- Estado actual: [Abierto/En progreso/Cerrado]

## Recomendaciones
1. [Recomendación 1]
2. [Recomendación 2]
3. [Recomendación 3]
