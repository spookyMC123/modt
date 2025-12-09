#!/bin/bash
# ===========================================
#   NexoHost – Secure SSH + Custom MOTD
# ===========================================
clear
echo -e "\033[1;36m🔐 NexoHost - Secure SSH Configuration\033[0m"
echo -e "\033[1;37m-------------------------------------------\033[0m"
sleep 1
echo -e "\033[1;34m▶ Applying SSH security settings...\033[0m"
sudo bash -c 'cat <<EOF > /etc/ssh/sshd_config
# === SSH LOGIN SETTINGS ===
PasswordAuthentication yes
PermitRootLogin yes
PubkeyAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
# === SECURITY IMPROVEMENTS ===
X11Forwarding no
AllowTcpForwarding yes
# === SFTP SETTINGS ===
Subsystem sftp /usr/lib/openssh/sftp-server
EOF'
echo -e "\033[1;32m✔ SSH security settings updated!\033[0m"
echo -e "\033[1;34m▶ Restarting SSH service...\033[0m"
sudo systemctl restart ssh || sudo service ssh restart
echo -e "\033[1;32m✔ SSH restarted successfully!\033[0m"
sleep 1
clear
# ===========================================
#   NexoHost CUSTOM MOTD (Blue Themed)
# ===========================================
echo -e "\033[1;34m▶ Installing NexoHost Custom MOTD...\033[0m"
sudo bash -c 'cat << "EOF" > /etc/motd
[1;34m███╗   ██╗███████╗██╗  ██╗ ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗[0m
[1;36m████╗  ██║██╔════╝╚██╗██╔╝██╔═══██╗██║  ██║██╔═══██╗██╔════╝╚══██╔══╝[0m
[1;34m██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████║██║   ██║███████╗   ██║   [0m
[1;36m██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██╔══██║██║   ██║╚════██║   ██║   [0m
[1;34m██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║  ██║╚██████╔╝███████║   ██║   [0m
[1;36m╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   [0m
[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m
   🌐 Welcome to NexoHost Datacenter
[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m
   🖥  Hostname : $(hostname)
   🚀 Uptime    : $(uptime -p)
   💾 Memory    : $(free -h | awk '/Mem:/ {print $3" / "$2}')
   🧵 CPU Cores : $(nproc)
[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m
        🌐 Thank you for using NexoHost VPS!
         https://nexohost.com
[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[0m
EOF'
echo -e "\033[1;32m✔ NexoHost MOTD installed!\033[0m"
sleep 1
clear
# ===========================================
#   FINAL SCREEN
# ===========================================
cat << "EOF"
 _   _                     _   _                  _   
| \ | |                   | | | |                | |  
|  \| |  ___  __  __ ___  | |_| |  ___   ___  __| |_ 
| . ` | / _ \ \ \/ // _ \ |  _  | / _ \ / __|/ _` __|
| |\  ||  __/  >  <| (_) || | | || (_) |\__ \ |_| |_ 
|_| \_| \___| /_/\_\\___/ |_| |_| \___/ |___/\__,_\__|
EOF
echo -e "\033[1;32m🎉 SSH Configuration Completed Successfully!\033[0m"
echo -e "\033[1;37m📌 NexoHost VPS setup completed.\033[0m"
echo -e "\n\033[1;33m🔑 Please set your ROOT password below 👇\033[0m"
sudo passwd root
echo -e "\n\033[1;36m✨ All done! Enjoy your NexoHost server! 🚀\033[0m"
