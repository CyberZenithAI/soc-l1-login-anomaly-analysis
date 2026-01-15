#!/usr/bin/env python3
"""
SOC L1 Lab - Clasificador de Incidentes
Clasifica alertas basado en reglas predefinidas
"""

import json
import sys
import os
from datetime import datetime

class IncidentClassifier:
    def __init__(self):
        self.rules = self._load_rules()
    
    def _load_rules(self):
        """Carga reglas de clasificación"""
        return [
            {
                "name": "SSH Brute Force",
                "conditions": [
                    {"field": "rule.id", "operator": "in", "value": ["100001", "100002"]},
                    {"field": "rule.groups", "operator": "contains", "value": "brute_force"}
                ],
                "severity": "HIGH",
                "category": "Brute Force Attack",
                "response_time": "15m",
                "escalation": "SOC_L2"
            },
            {
                "name": "Port Scanning",
                "conditions": [
                    {"field": "rule.id", "operator": "in", "value": ["100010", "100011"]},
                    {"field": "rule.groups", "operator": "contains", "value": "port_scan"}
                ],
                "severity": "MEDIUM",
                "category": "Reconnaissance",
                "response_time": "30m",
                "escalation": "SOC_L1"
            },
            {
                "name": "Invalid User Attempts",
                "conditions": [
                    {"field": "rule.id", "operator": "in", "value": ["100020", "100021"]}
                ],
                "severity": "LOW",
                "category": "Authentication Failure",
                "response_time": "1h",
                "escalation": "SOC_L1"
            }
        ]
    
    def classify_alert(self, alert_data):
        """Clasifica una alerta según las reglas"""
        classification = {
            "alert_id": alert_data.get("id", ""),
            "timestamp": datetime.now().isoformat(),
            "classification": "UNCLASSIFIED",
            "severity": "UNKNOWN",
            "category": "Unknown",
            "confidence": 0,
            "recommended_actions": [],
            "escalation_path": "NONE"
        }
        
        for rule in self.rules:
            if self._check_conditions(alert_data, rule["conditions"]):
                classification.update({
                    "classification": rule["name"],
                    "severity": rule["severity"],
                    "category": rule["category"],
                    "confidence": 85,
                    "recommended_actions": [
                        "Review authentication logs",
                        "Check source IP reputation",
                        "Verify user account status"
                    ],
                    "escalation_path": rule["escalation"],
                    "response_time_required": rule["response_time"]
                })
                break
        
        return classification
    
    def _check_conditions(self, alert_data, conditions):
        """Verifica si se cumplen las condiciones"""
        for condition in conditions:
            field_value = self._get_nested_value(alert_data, condition["field"])
            
            if not self._evaluate_condition(field_value, condition):
                return False
        
        return True
    
    def _get_nested_value(self, data, field_path):
        """Obtiene valor de campo anidado"""
        keys = field_path.split(".")
        value = data
        
        for key in keys:
            if isinstance(value, dict):
                value = value.get(key, None)
            else:
                return None
        
        return value
    
    def _evaluate_condition(self, field_value, condition):
        """Evalúa una condición individual"""
        operator = condition["operator"]
        expected = condition["value"]
        
        if operator == "equals":
            return field_value == expected
        elif operator == "contains":
            return expected in field_value if isinstance(field_value, (list, str)) else False
        elif operator == "in":
            return field_value in expected if isinstance(expected, list) else False
        elif operator == "greater_than":
            return field_value > expected
        elif operator == "less_than":
            return field_value < expected
        
        return False

def main():
    if len(sys.argv) < 2:
        print("Uso: python incident-classifier.py <alerta.json>")
        sys.exit(1)
    
    alert_file = sys.argv[1]
    
    try:
        with open(alert_file, 'r') as f:
            alert_data = json.load(f)
    except FileNotFoundError:
        print(f"❌ Archivo no encontrado: {alert_file}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"❌ Error al parsear JSON: {alert_file}")
        sys.exit(1)
    
    classifier = IncidentClassifier()
    classification = classifier.classify_alert(alert_data)
    
    print("📋 Clasificación del Incidente:")
    print(json.dumps(classification, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
