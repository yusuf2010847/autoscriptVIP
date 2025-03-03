#!/bin/bash
bij#!/bin/bash

# Mendapatkan tanggal dari server
biji=$(date +"%Y-%m-%d" -d "$dateFromServer")

# Mengambil IP VPS dengan metode alternatif
MYIP=$(curl -s https://api.ipify.org || curl -s https://checkip.amazonaws.com || curl -s https://icanhazip.com)

# Cek apakah MYIP berhasil diambil
if [[ -z "$MYIP" ]]; then
    echo -e "\033[0;31mGagal mendapatkan IP VPS!\033[0m"
    exit 1
fi

echo -e "\033[0;32mIP VPS: $MYIP\033[0m"

# Mengatur warna
colornow=$(cat /etc/rmbl/theme/color.conf)
export NC="\e[0m"
export yl='\033[0;33m'
export RED="\033[0;31m"
export COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2 | sed 's/ //g')"
export COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2 | sed 's/ //g')"
export WH='\033[1;37m'

# Mengambil informasi sistem
tram=$(free -h | awk 'NR==2 {print $2}')
uram=$(free -h | awk 'NR==2 {print $3}')
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
author=$(cat /etc/profil)
DATE2=$(date -R | cut -d " " -f -5)

# Sumber data izin
data_ip="https://raw.githubusercontent.com/yusuf2010847/permission/main/ip"

# Mengambil data izin berdasarkan IP
Exp2=$(curl -sS "$data_ip" | grep -w "$MYIP" | awk '{print $3}')

# Cek apakah Exp2 ditemukan
if [[ -z "$Exp2" ]]; then
    echo -e "\033[0;31mIP tidak ditemukan dalam daftar izin!\033[0m"
    exit 1
fi

echo -e "\033[0;32mExp2: $Exp2\033[0m"

# Mendapatkan tanggal server dari Google
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")

echo -e "\033[0;32mTanggal Server: $date_list\033[0m"

# Fungsi untuk mengecek dan melakukan pembaruan otomatis
function check_and_update() {
    # Mendapatkan commit terbaru dari repository GitHub
    latest_commit=$(curl -s https://api.github.com/repos/RyyStore/autoscriptVIP/commits/main | grep -oP '"sha": "\K[^"]+')
    commit_messages=$(curl -s https://api.github.com/repos/RyyStore/autoscriptVIP/commits/main | grep -oP '"message": "\K[^"]+')

    # Mendapatkan commit terakhir yang disimpan di VPS
    if [ -f /etc/github/last_commit ]; then
        last_commit=$(cat /etc/github/last_commit | awk '{print $1}')
        last_update_time=$(cat /etc/github/last_commit | awk '{print $2, $3}')
    else
        last_commit=""
        last_update_time="Never"
    fi

    # Jika ada pembaruan, tampilkan notifikasi dan tanyakan apakah ingin melakukan update
    if [ "$latest_commit" != "$last_commit" ]; then
        # Tampilkan notifikasi
        echo -e "╭═════════════════════════════════════════════════════════╮"
        echo -e "│ • UPDATE SCRIPT AVAILABLE •                             │"
        echo -e "│ Repository: RyyStore/autoscriptVIP                    │"
        echo -e "│ Latest Changes:                                         │"
        
        # Menampilkan daftar perubahan (commit messages)
        IFS=$'\n'  # Mengubah pemisah field menjadi newline
        count=1
        for message in $commit_messages; do
            echo -e "│ $count. $message"
            count=$((count + 1))
        done

        echo -e "╰═════════════════════════════════════════════════════════╯"

        # Tampilkan informasi update terakhir
        echo -e "Last update: $last_update_time"

        # Tanyakan kepada pengguna apakah ingin melakukan update
        read -p "Do you want to update the script? (Y/N): " update_choice
        if [[ "$update_choice" == "Y" || "$update_choice" == "y" ]]; then
            echo "Updating script..."

            # Download dan jalankan script update
            wget -q https://raw.githubusercontent.com/yusuf2010847/autoscriptVIP/main/m-update.sh -O m-update.sh
            chmod +x m-update.sh
            ./m-update.sh

            # Simpan commit terbaru dan timestamp ke file
            update_time=$(date +"%Y-%m-%d %H:%M:%S")
            echo "$latest_commit $update_time" > /etc/github/last_commit
            echo "Update completed on $update_time."
        else
            echo "Update skipped."
        fi
    fi
}

# Fungsi untuk menjalankan pengecekan update setiap 1 menit
function auto_check_update() {
    while true; do
        check_and_update
        sleep 60  # Tunggu 1 menit sebelum pengecekan berikutnya
    done
}

# Cek apakah tmux atau screen sudah terinstall
if ! command -v tmux &> /dev/null && ! command -v screen &> /dev/null; then
    echo "tmux atau screen tidak ditemukan. Menginstall tmux..."
    apt-get update && apt-get install -y tmux
fi

# Jalankan pengecekan update dalam sesi tmux
if command -v tmux &> /dev/null; then
    tmux new-session -d -s update_checker "bash -c 'auto_check_update'"
elif command -v screen &> /dev/null; then
    screen -dmS update_checker bash -c 'auto_check_update'
else
    echo "Tidak dapat menjalankan pengecekan update di latar belakang. Pastikan tmux atau screen terinstall."
fi
checking_sc() {
useexp=$(curl -sS $data_ip | grep $MYIP | awk '{print $3}')
if [[ $date_list < $useexp ]]; then
echo -ne
else
systemctl stop nginx
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│${NC}${COLBG1}          ${WH}• AUTOSCRIPT PREMIUM •                 ${NC}$COLOR1│ $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│            ${RED}PERMISSION DENIED !${NC}                  $COLOR1│"
echo -e "$COLOR1│   ${yl}Your VPS${NC} $MYIP \033[0;36mHas been Banned ${NC}      $COLOR1│"
echo -e "$COLOR1│     ${yl}Buy access permissions for scripts${NC}          $COLOR1│"
echo -e "$COLOR1│             \033[0;32mContact Your Admin ${NC}                 $COLOR1│"
echo -e "$COLOR1╰═════════════════════════════════════════════════╯${NC}"
key
fi
}
clear
checking_sc
cd
if [ ! -e /etc/per/id ]; then
mkdir -p /etc/per
echo "" > /etc/per/id
echo "" > /etc/per/token
elif [ ! -e /etc/perlogin/id ]; then
mkdir -p /etc/perlogin
echo "" > /etc/perlogin/id
echo "" > /etc/perlogin/token
elif [ ! -e /usr/bin/id ]; then
echo "" > /usr/bin/idchat
echo "" > /usr/bin/token
fi
if [ ! -e /etc/xray/ssh ]; then
echo "" > /etc/xray/ssh
elif [ ! -e /etc/xray/sshx ]; then
mkdir -p /etc/xray/sshx
elif [ ! -e /etc/xray/sshx/listlock ]; then
echo "" > /etc/xray/sshx/listlock
elif [ ! -e /etc/vmess ]; then
mkdir -p /etc/vmess
elif [ ! -e /etc/vmess/listlock ]; then
echo "" > /etc/vmess/listlock
elif [ ! -e /etc/vless ]; then
mkdir -p /etc/vless
elif [ ! -e /etc/vless/listlock ]; then
echo "" > /etc/vless/listlock
elif [ ! -e /etc/trojan ]; then
mkdir -p /etc/trojan
elif [ ! -e /etc/trojan/listlock ]; then
echo "" > /etc/trojan/listlock
elif [ ! -e /etc/xray/noob ]; then
echo "" > /etc/xray/noob
elif [ ! -e /etc/trojan-go/trgo ]; then
echo "" > /etc/trojan-go/trgo
fi
clear
MODEL2=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
vnstat_profile=$(vnstat | sed -n '3p' | awk '{print $1}' | grep -o '[^:]*')
vnstat -i ${vnstat_profile} >/etc/t1
bulan=$(date +%b)
tahun=$(date +%y)
ba=$(curl -s https://pastebin.com/raw/0gWiX6hE)
today=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
todayd=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
today_v=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $9}')
today_rx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $2}')
today_rxv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $3}')
today_tx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $5}')
today_txv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $6}')
if [ "$(grep -wc ${bulan} /etc/t1)" != '0' ]; then
bulan=$(date +%b)
month=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $9}')
month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $10}')
month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $3}')
month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $4}')
month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $6}')
month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan $ba$tahun" | awk '{print $7}')
else
bulan2=$(date +%Y-%m)
month=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $8}')
month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $9}')
month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $2}')
month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $3}')
month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $5}')
month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan2 " | awk '{print $6}')
fi
if [ "$(grep -wc yesterday /etc/t1)" != '0' ]; then
yesterday=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $8}')
yesterday_v=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $9}')
yesterday_rx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $2}')
yesterday_rxv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $3}')
yesterday_tx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $5}')
yesterday_txv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $6}')
else
yesterday=NULL
yesterday_v=NULL
yesterday_rx=NULL
yesterday_rxv=NULL
yesterday_tx=NULL
yesterday_txv=NULL
fi
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
status_ws="${COLOR1}ON${NC}"
else
status_ws="${RED}OFF${NC}"
fi
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
status_nginx="${COLOR1}ON${NC}"
else
status_nginx="${RED}OFF${NC}"
systemctl start nginx
fi
if [[ -e /usr/bin/kyt ]]; then
nginx=$( systemctl status kyt | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
echo -ne
else
systemctl start kyt
fi
fi
rm -rf /etc/status
xray=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $xray == "running" ]]; then
status_xray="${COLOR1}ON${NC}"
else
status_xray="${RED}OFF${NC}"
fi

stat_noobz=$( systemctl status noobzvpns | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $stat_noobz == "running" ]]; then
    stat_noobz="${COLOR1}ON${NC}"
else
    stat_noobz="${RED}OFF${NC}"
    systemctl start noobzvpns
fi

# // Dropbear
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $dropbear_status == "running" ]]; then
   status_beruangjatuh="${COLOR1}ON${NC}"
else
   status_beruangjatuh="${RED}OFF${NC}"
fi

udp_custom=$( systemctl status udp-custom | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $udp_custom == "running" ]]; then
    status_udp="${COLOR1}ON${NC}"
else
    status_udp="${RED}OFF${NC}"
    systemctl start udp-custom
fi

stat_trgo=$( systemctl status trojan-go | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $stat_trgo == "running" ]]; then
    stat_trgo="${COLOR1}ON${NC}"
else
    stat_trgo="${RED}OFF${NC}"
    systemctl start trojan-go
fi



# STATUS EXPIRED ACTIVE
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[4$below" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}(Registered)${Font_color_suffix}"
Error="${Green_font_prefix}${Font_color_suffix}${Red_font_prefix}[EXPIRED]${Font_color_suffix}"

today=$(date -d "0 days" +"%Y-%m-%d")
if [[ $today < $Exp2 ]]; then
    sts="${Info}"
else
    sts="${Error}"
fi
# TOTAL CREATE ACC VMESS
vmess=$(grep -c -E "^#vmg " "/etc/xray/config.json")
# TOTAL CREATE ACC VLESS
vless=$(grep -c -E "^#vlg " "/etc/xray/config.json")
# TOTAL CREATE ACC TROJAN
trtls=$(grep -c -E "^#trg " "/etc/xray/config.json")
# TOTAL CREATE ACC SSH
total_ssh=$(grep -c -E "^### " "/etc/xray/ssh")
# TOTAL CREATE ACC NOOBZ
jumlah_noobz=$(grep -c -E "^### " "/etc/xray/noob")
# TOTAL CREATE ACC TROJAN-GO
jumlah_trgo=$(grep -c -E "^### " "/etc/trojan-go/trgo")
function m-ip2(){
clear
cd
rm -rf /etc/github
if [[ -e /etc/github/api ]]; then
m-ip
else
mkdir /etc/github
echo "____" > /etc/github/api
echo "____" > /etc/github/email
echo "____" > /etc/github/username
m-ip
fi
}
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
function m-bot2(){
clear
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1  ${WH}Please select a Bot type below                 ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1  [ 1 ] ${WH}Buat/Edit BOT INFO Multi Login SSH, XRAY & TRANSAKSI   ${NC}"
echo -e "$COLOR1  [ 2 ] ${WH}Buat/Edit BOT INFO Create User & Lain Lain    ${NC}"
echo -e ""
echo -e "$COLOR1  [ 3 ] ${WH}Buat/Edit BOT INFO Backup Telegram    ${NC}"
echo -e "$COLOR1╰══════════════════════════════════════════╯${NC}"
read -p "   Please select numbers 1-3 or Any Button(Random) to exit : " bot
echo ""
if [[ $bot == "1" ]]; then
clear
rm -rf /etc/perlogin
mkdir -p /etc/perlogin
cd /etc/perlogin
touch token
touch id
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Multi Login"
read -rp "Enter Token (Creat on @BotFather) : " -e token2
echo "$token2" > token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idat
echo "$idat" > id
sleep 1
m-bot2
fi
if [[ $bot == "2" ]]; then
clear
rm -rf /etc/per
mkdir -p /etc/per
cd /etc/per
touch token
touch id
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Akun Dan Lain Lain"
read -rp "Enter Token (Creat on @BotFather) : " -e token3
echo "$token3" > token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idat2
echo "$idat2" > id
sleep 1
m-bot2
fi
if [[ $bot == "3" ]]; then
clear
rm -rf /usr/bin/token
rm -rf /usr/bin/idchat
echo -e ""
echo -e "$COLOR1 [ INFO ] ${WH}Create for database Backup Telegram"
read -rp "Enter Token (Creat on @BotFather) : " -e token23
echo "$token23" > /usr/bin/token
read -rp "Enter Your Id (Creat on @userinfobot)  : " -e idchat
echo "$idchat" > /usr/bin/idchat
sleep 1
m-bot2
fi
menu
}
clear
clear && clear && clear
clear;clear;clear
echo -e " $COLOR1╭══════════════════════════════════════════════════════════╮${NC}"
echo -e " $COLOR1│${NC} ${COLBG1}               ${WH} •  RYYSTORE  PREMIUM •             ${NC} $COLOR1│ $NC"
echo -e " $COLOR1╰══════════════════════════════════════════════════════════╯${NC}"
echo -e " $COLOR1╭══════════════════════════════════════════════════════════╮${NC}"
echo -e " $COLOR1│$NC${WH} ❈ OS            ${COLOR1}: ${WH}$MODEL2${NC}"
echo -e " $COLOR1│$NC${WH} ❈ RAM           ${COLOR1}: ${WH}$tram / $uram MB${NC}"
echo -e " $COLOR1│$NC${WH} ❈ DATE          ${COLOR1}: ${WH}$DATE2 WIB${NC}"
echo -e " $COLOR1│$NC${WH} ❈ UPTIME        ${COLOR1}: ${WH}$uphours $upminutes $uptimecek"
echo -e " $COLOR1│$NC${WH} ❈ ISP           ${COLOR1}: ${WH}$ISP${NC}"
echo -e " $COLOR1│$NC${WH} ❈ City          ${COLOR1}: ${WH}$CITY${NC}"
echo -e " $COLOR1│$NC${WH} ❈ IP VPS        ${COLOR1}: ${WH}$MYIP${NC}"
echo -e " $COLOR1│$NC${WH} ❈ DOMAIN        ${COLOR1}: ${WH}$(cat /etc/xray/domain)"
echo -e " $COLOR1│$NC${WH} ❈ NSDomain      ${COLOR1}: ${WH}$(cat /etc/xray/dns)"
echo -e " $COLOR1╰══════════════════════════════════════════════════════════╯${NC}"
echo -e "    $COLOR1╭═════════════════ • ${NC}${WH}STATUS SERVER${NC}${COLOR1} • ═══════════════╮${NC}"
echo -e "     ${WH} SSH WS : ${status_ws} ${WH} XRAY : ${status_xray} ${WH} NGINX : ${status_nginx} ${WH} DROPBEAR : ${status_beruangjatuh}$NC"
echo -e "      ${WH} UDP CUSTOM : ${status_udp} ${WH} NOOBZVPNS : ${stat_noobz} ${WH} TROJAN-GO : ${stat_trgo} ${NC}"
echo -e "    $COLOR1╰═══════════════════════════════════════════════════╯${NC}"
echo -e "       $COLOR1╭════════════ •${NC} ${WH}ACCOUNT PREMIUM${NC} $COLOR1• ════════════╮${NC}"
printf "                \033[1;37m%-16s ${COLOR1}%-4s${NC} ${WH}%-5s\e[0m\n" " SSH/OPVPN   =" "$total_ssh" "ACCOUNT "
printf "                \033[1;37m%-16s ${COLOR1}%-4s${NC} ${WH}%-5s\e[0m\n" " VMESS/WS    =" "$vmess" "ACCOUNT "
printf "                \033[1;37m%-16s ${COLOR1}%-4s${NC} ${WH}%-5s\e[0m\n" " VLESS/WS    =" "$vless" "ACCOUNT "
printf "                \033[1;37m%-16s ${COLOR1}%-4s${NC} ${WH}%-5s\e[0m\n" " TROJAN/GRPC =" "$trtls" "ACCOUNT "
printf "                \033[1;37m%-16s ${COLOR1}%-4s${NC} ${WH}%-5s\e[0m\n" " NOOBZVPNS   =" "$jumlah_noobz" "ACCOUNT "
printf "                \033[1;37m%-16s ${COLOR1}%-4s${NC} ${WH}%-5s\e[0m\n" " TROJAN-GO   =" "$jumlah_trgo" "ACCOUNT "
echo -e "      $COLOR1╰═════════════════════════════════════════════╯${NC}"
echo -e " $COLOR1╭═════════════════════ • ${WH}LIST MENU${NC}${COLOR1} • ════════════════════╮${NC}"
echo -e " $COLOR1│$NC ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}SSH-WS    ${WH}[${COLOR1}Menu${WH}]   ${NC} $COLOR1│${NC}  ${WH}[${COLOR1}07${WH}]${NC} ${COLOR1}• ${WH}BOT PANEL  ${WH}[${COLOR1}Menu${WH}] $COLOR1│${NC}"
echo -e " $COLOR1│$NC ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}VMESS     ${WH}[${COLOR1}Menu${WH}]   ${NC} $COLOR1│${NC}  ${WH}[${COLOR1}08${WH}]${NC} ${COLOR1}• ${WH}BOT NOTIF  ${WH}[${COLOR1}Menu${WH}] $COLOR1│${NC}"    
echo -e " $COLOR1│$NC ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}VLESS     ${WH}[${COLOR1}Menu${WH}]   ${NC} $COLOR1│${NC}  ${WH}[${COLOR1}09${WH}]${NC} ${COLOR1}• ${WH}UPDATE     ${WH}[${COLOR1}Menu${WH}] $COLOR1│${NC}"   
echo -e " $COLOR1│$NC ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}TROJAN    ${WH}[${COLOR1}Menu${WH}]   ${NC} $COLOR1│${NC}  ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1}• ${WH}SYSTEM     ${WH}[${COLOR1}Menu${WH}] $COLOR1│${NC}" 
echo -e " $COLOR1│$NC ${WH}[${COLOR1}05${WH}]${NC} ${COLOR1}• ${WH}NOOBZVPNS ${WH}[${COLOR1}Menu${WH}]   ${NC} $COLOR1│${NC}  ${WH}[${COLOR1}11${WH}]${NC} ${COLOR1}• ${WH}BACKUP     ${WH}[${COLOR1}Menu${WH}] $COLOR1│${NC}" 
echo -e " $COLOR1│$NC ${WH}[${COLOR1}06${WH}]${NC} ${COLOR1}• ${WH}TROJAN-GO ${WH}[${COLOR1}Menu${WH}]   ${NC} $COLOR1│${NC}  ${WH}[${COLOR1}12${WH}]${NC} ${COLOR1}• ${WH}REBOOT     ${WH}[${COLOR1}Menu${WH}] $COLOR1│${NC}" 
echo -e " $COLOR1│$NC ${WH}[${COLOR1}22${WH}]${NC} ${COLOR1}• ${WH}RUNNING   ${WH}[${COLOR1}Menu${WH}]   ${NC} $COLOR1│${NC}  ${WH}[${COLOR1}23${WH}]${NC} ${COLOR1}• ${WH}RESTART    ${WH}[${COLOR1}Menu${WH}] $COLOR1│${NC}"
echo -e " $COLOR1╰════════════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭════════════════════ • ${WH}PANEL ADMIN VIP${NC}${COLOR1} • ════════════════╮${NC}"
echo -e "$COLOR1│  ${WH}[${COLOR1}13${WH}]${NC} ${COLOR1}• ${WH}RESELLER IP ${WH}[${COLOR1}MENU${WH}] $NC"
echo -e "$COLOR1╰═════════════════════════════════════════════════════════╯${NC}"
echo -e "$COLOR1╭═════════════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│$NC  ${WH}Total    $COLOR1│${NC}     ${WH}Today       ${WH}Yesterday       ${WH}Month         ${NC}"
echo -e "$COLOR1│$NC ${WH}Bantwidth $COLOR1│${NC}   ${WH}$today_tx $today_txv     ${WH}$yesterday_tx $yesterday_txv      ${WH}$month_tx $month_txv${NC}"
echo -e "$COLOR1╰═════════════════════════════════════════════════════════╯${NC}"
DATE=$(date +'%Y-%m-%d')
datediff() {
d1=$(date -d "$1" +%s)
d2=$(date -d "$2" +%s)
echo -e "$COLOR1 $NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
function new(){
cat> /etc/cron.d/autocpu << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/3 * * * * root /usr/bin/autocpu
END
echo "Auto-Reboot CPU 100% TURN ON."
sleep 1
menu
}
d1=$(date -d "$Exp2" +%s)
d2=$(date -d "$today" +%s)
certificate=$(( (d1 - d2) / 86400 ))
function restartservice(){    
clear
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}
res1() {
    systemctl restart nginx
    systemctl restart trojan-go
    systemctl restart xray
    systemctl restart noobzvpns
    systemctl restart daemon
    systemctl restart udp-custom
    systemctl restart ws-dropbear
    systemctl restart ws-stunnel
    systemctl restart openvpn
    systemctl restart cron
    systemctl restart netfilter-persistent
    systemctl restart squid
    systemctl restart badvpn1
    systemctl restart badvpn2
    systemctl restart badvpn3
    systemctl restart client
    systemctl restart server
}
clear
echo -e "$COLOR1 ╭══════════════════════════════════════════╮${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}          ${WH}RESTART SERVICE VPS             ${NC} $NC"
echo -e "$COLOR1 ╰══════════════════════════════════════════╯${NC}"
echo -e ""
echo -e "  \033[1;91m Restart All Service... \033[1;37m"
fun_bar 'res1'

echo -e ""
read -n 1 -s -r -p "Press [ Enter ] to back on menu"
menu
}
function updatews(){
cd
rm -rf *
wget https://raw.githubusercontent.com/yusuf2010847/autoscriptVIP/main/m-update.sh
clear
chmod +x m-update.sh && ./m-update.sh
}
echo -e "$COLOR1╭═════════════════════════════════════════════════════════╮${NC}"
echo -e "$COLOR1│$NC ${WH} ❈ Versi   ${NC}: ${WH}$(cat /opt/.ver) Version${NC}"
echo -e "$COLOR1│$NC ${WH} ❈ Client ${NC} : ${WH}$author${NC}"
echo -e "$COLOR1│$NC ${WH} ❈ Durasi ${NC} : ${WH}$certificate hari${NC}"
echo -e "$COLOR1│$NC ${WH} ❈ Expiry ${NC} : ${WH}$Exp2 $sts ${NC}"
echo -e "$COLOR1╰═════════════════════════════════════════════════════════╯${NC}"
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
case $opt in
01 | 1) clear ; m-sshovpn ;;
02 | 2) clear ; m-vmess ;;
03 | 3) clear ; m-vless ;;
04 | 4) clear ; m-trojan ;;
05 | 5) clear ; m-noobz ;;
06 | 6) clear ; m-trgo ;;
07 | 7) clear ; m-bot  ;;
08 | 8) clear ; m-bot2 ;;
09 | 9) clear ; updatews ;;
10 | 10) clear ; m-system ;;
11 | 11) clear ; m-backup;;
12 | 12) clear ; reboot ;;
13 | 13) clear ; m-ip2 ;;
22 | 22) clear ; running;;
23 | 23) clear ; restartservice ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
