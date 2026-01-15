#!/usr/bin/env python3
"""
SOC L1 Lab - Generador de Logs de Autenticación
Genera logs de autenticación realistas para pruebas
"""

import random
import datetime
import json
import sys

def generate_ssh_log():
    """Genera una entrada de log SSH"""
    timestamp = datetime.datetime.now().strftime("%b %d %H:%M:%S")
    users = ["root", "admin", "ubuntu", "test", "user", "sshuser"]
    statuses = ["Failed password", "Accepted password", "Invalid user"]
    ips = [f"192.168.1.{random.randint(1, 255)}" for _ in range(5)]
    
    log_type = random.choice(statuses)
    user = random.choice(users)
    ip = random.choice(ips)
    port = random.randint(1024, 65535)
    
    return f"{timestamp} ssh-server sshd[{random.randint(1000, 9999)}]: {log_type} for {user} from {ip} port {port} ssh2"

def main():
    """Función principal"""
    num_logs = 50 if len(sys.argv) < 2 else int(sys.argv[1])
    
    print(f"📝 Generando {num_logs} logs de autenticación...")
    
    with open("logs/sample-auth.log", "w") as f:
        for _ in range(num_logs):
            log = generate_ssh_log()
            f.write(log + "\n")
    
    print(f"✅ Logs guardados en: logs/sample-auth.log")

if __name__ == "__main__":
    main()
