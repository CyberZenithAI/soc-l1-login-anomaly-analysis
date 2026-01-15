#!/bin/bash
# SOC L1 Lab - Setup Script
# Complete deployment script for Ubuntu/Kali/Parrot

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Banner
print_banner() {
    clear
    echo -e "${BLUE}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════╗
║    ███████╗ ██████╗  ██████╗    ██╗      ██████╗ ██████╗                 ║
║    ██╔════╝██╔═══██╗██╔════╝    ██║     ██╔═══██╗██╔══██╗                ║
║    ███████╗██║   ██║██║         ██║     ██║   ██║██████╔╝                ║
║    ╚════██║██║   ██║██║         ██║     ██║   ██║██╔══██╗                ║
║    ███████║╚██████╔╝╚██████╗    ███████╗╚██████╔╝██║  ██║                ║
║    ╚══════╝ ╚═════╝  ╚═════╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝                ║
║                                                                          ║
║                SOC L1 - Login Anomaly Analysis Lab                      ║
║                    Complete Deployment Script                           ║
║                        Version 2.0 - 2026                               ║
╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${RED}[!] Please run as root (sudo)${NC}"
        exit 1
    fi
}

# Detect OS
detect_os() {
    echo -e "${CYAN}[*] Detecting operating system...${NC}"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    echo -e "${GREEN}[+] OS: $OS $VER${NC}"
    
    case $OS in
        *Ubuntu*|*Debian*|*Kali*|*Parrot*)
            echo -e "${GREEN}[+] Supported OS detected${NC}"
            PACKAGE_MANAGER="apt"
            ;;
        *CentOS*|*Red*Hat*|*Fedora*|*Rocky*)
            echo -e "${GREEN}[+] RHEL-based OS detected${NC}"
            PACKAGE_MANAGER="yum"
            ;;
        *)
            echo -e "${YELLOW}[!] Unsupported OS: $OS${NC}"
            echo -e "${YELLOW}[!] Attempting to continue anyway...${NC}"
            PACKAGE_MANAGER="apt"
            ;;
    esac
}

# Install dependencies
install_dependencies() {
    echo -e "${CYAN}[*] Installing system dependencies...${NC}"
    
    if [ "$PACKAGE_MANAGER" = "apt" ]; then
        apt-get update
        apt-get install -y \
            curl \
            wget \
            git \
            vim \
            net-tools \
            iputils-ping \
            dnsutils \
            jq \
            python3 \
            python3-pip \
            python3-venv \
            openssl \
            ca-certificates \
            gnupg \
            lsb-release \
            software-properties-common \
            apt-transport-https \
            gnupg-agent
        
        # Install Docker
        if ! command -v docker &> /dev/null; then
            echo -e "${YELLOW}[*] Installing Docker...${NC}"
            curl -fsSL https://get.docker.com -o get-docker.sh
            sh get-docker.sh
            rm get-docker.sh
        fi
        
        # Install Docker Compose
        if ! command -v docker-compose &> /dev/null; then
            echo -e "${YELLOW}[*] Installing Docker Compose...${NC}"
            LATEST_COMPOSE=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d'"' -f4)
            curl -L "https://github.com/docker/compose/releases/download/$LATEST_COMPOSE/docker-compose-$(uname -s)-$(uname -m)" \
                -o /usr/local/bin/docker-compose
            chmod +x /usr/local/bin/docker-compose
        fi
        
    elif [ "$PACKAGE_MANAGER" = "yum" ]; then
        yum install -y \
            curl \
            wget \
            git \
            vim \
            net-tools \
            bind-utils \
            jq \
            python3 \
            python3-pip \
            openssl \
            ca-certificates \
            gnupg \
            yum-utils
        
        # Install Docker for RHEL-based
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install -y docker-ce docker-ce-cli containerd.io
        systemctl start docker
        systemctl enable docker
        
        # Install Docker Compose
        curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
            -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    
    echo -e "${GREEN}[+] Dependencies installed successfully${NC}"
}

# Setup environment
setup_environment() {
    echo -e "${CYAN}[*] Setting up SOC L1 lab environment...${NC}"
    
    # Create directory structure
    mkdir -p {docker,scripts,config,docs,examples,tests,monitoring,logs}
    mkdir -p docker/wazuh-config/decoders
    mkdir -p scripts/{setup,simulation,threat-intelligence,soc-workflow}
    mkdir -p config/{ssh-server,kali-attacker,firewall,fluentd}
    mkdir -p examples/{alerts,dashboards,reports,logs}
    mkdir -p monitoring/{prometheus,grafana/dashboards}
    mkdir -p logs/{wazuh,collected,attacks}
    
    # Create .env file if not exists
    if [ ! -f .env ]; then
        echo -e "${YELLOW}[*] Creating .env configuration file${NC}"
        cat > .env << EOF
# ==================== SOC L1 LAB CONFIGURATION ====================
# Generated: $(date)
# Lab: SOC L1 - Login Anomaly Analysis

# Wazuh Configuration
WAZUH_PASSWORD=ChangeMe123!
WAZUH_API_USER=wazuh
WAZUH_API_PASS=wazuh-api-pass

# SSH Server Configuration
SSH_USER=socuser
SSH_PASSWORD=S0cP@ssw0rd!
ROOT_PASSWORD=R00tP@ss!

# Threat Intelligence APIs (Optional)
VIRUSTOTAL_API_KEY=
ABUSEIPDB_API_KEY=
SHODAN_API_KEY=

# Network Configuration
LAB_SUBNET=10.10.10.0/24
LAB_GATEWAY=10.10.10.1

# Monitoring
GRAFANA_PASSWORD=grafana123
PROMETHEUS_RETENTION=15d

# Simulation Parameters
MAX_SSH_ATTEMPTS=10
SCAN_TIMEOUT=30
LOG_RETENTION_DAYS=30

# Security Settings
ENABLE_FIREWALL=true
ENABLE_LOGGING=true
ENABLE_MONITORING=true
EOF
        echo -e "${YELLOW}[!] Please edit .env file with your passwords and API keys${NC}"
    fi
    
    # Set permissions
    chmod -R 750 scripts/
    chmod -R 640 config/
    chmod 600 .env 2>/dev/null || true
    
    echo -e "${GREEN}[+] Environment setup completed${NC}"
}

# Deploy Docker services
deploy_services() {
    echo -e "${CYAN}[*] Deploying SOC L1 lab services...${NC}"
    
    # Load environment variables
    if [ -f .env ]; then
        export $(grep -v '^#' .env | xargs)
    fi
    
    # Check Docker Compose file
    if [ ! -f docker/docker-compose.yml ]; then
        echo -e "${RED}[!] docker-compose.yml not found${NC}"
        exit 1
    fi
    
    # Pull Docker images
    echo -e "${BLUE}[*] Pulling Docker images...${NC}"
    docker-compose -f docker/docker-compose.yml pull --quiet
    
    # Start services
    echo -e "${BLUE}[*] Starting SOC L1 lab services...${NC}"
    docker-compose -f docker/docker-compose.yml up -d
    
    # Wait for services to initialize
    echo -e "${BLUE}[*] Waiting for services to initialize (60 seconds)...${NC}"
    sleep 60
    
    # Check service status
    echo -e "${BLUE}[*] Checking service status...${NC}"
    docker-compose -f docker/docker-compose.yml ps
    
    echo -e "${GREEN}[+] Services deployed successfully${NC}"
}

# Configure Wazuh
configure_wazuh() {
    echo -e "${CYAN}[*] Configuring Wazuh SIEM...${NC}"
    
    # Wait for Wazuh to be ready
    echo -e "${BLUE}[*] Waiting for Wazuh to be ready...${NC}"
    for i in {1..30}; do
        if docker exec wazuh_manager curl -s -u wazuh:wazuh-api-pass http://localhost:55000 >/dev/null 2>&1; then
            echo -e "${GREEN}[+] Wazuh manager is ready${NC}"
            break
        fi
        sleep 2
    done
    
    # Test Wazuh API
    echo -e "${BLUE}[*] Testing Wazuh API...${NC}"
    if docker exec wazuh_manager curl -s -u wazuh:wazuh-api-pass http://localhost:55000 | grep -q "wazuh"; then
        echo -e "${GREEN}[+] Wazuh API is accessible${NC}"
    else
        echo -e "${YELLOW}[!] Wazuh API may not be ready yet${NC}"
    fi
    
    echo -e "${GREEN}[+] Wazuh configuration completed${NC}"
}

# Setup firewall rules
setup_firewall() {
    echo -e "${CYAN}[*] Configuring firewall rules...${NC}"
    
    if [ "$ENABLE_FIREWALL" = "true" ]; then
        # Save current iptables rules
        iptables-save > config/firewall/iptables-backup-$(date +%Y%m%d-%H%M%S).rules
        
        # Create SOC lab firewall rules
        cat > config/firewall/iptables-rules.sh << 'EOF'
#!/bin/bash
# SOC L1 Lab Firewall Rules

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH on port 2222 for lab
iptables -A INPUT -p tcp --dport 2222 -j ACCEPT

# Allow Wazuh ports
iptables -A INPUT -p tcp --dport 1514:1516 -j ACCEPT
iptables -A INPUT -p udp --dport 514 -j ACCEPT
iptables -A INPUT -p tcp --dport 55000 -j ACCEPT

# Allow Wazuh Dashboard (HTTPS)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow Elasticsearch
iptables -A INPUT -p tcp --dport 9200 -j ACCEPT

# Allow Kibana/Wazuh Dashboard
iptables -A INPUT -p tcp --dport 5601 -j ACCEPT

# Allow Prometheus
iptables -A INPUT -p tcp --dport 9090 -j ACCEPT

# Allow Grafana
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT

# Allow ICMP (ping)
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Log dropped packets
iptables -A INPUT -j LOG --log-prefix "SOC-LAB-DROPPED: " --log-level 4
EOF
        
        chmod +x config/firewall/iptables-rules.sh
        ./config/firewall/iptables-rules.sh
        
        echo -e "${GREEN}[+] Firewall rules configured${NC}"
    else
        echo -e "${YELLOW}[!] Firewall configuration skipped${NC}"
    fi
}

# Generate test data
generate_test_data() {
    echo -e "${CYAN}[*] Generating test data...${NC}"
    
    # Create sample auth.log
    cat > examples/logs/sample-auth.log << 'EOF'
Jan 15 10:30:15 ssh-server sshd[1234]: Failed password for invalid user admin from 10.10.10.30 port 54321 ssh2
Jan 15 10:30:16 ssh-server sshd[1235]: Failed password for root from 10.10.10.30 port 54322 ssh2
Jan 15 10:30:17 ssh-server sshd[1236]: Failed password for user test from 10.10.10.30 port 54323 ssh2
Jan 15 10:30:18 ssh-server sshd[1237]: Failed password for invalid user administrator from 10.10.10.30 port 54324 ssh2
Jan 15 10:30:19 ssh-server sshd[1238]: Failed password for root from 10.10.10.30 port 54325 ssh2
Jan 15 10:30:20 ssh-server sshd[1239]: Accepted password for socuser from 10.10.10.30 port 54326 ssh2
Jan 15 10:30:21 ssh-server sshd[1240]: pam_unix(sshd:session): session opened for user socuser by (uid=0)
Jan 15 10:35:22 ssh-server sshd[1241]: Received disconnect from 10.10.10.30 port 54326:11: disconnected by user
Jan 15 10:35:23 ssh-server sshd[1242]: pam_unix(sshd:session): session closed for user socuser
EOF
    
    # Create sample alert
    cat > examples/alerts/ssh-brute-force-alert.json << 'EOF'
{
  "timestamp": "2026-01-15T10:30:20.000Z",
  "rule": {
    "id": "100001",
    "description": "Multiple SSH authentication failures from same source IP (Brute Force)",
    "level": 10,
    "groups": ["authentication_failures", "ssh", "brute_force"]
  },
  "agent": {
    "id": "001",
    "name": "ssh.target.lab",
    "ip": "10.10.10.20"
  },
  "manager": {
    "name": "wazuh.manager"
  },
  "data": {
    "srcip": "10.10.10.30",
    "srcport": "54321",
    "dstip": "10.10.10.20",
    "dstport": "22",
    "protocol": "ssh",
    "failed_attempts": 5,
    "timeframe": "60",
    "usernames": ["admin", "root", "test", "administrator"]
  },
  "location": "/var/log/auth.log",
  "decoder": {
    "name": "sshd"
  },
  "full_log": "Jan 15 10:30:15 ssh-server sshd[1234]: Failed password for invalid user admin from 10.10.10.30 port 54321 ssh2"
}
EOF
    
    echo -e "${GREEN}[+] Test data generated${NC}"
}

# Display access information
show_access_info() {
    echo -e "${MAGENTA}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                SOC L1 LAB ACCESS INFORMATION             ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo "║                                                          ║"
    echo "║  🌐 Wazuh Dashboard:                                     ║"
    echo "║     URL:      https://localhost:443                     ║"
    echo "║     User:     admin                                     ║"
    echo "║     Password: ChangeMe123!                              ║"
    echo "║                                                          ║"
    echo "║  🔐 SSH Target Server:                                   ║"
    echo "║     Host:     localhost:2222                            ║"
    echo "║     User:     socuser                                   ║"
    echo "║     Password: S0cP@ssw0rd!                              ║"
    echo "║                                                          ║"
    echo "║  📊 Grafana Dashboard:                                   ║"
    echo "║     URL:      http://localhost:3000                     ║"
    echo "║     User:     admin                                     ║"
    echo "║     Password: grafana123                                ║"
    echo "║                                                          ║"
    echo "║  📈 Prometheus:                                          ║"
    echo "║     URL:      http://localhost:9090                     ║"
    echo "║                                                          ║"
    echo "║  ⚠️ Kali Attacker Console:                               ║"
    echo "║     Command:  docker exec -it kali_attacker bash        ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}[*] Useful commands:${NC}"
    echo "  Check logs:        docker-compose -f docker/docker-compose.yml logs"
    echo "  Stop lab:          docker-compose -f docker/docker-compose.yml down"
    echo "  Start simulation:  ./scripts/simulation/ssh-brute-force.sh"
    echo "  Check health:      ./scripts/setup/health-check.sh"
}

# Main execution
main() {
    print_banner
    check_root
    detect_os
    install_dependencies
    setup_environment
    deploy_services
    configure_wazuh
    setup_firewall
    generate_test_data
    show_access_info
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║     SOC L1 LAB DEPLOYMENT COMPLETED SUCCESSFULLY!       ║"
    echo "║                 Lab is ready for use                     ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}[*] Next steps:${NC}"
    echo "  1. Access Wazuh Dashboard at https://localhost:443"
    echo "  2. Run simulation: ./scripts/simulation/ssh-brute-force.sh"
    echo "  3. Check alerts in Wazuh Dashboard"
    echo "  4. Follow SOC workflow in docs/SOC-WORKFLOW.md"
}

# Run main function
main "$@"
