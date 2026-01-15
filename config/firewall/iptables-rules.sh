#!/bin/bash
# SOC L1 Lab - Reglas de Firewall
# Configuración básica de iptables para el laboratorio

echo "🔥 Configurando reglas de firewall..."

# Flush reglas existentes
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Políticas por defecto
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Conexiones establecidas
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# SSH (puerto 2222 para lab)
iptables -A INPUT -p tcp --dport 2222 -j ACCEPT

# Wazuh Manager
iptables -A INPUT -p tcp --dport 1514:1516 -j ACCEPT
iptables -A INPUT -p udp --dport 514 -j ACCEPT
iptables -A INPUT -p tcp --dport 55000 -j ACCEPT

# Wazuh Dashboard (HTTPS)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Elasticsearch
iptables -A INPUT -p tcp --dport 9200 -j ACCEPT

# Kibana/Wazuh Dashboard
iptables -A INPUT -p tcp --dport 5601 -j ACCEPT

# Prometheus
iptables -A INPUT -p tcp --dport 9090 -j ACCEPT

# Grafana
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT

# ICMP (ping)
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Log dropped packets
iptables -A INPUT -j LOG --log-prefix "SOC-LAB-DROPPED: " --log-level 4

echo "✅ Reglas de firewall configuradas"
