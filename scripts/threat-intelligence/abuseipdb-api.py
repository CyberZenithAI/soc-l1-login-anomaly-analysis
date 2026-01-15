#!/usr/bin/env python3
"""
SOC L1 Lab - Integración con AbuseIPDB API
Consulta reputación de IPs y reportes de abuso
"""

import requests
import json
import sys
import os
from datetime import datetime, timedelta

class AbuseIPDB:
    def __init__(self, api_key=None):
        self.api_key = api_key or os.getenv("ABUSEIPDB_API_KEY")
        self.base_url = "https://api.abuseipdb.com/api/v2"
        self.headers = {
            "Accept": "application/json",
            "Key": self.api_key
        }
    
    def check_ip(self, ip_address, max_age_days=30):
        """Consulta información de una IP"""
        url = f"{self.base_url}/check"
        params = {
            "ipAddress": ip_address,
            "maxAgeInDays": max_age_days,
            "verbose": True
        }
        
        response = requests.get(url, headers=self.headers, params=params)
        
        if response.status_code == 200:
            data = response.json()
            return self._parse_ip_data(data)
        else:
            return {"error": f"API Error: {response.status_code}"}
    
    def report_ip(self, ip_address, categories, comment=""):
        """Reporta una IP maliciosa"""
        url = f"{self.base_url}/report"
        data = {
            "ip": ip_address,
            "categories": categories,
            "comment": comment
        }
        
        response = requests.post(url, headers=self.headers, data=data)
        
        if response.status_code == 200:
            return {"success": True, "message": "IP reportada exitosamente"}
        else:
            return {"error": f"API Error: {response.status_code}"}
    
    def _parse_ip_data(self, data):
        """Parsea los datos de IP"""
        ip_data = data.get("data", {})
        
        return {
            "ip": ip_data.get("ipAddress", ""),
            "is_public": ip_data.get("isPublic", False),
            "abuse_confidence_score": ip_data.get("abuseConfidenceScore", 0),
            "country_code": ip_data.get("countryCode", ""),
            "country_name": ip_data.get("countryName", ""),
            "usage_type": ip_data.get("usageType", ""),
            "isp": ip_data.get("isp", ""),
            "domain": ip_data.get("domain", ""),
            "hostnames": ip_data.get("hostnames", []),
            "total_reports": ip_data.get("totalReports", 0),
            "num_distinct_users": ip_data.get("numDistinctUsers", 0),
            "last_reported_at": ip_data.get("lastReportedAt", ""),
            "is_whitelisted": ip_data.get("isWhitelisted", False),
            "recent_reports": [
                {
                    "reported_at": report.get("reportedAt", ""),
                    "comment": report.get("comment", ""),
                    "categories": report.get("categories", [])
                }
                for report in ip_data.get("reports", [])[:5]
            ]
        }

def main():
    if len(sys.argv) < 2:
        print("Uso: python abuseipdb-api.py <IP> [--report]")
        sys.exit(1)
    
    ip_address = sys.argv[1]
    report_mode = len(sys.argv) > 2 and sys.argv[2] == "--report"
    
    abuse = AbuseIPDB()
    
    if report_mode:
        print(f"📢 Reportando IP: {ip_address}")
        categories = [21, 22]  # SSH brute force categories
        comment = "SSH brute force attack detected in SOC L1 lab"
        
        result = abuse.report_ip(ip_address, categories, comment)
    else:
        print(f"🔍 Consultando reputación de: {ip_address}")
        result = abuse.check_ip(ip_address)
    
    print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
