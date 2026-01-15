#!/usr/bin/env python3
"""
SOC L1 Lab - Integración con VirusTotal API
Consulta información de IPs, URLs o hashes
"""

import requests
import json
import sys
import os
from datetime import datetime

class VirusTotalAPI:
    def __init__(self, api_key=None):
        self.api_key = api_key or os.getenv("VIRUSTOTAL_API_KEY")
        self.base_url = "https://www.virustotal.com/api/v3"
        self.headers = {"x-apikey": self.api_key}
    
    def check_ip(self, ip_address):
        """Consulta información de una IP"""
        url = f"{self.base_url}/ip_addresses/{ip_address}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            data = response.json()
            return self._parse_ip_data(data)
        else:
            return {"error": f"API Error: {response.status_code}"}
    
    def check_hash(self, file_hash):
        """Consulta información de un hash de archivo"""
        url = f"{self.base_url}/files/{file_hash}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            data = response.json()
            return self._parse_hash_data(data)
        else:
            return {"error": f"API Error: {response.status_code}"}
    
    def _parse_ip_data(self, data):
        """Parsea los datos de IP"""
        attributes = data.get("data", {}).get("attributes", {})
        
        return {
            "ip": data.get("data", {}).get("id"),
            "reputation": attributes.get("reputation", 0),
            "last_analysis_stats": attributes.get("last_analysis_stats", {}),
            "asn": attributes.get("asn", ""),
            "country": attributes.get("country", ""),
            "malicious_count": attributes.get("last_analysis_stats", {}).get("malicious", 0),
            "suspicious_count": attributes.get("last_analysis_stats", {}).get("suspicious", 0),
            "harmless_count": attributes.get("last_analysis_stats", {}).get("harmless", 0),
            "undetected_count": attributes.get("last_analysis_stats", {}).get("undetected", 0),
            "last_analysis_date": datetime.fromtimestamp(
                attributes.get("last_analysis_date", 0)
            ).strftime("%Y-%m-%d %H:%M:%S") if attributes.get("last_analysis_date") else "N/A"
        }
    
    def _parse_hash_data(self, data):
        """Parsea los datos de hash"""
        attributes = data.get("data", {}).get("attributes", {})
        
        return {
            "hash": data.get("data", {}).get("id"),
            "type_description": attributes.get("type_description", ""),
            "size": attributes.get("size", 0),
            "last_analysis_stats": attributes.get("last_analysis_stats", {}),
            "malicious_count": attributes.get("last_analysis_stats", {}).get("malicious", 0),
            "meaningful_name": attributes.get("meaningful_name", ""),
            "tags": attributes.get("tags", []),
            "last_analysis_date": datetime.fromtimestamp(
                attributes.get("last_analysis_date", 0)
            ).strftime("%Y-%m-%d %H:%M:%S") if attributes.get("last_analysis_date") else "N/A"
        }

def main():
    if len(sys.argv) < 2:
        print("Uso: python virustotal-api.py <IP o HASH>")
        sys.exit(1)
    
    target = sys.argv[1]
    vt = VirusTotalAPI()
    
    print(f"🔍 Consultando información de: {target}")
    
    # Determinar si es IP o hash
    if "." in target:  # IP simple
        result = vt.check_ip(target)
    else:  # Hash
        result = vt.check_hash(target)
    
    print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
