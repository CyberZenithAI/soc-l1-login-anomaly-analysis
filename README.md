# 🔐 SOC L1 – Login Anomaly Analysis (2026)

## 📌 Overview
Practical **SOC L1 portfolio project** focused on detecting, analyzing, and documenting **suspicious login activity** using **Wazuh SIEM** and real authentication logs within a controlled laboratory environment.

This repository is designed for **entry-level SOC / Blue Team roles**, demonstrating hands-on skills rather than theory alone.

---

## 🎯 Project Objectives
- Detect suspicious authentication behavior  
- Analyze security logs (`auth.log`)  
- Classify incidents by severity and impact  
- Apply proper **SOC L1 escalation workflow**  

---

## 🧠 Simulated Scenario
- **SSH brute-force attack**  
- Multiple failed login attempts  
- Subsequent successful login  
- Valid local user account  

This scenario reflects a **common real-world SOC L1 case**.

---

## 🛠️ Tools & Technologies
- **Wazuh SIEM** (Docker deployment)  
- Kali Linux  
- SSH  
- Hydra *(used strictly in a controlled lab)*  
- VirusTotal (IP reputation)  
- AbuseIPDB (threat intelligence)  
- GitHub (documentation & version control)  

---

## 🧩 Lab Architecture
| Role | System |
|---|---|
| SOC Analyst | Kali Linux |
| Endpoint | Kali Linux (SSH service) |
| SIEM | Wazuh (Docker) |

---

## 🔍 SOC L1 Analysis Workflow
1. Alert review in Wazuh Dashboard  
2. Authentication log analysis (`auth.log`)  
3. Source IP and behavior validation  
4. Event correlation  
5. Incident classification  
6. Escalation to SOC L2 with evidence  

---

## 📊 Incident Classification
- **Type:** SSH Brute Force  
- **Severity:** Medium / High  
- **Impact:** Potential credential compromise  
- **Recommended Action:** Escalation and mitigation  

---

## 📂 Repository Structure

soc-l1-login-anomaly-analysis/
├── analysis/
│   └── login_case_analysis.md
├── detections/
│   └── wazuh_bruteforce_rule.xml
├── logs/
│   └── sample_auth.log
├── escalation/
│   └── soc_l1_escalation.md
└── screenshots/

---

## 🧠 Skills Demonstrated
✔ SOC L1 operational mindset  
✔ Log analysis and alert triage  
✔ Proper SIEM usage  
✔ Incident classification and escalation  
✔ Clear and professional documentation  

---

## 🚀 Target Roles
**SOC L1 Analyst | Blue Team Junior | Junior Cybersecurity Analyst**

---

## ⚠️ Ethical Notice
All activities were conducted in a **self-owned, isolated lab environment** for **educational and professional purposes only**.

---

📌 *This project was developed as part of my preparation to work in a real Security Operations Center (SOC) in 2026.*
