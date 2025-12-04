#!/bin/bash
# UnixNodes Advanced MOTD Installer

echo "🔧 Installing Custom MOTD..."

# Disable default Ubuntu MOTD messages
chmod -x /etc/update-motd.d/* 2>/dev/null

# Create dynamic stats MOTD script
cat << 'EOF' > /etc/update-motd.d/00-unixnodes
#!/bin/bash

# Colors
CYAN="\e[38;5;45m"
GREEN="\e[38;5;82m"
YELLOW="\e[38;5;220m"
BLUE="\e[38;5;51m"
RESET="\e[0m"

# Stats
LOAD=$(uptime | awk -F 'load average:' '{ print $2 }' | awk '{ print $1 }')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_PERC=$((MEM_USED * 100 / MEM_TOTAL))
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_PERC=$(df -h / | awk 'NR==2 {print $5}')
PROC=$(ps aux | wc -l)
USERS=$(who | wc -l)
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p | sed 's/up //')

# Header + Logo
echo -e "${CYAN}┌──────────────────────────────────────────────────────────────┐"
echo -e "│  _    _           _           _   _           _              │"
echo -e "│ | |  | |         (_)         | \\ | |         | |             │"
echo -e "│ | |  | |  _ __    _  __  __  |  \\| | ___   __| | ___  ___    │"
echo -e "│ | |  | | | '_ \\  | | \\ \\/ /  | . \` |/ _ \\ / _\` |/ _ \\/ __|   │"
echo -e "│ | |__| | | | | | | |  >  <   | |\\  | (_) | (_| |  __/\\__ \\   │"
echo -e "│  \\____/  |_| |_| |_| /_/\\_\\  |_| \\_|\\___/ \\__,_|\\___||___/   │"
echo -e "└──────────────────────────────────────────────────────────────┘${RESET}"

echo -e "${GREEN} Welcome to UnixNodes Datacenter! 🚀 ${RESET}\n"

# System Stats Table
echo -e "${BLUE}📊 System Information:${RESET} (as of $(date))\n"
printf "  ${YELLOW}CPU Load     :${RESET} %s\n" "$LOAD"
printf "  ${YELLOW}Memory Usage :${RESET} %sMB / %sMB (%s%%)\n" "$MEM_USED" "$MEM_TOTAL" "$MEM_PERC"
printf "  ${YELLOW}Disk Usage   :${RESET} %s / %s (%s)\n" "$DISK_USED" "$DISK_TOTAL" "$DISK_PERC"
printf "  ${YELLOW}Processes    :${RESET} %s\n" "$PROC"
printf "  ${YELLOW}Users Logged :${RESET} %s\n" "$USERS"
printf "  ${YELLOW}IP Address   :${RESET} %s\n" "$IP"
printf "  ${YELLOW}Uptime       :${RESET} %s\n\n" "$UPTIME"

echo -e "${CYAN}Need help? Support is always available: support@unixnodes.xyz${RESET}"
echo -e "Website: ${BLUE}unixnodes.xyz${RESET}"
echo -e "${GREEN}Quality Wise — No Compromise 😄${RESET}"
EOF

chmod +x /etc/update-motd.d/00-unixnodes

echo "🎉 UnixNodes MOTD Installed Successfully!"
echo "➡ Reconnect SSH to see the new MOTD."
