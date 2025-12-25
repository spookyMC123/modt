#!/bin/bash
# NexoHost Enterprise MOTD Installer
# Professional System Information Display

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🚀 NexoHost MOTD Installation Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Disable default Ubuntu MOTD messages
echo "[1/3] Disabling default MOTD scripts..."
chmod -x /etc/update-motd.d/* 2>/dev/null || true

# Create dynamic stats MOTD script
echo "[2/3] Creating NexoHost MOTD script..."
cat << 'EOF' > /etc/update-motd.d/00-nexohost
#!/bin/bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# NexoHost Enterprise MOTD - Professional System Information Display
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Extended Color Palette
HEADER_PRIMARY="\e[38;5;39m"      # Bright Blue
HEADER_ACCENT="\e[38;5;51m"       # Cyan
SUCCESS="\e[38;5;82m"             # Bright Green
WARNING="\e[38;5;214m"            # Orange
INFO="\e[38;5;117m"               # Light Blue
ACCENT="\e[38;5;213m"             # Pink/Magenta
LABEL="\e[38;5;250m"              # Light Gray
VALUE="\e[38;5;255m"              # White
HIGHLIGHT="\e[38;5;226m"          # Yellow
BORDER="\e[38;5;240m"             # Dark Gray
RESET="\e[0m"
BOLD="\e[1m"

# System Statistics Collection
collect_stats() {
    HOSTNAME=$(hostname)
    KERNEL=$(uname -r)
    OS_VERSION=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2 2>/dev/null || echo "Linux")
    
    # Load Average
    LOAD_1=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $1}' | xargs)
    LOAD_5=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $2}' | xargs)
    LOAD_15=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $3}' | xargs)
    
    # CPU Information
    CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)
    CPU_CORES=$(nproc)
    
    # Memory Statistics
    MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
    MEM_USED=$(free -h | awk '/Mem:/ {print $3}')
    MEM_FREE=$(free -h | awk '/Mem:/ {print $4}')
    MEM_TOTAL_MB=$(free -m | awk '/Mem:/ {print $2}')
    MEM_USED_MB=$(free -m | awk '/Mem:/ {print $3}')
    MEM_PERC=$((MEM_USED_MB * 100 / MEM_TOTAL_MB))
    
    # Disk Statistics
    DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
    DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
    DISK_AVAIL=$(df -h / | awk 'NR==2 {print $4}')
    DISK_PERC=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    
    # Network & Process Information
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    TOTAL_PROC=$(ps aux | wc -l)
    USERS_ACTIVE=$(who | wc -l)
    
    # Uptime
    UPTIME_PRETTY=$(uptime -p | sed 's/up //')
    
    # Last Login
    LAST_LOGIN=$(last -1 -R | head -1 | awk '{print $5, $6, $7, $8}')
    
    # Current Time
    CURRENT_TIME=$(date '+%A, %B %d, %Y - %H:%M:%S %Z')
}

# Status Bar Generator
generate_bar() {
    local percentage=$1
    local width=30
    local filled=$((percentage * width / 100))
    local empty=$((width - filled))
    
    local bar_color
    if [ $percentage -lt 50 ]; then
        bar_color=$SUCCESS
    elif [ $percentage -lt 80 ]; then
        bar_color=$WARNING
    else
        bar_color="\e[38;5;196m"  # Red
    fi
    
    printf "${bar_color}["
    printf "%${filled}s" | tr ' ' '█'
    printf "${BORDER}%${empty}s" | tr ' ' '░'
    printf "${bar_color}]${RESET} ${VALUE}%3d%%${RESET}" $percentage
}

# Display Header
display_header() {
    echo -e ""
    echo -e "${HEADER_PRIMARY}${BOLD}"
    echo -e "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                                                                              ║"
    echo -e "║   ███╗   ██╗███████╗██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗   ║"
    echo -e "║   ████╗  ██║██╔════╝╚██╗██╔╝██╔═══██╗██║  ██║██╔═══██╗██╔════╝╚══██╔══╝   ║"
    echo -e "║   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████║██║   ██║███████╗   ██║      ║"
    echo -e "║   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██╔══██║██║   ██║╚════██║   ██║      ║"
    echo -e "║   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║  ██║╚██████╔╝███████║   ██║      ║"
    echo -e "║   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝      ║"
    echo -e "║                                                                              ║"
    echo -e "║               ${HEADER_ACCENT}Premium Cloud Infrastructure & Hosting Services${HEADER_PRIMARY}              ║"
    echo -e "║                                                                              ║"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "${INFO}  ${CURRENT_TIME}${RESET}"
    echo -e ""
}

# Display System Information
display_system_info() {
    echo -e "${HEADER_ACCENT}${BOLD}┌─ SYSTEM OVERVIEW ──────────────────────────────────────────────────────────────┐${RESET}"
    echo -e ""
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET}\n" "Hostname:" "$HOSTNAME"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET}\n" "Operating System:" "$OS_VERSION"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET}\n" "Kernel Version:" "$KERNEL"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET}\n" "IP Address:" "$IP_ADDRESS"
    echo -e ""
}

# Display Performance Metrics
display_performance() {
    echo -e "${HEADER_ACCENT}${BOLD}┌─ PERFORMANCE METRICS ──────────────────────────────────────────────────────────┐${RESET}"
    echo -e ""
    
    # CPU Information
    echo -e "  ${HIGHLIGHT}━━━ CPU ${RESET}"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s (%s cores)${RESET}\n" "Processor:" "$CPU_MODEL" "$CPU_CORES"
    printf "  ${LABEL}%-18s${RESET} ${HIGHLIGHT}%s${RESET} / ${INFO}%s${RESET} / ${VALUE}%s${RESET}\n" "Load Average:" "$LOAD_1" "$LOAD_5" "$LOAD_15"
    echo -e ""
    
    # Memory Usage
    echo -e "  ${HIGHLIGHT}━━━ MEMORY ${RESET}"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET} used / ${INFO}%s${RESET} total (${VALUE}%s${RESET} free)\n" "RAM Usage:" "$MEM_USED" "$MEM_TOTAL" "$MEM_FREE"
    printf "  ${LABEL}%-18s${RESET} " "Memory Status:"
    generate_bar $MEM_PERC
    echo -e ""
    echo -e ""
    
    # Disk Usage
    echo -e "  ${HIGHLIGHT}━━━ STORAGE ${RESET}"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET} used / ${INFO}%s${RESET} total (${VALUE}%s${RESET} available)\n" "Disk Usage:" "$DISK_USED" "$DISK_TOTAL" "$DISK_AVAIL"
    printf "  ${LABEL}%-18s${RESET} " "Disk Status:"
    generate_bar $DISK_PERC
    echo -e ""
    echo -e ""
}

# Display Activity Information
display_activity() {
    echo -e "${HEADER_ACCENT}${BOLD}┌─ SYSTEM ACTIVITY ──────────────────────────────────────────────────────────────┐${RESET}"
    echo -e ""
    printf "  ${LABEL}%-18s${RESET} ${SUCCESS}%s${RESET}\n" "System Uptime:" "$UPTIME_PRETTY"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET}\n" "Active Users:" "$USERS_ACTIVE"
    printf "  ${LABEL}%-18s${RESET} ${VALUE}%s${RESET}\n" "Running Processes:" "$TOTAL_PROC"
    printf "  ${LABEL}%-18s${RESET} ${INFO}%s${RESET}\n" "Last Login:" "$LAST_LOGIN"
    echo -e ""
}

# Display Footer
display_footer() {
    echo -e "${BORDER}${BOLD}╰────────────────────────────────────────────────────────────────────────────────╯${RESET}"
    echo -e ""
    echo -e "  ${ACCENT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "  ${SUCCESS}${BOLD}  Enterprise-Grade Performance, Unmatched Reliability${RESET}"
    echo -e "  ${ACCENT}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e ""
    echo -e "  ${LABEL}Support:${RESET}  ${INFO}support@nexohost.online${RESET}     ${LABEL}|${RESET}     ${LABEL}Website:${RESET}  ${HEADER_ACCENT}www.nexohost.online${RESET}"
    echo -e "  ${LABEL}Portal:${RESET}   ${INFO}portal.nexohost.online${RESET}      ${LABEL}|${RESET}     ${LABEL}Status:${RESET}   ${SUCCESS}status.nexohost.online${RESET}"
    echo -e ""
    echo -e "${BORDER}  ────────────────────────────────────────────────────────────────────────────────${RESET}"
    echo -e ""
}

# Main Execution
collect_stats
display_header
display_system_info
display_performance
display_activity
display_footer
EOF

# Set executable permissions
echo "[3/3] Setting permissions..."
chmod +x /etc/update-motd.d/00-nexohost

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ NexoHost MOTD Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  ➜ Reconnect your SSH session to view the new MOTD"
echo "  ➜ Or run: /etc/update-motd.d/00-nexohost"
echo ""
