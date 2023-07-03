#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

MYIP=$(curl -sS ipv4.icanhazip.com)  
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m' 
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
mkdir -p /etc/xray

echo -e "[ ${tyblue}NOTES${NC} ] Before we go.. "
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] I need check your headers first.."
sleep 2
echo -e "[ ${green}INFO${NC} ] Checking headers"
sleep 1
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 2
  echo -e "[ ${yell}WARNING${NC} ] Try to install ...."
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] If error you need.. to do this"
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 1. apt update -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 2. apt upgrade -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 3. apt dist-upgrade -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 4. reboot"
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] After rebooting"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] Then run this script again"
  echo -e "[ ${tyblue}NOTES${NC} ] Notes, Script By : DIGITAL-NET"
  echo -e "[ ${tyblue}NOTES${NC} ] if you understand then tap enter now.."
  read
else
  echo -e "[ ${green}INFO${NC} ] Oke installed"
fi

ttet=`uname -r`
ReqPKG="linux-headers-$ttet"
if ! dpkg -s $ReqPKG  >/dev/null 2>&1; then
  rm /root/setup.sh >/dev/null 2>&1 
  exit
else
  clear
fi


secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END
chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Allright good ... installation file is ready"
sleep 3

mkdir -p /etc/ssnvpn
mkdir -p /etc/ssnvpn/theme
mkdir -p /var/lib/ssnvpn-pro >/dev/null 2>&1
echo "IP=" >> /var/lib/ssnvpn-pro/ipvps.conf

if [ -f "/etc/xray/domain" ]; then
echo ""
echo -e "[ ${green}INFO${NC} ] Script Already Installed"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to install again ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
rm setup.sh
sleep 10
exit 0
else
clear
fi
fi

echo ""
wget -q https://raw.githubusercontent.com/toniakbar/multiws/main/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
rm dependencies.sh
clear

yellow "Add Domain for vmess/vless/trojan dll"
echo -e "\e[32m┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "\e[32m            ❇ \e[34mD\033[0m \e[32mI\033[0m \e[33mG\033[0m \e[31mI\033[0m \e[32mT\033[0m \e[35mA\033[0m \e[36mL\033[0m \e[37m-\033[0m \e[34mN\033[0m \e[33mE\033[0m \e[31mT\033[0m \e[32m❇              \033[0m"
echo -e "\e[32m└─────────────────────────────────────────────────┘${NC}" 
read -rp "Input your domain : " -e pp
echo "$pp" > /root/domain
echo "$pp" > /root/scdomain
echo "$pp" > /etc/xray/domain
echo "$pp" > /etc/xray/scdomain
echo "IP=$pp" > /var/lib/ssnvpn-pro/ipvps.conf

#THEME RED
cat <<EOF>> /etc/ssnvpn/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
#THEME BLUE
cat <<EOF>> /etc/ssnvpn/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
#THEME GREEN
cat <<EOF>> /etc/ssnvpn/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
#THEME YELLOW
cat <<EOF>> /etc/ssnvpn/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME MAGENTA
cat <<EOF>> /etc/ssnvpn/theme/magenta
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME CYAN
cat <<EOF>> /etc/ssnvpn/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
#THEME CONFIG
cat <<EOF>> /etc/ssnvpn/theme/color.conf
blue
EOF
    
#install ssh ovpn
echo -e "$green[INFO]$NC Install SSH"
sleep 2
clear
wget https://raw.githubusercontent.com/toniakbar/multiws/main/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#Instal Xray
echo -e "$green[INFO]$NC Install Install XRAY!"
sleep 2
clear
wget https://raw.githubusercontent.com/toniakbar/multiws/main/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
clear
wget https://raw.githubusercontent.com/toniakbar/multiws/main/websocket/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
wget https://raw.githubusercontent.com/toniakbar/multiws/main/websocket/nontls.sh && chmod +x nontls.sh && ./nontls.sh
clear
wget https://raw.githubusercontent.com/toniakbar/multiws/main/slowdnss/install-sldns.sh && chmod +x install-sldns.sh && ./install-sldns.sh
clear
echo -e "$green[INFO]$NC Download Extra Menu"
sleep 2
wget https://raw.githubusercontent.com/toniakbar/multiws/main/update/update.sh && chmod +x update.sh && ./update.sh
clear
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/toniakbar/permission/main/version  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ifconfig.me > /etc/myipvps

echo " "
echo -e "\e[32m┌─────────────────────────────────────────────────┐${NC}"
echo -e "\e[32m│${NC}         C\033[0m \e[31mE\033[0m \e[33mL\033[0m \e[34mL\033[0m \e[35mU\033[0m \e[36mL\033[0m \e[32mA\033[0m \e[31mR\033[0m   \e[33mF\033[0m \e[34mR\033[0m \e[35mE\033[0m \e[36mE\033[0m \e[32mD\033[0m O\033[0m \e[32mM\033[0m${NC}         \e[32m│$NC"
echo -e "\e[32m└─────────────────────────────────────────────────┘${NC}"
echo ""
echo ""
echo -e "\e[32m>>> ${NC}Service & Port"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m OpenSSH                 \e[31m:\033[0m 22"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m SSH Websocket           \e[31m:\033[0m 80 [OFF]" | tee -a log-install.txt
echo -e "\e[31m•\033[0m SSH SSL Websocket       \e[31m:\033[0m 443" | tee -a log-install.txt
echo -e "\e[31m•\033[0m SSH NON-SSL Websocket   \e[31m:\033[0m 8880" | tee -a log-install.txt
echo -e "\e[31m•\033[0m SLOWDNS                 \e[31m:\033[0m 5300" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Stunnel4                \e[31m:\033[0m 447, 777" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Dropbear                \e[31m:\033[0m 109, 143" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Badvpn                  \e[31m:\033[0m 7100-7900" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Nginx                   \e[31m:\033[0m 81" | tee -a log-install.txt
echo -e "\e[31m•\033[0m XRAY  Vmess TLS         \e[31m:\033[0m 443" | tee -a log-install.txt
echo -e "\e[31m•\033[0m XRAY  Vmess None TLS    \e[31m:\033[0m 80" | tee -a log-install.txt
echo -e "\e[31m•\033[0m XRAY  Vless TLS         \e[31m:\033[0m 443" | tee -a log-install.txt
echo -e "\e[31m•\033[0m XRAY  Vless None TLS    \e[31m:\033[0m 80" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Trojan GRPC             \e[31m:\033[0m 443" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Trojan WS               \e[31m:\033[0m 443" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Sodosok WS/GRPC         \e[31m:\033[0m 443" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo -e "\e[32m>>> ${NC}Server Information & Other Features"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m Timezone                \e[31m:\033[0m Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m Fail2Ban                \e[31m:\033[0m [ON]"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m Dflate                  \e[31m:\033[0m [ON]"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m IPtables                \e[31m:\033[0m [ON]"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m Auto-Reboot             \e[31m:\033[0m [ON]"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m IPv6                    \e[31m:\033[0m [OFF]"  | tee -a log-install.txt
echo -e "\e[31m•\033[0m Autoreboot On           \e[31m:\033[0m $aureb:00 $gg GMT +7" | tee -a log-install.txt
echo -e "\e[31m•\033[0m AutoKill Multi Login User" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Auto Delete Expired Account" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Fully automatic script" | tee -a log-install.txt
echo -e "\e[31m•\033[0m VPS settings" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Admin Control" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Restore Data" | tee -a log-install.txt
echo -e "\e[31m•\033[0m Full Orders For Various Services" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo ""
echo -e "\e[32m┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "\e[32m            ❇ \e[34mD\033[0m \e[32mI\033[0m \e[33mG\033[0m \e[31mI\033[0m \e[32mT\033[0m \e[35mA\033[0m \e[36mL\033[0m \e[37m-\033[0m \e[34mN\033[0m \e[33mE\033[0m \e[31mT\033[0m \e[32m❇              \033[0m"
echo -e "\e[32m└─────────────────────────────────────────────────┘${NC}" 
echo -e ""
echo ""
echo ""
echo "" | tee -a log-install.txt
rm /root/cf.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/insshws.sh 
rm /root/update.sh
rm /root/nontls.sh
rm /root/install-sldns.sh
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e "
"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
