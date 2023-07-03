#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/ssnvpn/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m" 
export COLOR1="$(cat /etc/ssnvpn/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/ssnvpn/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"   
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
###########- END COLOR CODE -##########
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )


BURIQ () {
    curl -sS https://raw.githubusercontent.com/toniakbar/permission/main/ipmini > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/toniakbar/permission/main/ipmini | grep $MYIP | awk '{print $2}')
Isadmin=$(curl -sS https://raw.githubusercontent.com/toniakbar/permission/main/ipmini | grep $MYIP | awk '{print $5}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/toniakbar/permission/main/ipmini | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

x="ok"


PERMISSION

if [ "$res" = "Expired" ]; then
Exp="\e[36mExpired\033[0m"
rm -f /home/needupdate > /dev/null 2>&1
else
Exp=$(curl -sS https://raw.githubusercontent.com/toniakbar/permission/main/ipmini | grep $MYIP | awk '{print $3}')
fi
export RED='\033[0;31m'
export GREEN='\033[0;32m'

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${GREEN}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi

# // nginx
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# // SSH Websocket Proxy
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi

function add-host(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               • ADD VPS HOST •                ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
read -rp "  New Host Name : " -e host
echo ""
if [ -z $host ]; then
echo -e "  [INFO] Type Your Domain/sub domain"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
else
echo "IP=$host" > /var/lib/ssnvpn-pro/ipvps.conf
echo ""
echo "  [INFO] Dont forget to renew cert"
echo ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to Renew Cret"
crtxray
fi
}
function updatews(){
clear

echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • UPDATE SCRIPT VPS •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Check for Script updates"
sleep 2
wget -q -O /root/install_up.sh "https://raw.githubusercontent.com/toniakbar/update/main/install_up.sh" && chmod +x /root/install_up.sh
sleep 2
./install_up.sh
sleep 5
rm /root/install_up.sh
rm /opt/.ver
version_up=$( curl -sS https://raw.githubusercontent.com/toniakbar/update/main/version_up)
echo "$version_up" > /opt/.ver
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Successfully Up To Date!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "\e[32m            ❇ \e[34mD\033[0m \e[32mI\033[0m \e[33mG\033[0m \e[31mI\033[0m \e[32mT\033[0m \e[35mA\033[0m \e[36mL\033[0m \e[37m-\033[0m \e[34mN\033[0m \e[33mE\033[0m \e[31mT\033[0m \e[32m❇              \033[0m"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}
clear
clear && clear && clear
clear;clear;clear
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}ON${NC}"
else
ressh="${red}OFF${NC}"
fi
sshstunel=$(service stunnel4 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}ON${NC}"
else
resst="${red}OFF${NC}"
fi
sshws=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
ressshws="${green}ON${NC}"
else
ressshws="${red}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
resngx="${green}ON${NC}"
else
resngx="${red}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
resdbr="${green}ON${NC}"
else
resdbr="${red}OFF${NC}"
fi
v2r=$(service xray status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}ON${NC}"
else
resv2r="${red}OFF${NC}"
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}         C\033[0m \e[31mE\033[0m \e[33mL\033[0m \e[34mL\033[0m \e[35mU\033[0m \e[36mL\033[0m \e[32mA\033[0m \e[31mR\033[0m   \e[33mF\033[0m \e[34mR\033[0m \e[35mE\033[0m \e[36mE\033[0m \e[32mD\033[0m O\033[0m \e[32mM\033[0m${NC}         $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "\e[32m ❇\033[0m SSH ${NC}\e[31m:\033[0m $ressh""${BICyan}\e[32m ❇\033[0m NGINX ${NC}\e[31m:\033[0m $resngx""${BICyan}\e[32m ❇\033[0m XRAY ${NC}\e[31m:\033[0m $resv2r""${BICyan}\e[32m ❇\033[0m TROJAN ${NC}\e[31m:\033[0m $resv2r"
echo -e "$COLOR1 ─────────────────────────────────────────────────${NC}"
echo -e "\e[32m                  ❇  \e[31mV\033[0m\e[33mP\033[0m\e[34mS\033[0m \e[35mI\033[0m\e[36mN\033[0m\e[37mF\033[0m\e[31mO\033[0m \e[32m❇                  \033[0m"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )
serverV=$( curl -sS https://raw.githubusercontent.com/toniakbar/update/main/version_up)
if [ "$Isadmin" = "ON" ]; then
uis="${GREEN}Premium User$NC"
else
uis="${RED}Free Version$NC"
fi
echo -e "$COLOR1│$NC Operating System \e[31m:\033[0m "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
echo -e "$COLOR1│$NC Memory Usage     \e[31m:\033[0m $uram / $tram"
echo -e "$COLOR1│$NC ISP              \e[31m:\033[0m $ISP "
echo -e "$COLOR1│$NC City             \e[31m:\033[0m $CITY"
echo -e "$COLOR1│$NC Current Domain   \e[31m:\033[0m $(cat /etc/xray/domain)"
echo -e "$COLOR1│$NC IP-VPS           \e[31m:\033[0m ${COLOR1}$IPVPS${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "\e[32m                  ❇  \e[31mM\033[0m\e[33m-\033[0m\e[34mE\033[0m\e[35m-\033[0m\e[36mN\033[0m\e[37m-\033[0m\e[31mU\033[0m\e[32m ❇                   \033[0m"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "  ${COLOR1}[01]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] SSHWS     ${COLOR1}[07]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] THEME     $COLOR1│$NC"   
echo -e "  ${COLOR1}[02]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] VMESS     ${COLOR1}[08]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] SETTINGS  $COLOR1│$NC"  
echo -e "  ${COLOR1}[03]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] VLESS     ${COLOR1}[09]${NC} \e[31m•\033[0m INFORMATION      $COLOR1│$NC" 
echo -e "  ${COLOR1}[04]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] TROJAN    ${COLOR1}[10]${NC} \e[31m•\033[0m ADD HOST/DOMAIN  $COLOR1│$NC" 
echo -e "  ${COLOR1}[05]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] SS WS     ${COLOR1}[11]${NC} \e[31m•\033[0m RENEW CERT       $COLOR1│$NC"
echo -e "  ${COLOR1}[06]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] SET DNS                           $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
if [ "$Isadmin" = "ON" ]; then
echo -e "  ${COLOR1}[12]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] REG IP    ${COLOR1}[13]${NC} \e[31m•\033[0m [${YELLOW}Menu${NC}] SET BOT   $NC"
ressee="menu-ip"
bottt="menu-bot"
else
ressee="menu"
bottt="menu"
fi
echo -e "$COLOR1 ─────────────────────────────────────────────────${NC}"
myver="$(cat /opt/.ver)"

if [[ $serverV > $myver ]]; then
echo -e "$RED┌─────────────────────────────────────────────────┐${NC}"
echo -e "$RED│$NC ${COLOR1}[100]${NC} • UPDATE TO V$serverV" 
echo -e "$RED└─────────────────────────────────────────────────┘${NC}"
up2u="updatews"
else
up2u="menu"
fi

DATE=$(date +'%d %B %Y')
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo -e "$COLOR1│$NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""

echo -e "$COLOR1┌─────────────────────────────────────────────────┐$NC"
echo -e "$COLOR1│$NC Version     \e[31m:\033[0m${COLOR1} $(cat /opt/.ver) Latest Version${NC}"
echo -e "$COLOR1│$NC User Roles  \e[31m:\033[0m $uis"
echo -e "$COLOR1│$NC Client Name \e[31m:\033[0m $Name"
if [ $exp \> 1000 ];
then
    echo -e "$COLOR1│$NC License     \e[31m:\033[0m Lifetime"
else
    datediff "$Exp" "$DATE"
fi;
echo -e "$COLOR1└─────────────────────────────────────────────────┘$NC"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "\e[32m            ❇ \e[34mD\033[0m \e[32mI\033[0m \e[33mG\033[0m \e[31mI\033[0m \e[32mT\033[0m \e[35mA\033[0m \e[36mL\033[0m \e[37m-\033[0m \e[34mN\033[0m \e[33mE\033[0m \e[31mT\033[0m \e[32m❇              \033[0m"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e ""
echo -ne " Select menu : "; read opt
case $opt in
01 | 1) clear ; menu-ssh ;;
02 | 2) clear ; menu-vmess ;;
03 | 3) clear ; menu-vless ;;
04 | 4) clear ; menu-trojan ;;
05 | 5) clear ; menu-ss ;;
06 | 6) clear ; menu-dns ;;
07 | 7) clear ; menu-theme ;;
08 | 8) clear ; menu-set ;;
09 | 9) clear ; info ;;
10) clear ; add-host ;;
11) clear ; crtxray ;;
12) clear ; $ressee ;;
13) clear ; $bottt ;;
100) clear ; $up2u ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
