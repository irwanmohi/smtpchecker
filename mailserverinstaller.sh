#!/bin/bash
clear
UBUNTU_VERSION=$(lsb_release -rs)
UBUNTU_DETAIL=$(lsb_release -dcs)
HASIL_HOSTNAME=$(hostname -f)
WAKTU=$(date)
UBUNTU_VERSI=$(lsb_release -cs)
MERAH='\033[1;31m'
PUTIH='\033[0;37m'
KUNING='\033[1;33m'
NC='\033[0m'

printf "\033[1;31m _______         __ __      _______                              \e[0m\n"
printf "\033[1;31m|   |   |.---.-.|__|  |    |     __|.-----.----.--.--.-----.----.\e[0m\n"
printf "\033[1;31m|       ||  _  ||  |  |    |__     ||  -__|   _|  |  |  -__|   _|\e[0m\n"
printf "\033[1;31m|__|_|__||___._||__|__|    |_______||_____|__|  \___/|_____|__|  \e[0m\n"                                                                 
printf "\033[0;37m _______               __          __ __                         \e[0m\n"
printf "\033[0;37m|_     _|.-----.-----.|  |_.---.-.|  |  |.-----.----.            \e[0m\n"
printf "\033[0;37m _|   |_ |     |__ --||   _|  _  ||  |  ||  -__|   _|            \e[0m\n"
printf "\033[0;37m|_______||__|__|_____||____|___._||__|__||_____|__|         v1.5 \e[0m\n"
echo "Auto installer mail server basic from Mailcow modified by BangDen07."
echo ""
printf "\033[1;33mPERHATIAN${NC} ${MERAH}!!!\e[0m\n"
printf "\033[1;33mServer harus dalam keadaan fresh/baru.\e[0m\n"
printf "\033[1;33mUntuk menghentikan proses ini silahkan tekan tombol${NC} ${MERAH}'CTRL + C'.\e[0m\n"
echo ""
echo "Detail Image OS Anda:"
echo "Saat ini anda menggunakan :" $UBUNTU_DETAIL
echo ""

if [[ "${UBUNTU_VERSION}" != "18.04" && "${UBUNTU_VERSION}" != "20.04" ]]; then
        echo "Hanya berjalan di OS Ubuntu 18.04 atau 20.04" > /dev/stderr
        exit 1
fi

echo "Mempersiapkan dependensi..."
sleep 1
count=0
total=34
pstr="[=======================================================================>]"

while [ $count -lt $total ]; do
  sleep 0.5
  count=$(( $count + 1 ))
  pd=$(( $count * 73 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done
echo ""
if [ "$EUID" -ne 0 ]
  then printf "\033[1;31m Silahkan gunakan root\e[0m\n"
  exit
fi
echo ""
read -p "Apakah Anda ingin melanjutkannya? (y/n) " jawaban

if [ "$jawaban" = "y" ]; then
    echo "Proses akan dilanjutkan"
    sleep 1
elif [ "$jawaban" = "Y" ]; then
    echo "Proses akan dilanjutkan, tunggu sebentar..."
    sleep 1
else
  exit 1
fi

sudo sudo apt-get update && sudo apt-get upgrade -y
clear

echo ""
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
printf "\033[1;33m++          Install Docker dan Docker Compose          ++\e[0m\n"
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
echo ""
echo "Sedang mempersiapkan."
echo ""
sleep 0.5
count=0
total=34
pstr="[=======================================================================>]"

while [ $count -lt $total ]; do
  sleep 0.5
  count=$(( $count + 1 ))
  pd=$(( $count * 73 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done
echo ""
printf "\033[1;31mJangan keluar dari terminal! Proses instalasi sedang berlangsung...\e[0m\n"
sleep 0.5
sudo apt-get update &> /dev/null
sleep 0.5
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y &> /dev/null
sleep 0.5
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sleep 0.5
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sleep 0.5
sudo apt-get update &> /dev/null
sleep 0.5
sudo apt-get install docker-ce docker-ce-cli containerd.io -y &> /dev/null
sleep 0.5
sudo docker run hello-world
sleep 0.5
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sleep 0.5
sudo chmod +x /usr/local/bin/docker-compose
sleep 0.5
docker-compose --version
echo ""
echo "Docker dan Docker Compose berhasil diinstall."
sleep 6
clear

echo ""
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
printf "\033[1;33m++           Edit Hostname FQDN & Time Zone            ++\e[0m\n"
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
echo ""
echo "+-------------------------------------------+"
echo "|                   CONTOH                  |"
echo "+-------------------------------------------+"
echo "| Hosts    : mail.contoh.com                |"
echo "| Hostname : mail                           |"
echo "+-------------------------------------------+"
echo ""
echo "Sedang mempersiapkan."
echo ""
sleep 0.5
count=0
total=34
pstr="[=======================================================================>]"

while [ $count -lt $total ]; do
  sleep 0.5
  count=$(( $count + 1 ))
  pd=$(( $count * 73 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done
echo ""
echo ""
read -p "Hosts yang akan digunakan : " HOSTS
sleep 0.5
read -p "Hostname yang akan digunakan : " HOSTNAME
sleep 1
echo $HOSTNAME > /etc/hostname
sleep 1
echo 127.0.0.1 $HOSTS $HOSTNAME localhost localhost.localdomain >> /etc/hosts
sleep 1
echo 127.0.1.1 $HOSTS $HOSTNAME >> /etc/hosts
sleep 1
echo ""
echo "Hostname berhasil diganti dan digunakan saat ini : " $HASIL_HOSTNAME
sleep 3
echo ""
echo "+-------------------------------------------------------------+"
echo "| Time Zone default : $WAKTU                                  "
echo "+-------------------------------------------------------------+"
echo "Untuk waktu Negara Indonesia : Asia/Jakarta"
echo ""
echo "Pastikan penulisan zona waktu dengan benar!"
read -p "Masukan zona waktu negara Anda : " zona_waktu
sleep 0.5
sudo timedatectl set-timezone $zona_waktu
echo "+-------------------------------------------------------------+"
echo "| Time Zone saat ini : $zona_waktu                            "
echo "+-------------------------------------------------------------+"
sleep 6

clear
echo ""
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
printf "\033[1;33m++                  Install Mailcow                    ++\e[0m\n"
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
echo ""
echo "Sedang mempersiapkan."
echo ""
sleep 0.5
count=0
total=34
pstr="[=======================================================================>]"

while [ $count -lt $total ]; do
  sleep 0.5
  count=$(( $count + 1 ))
  pd=$(( $count * 73 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done
echo ""
printf "\033[1;31mJangan keluar dari terminal! Proses instalasi sedang berlangsung...\e[0m\n"
echo ""
echo ""
printf "\033[1;33m Input dengan hostname (FQDN): $HOSTS \e[0m\n"
printf "\033[1;33m Timezone tekan ENTER\e[0m\n"
printf "\033[1;33m ClamAV pilih : Y\e[0m\n"
echo ""
cd /opt
git clone https://github.com/mailcow/mailcow-dockerized &> /dev/null
sleep 0.5
cd mailcow-dockerized
sleep 0.5
sudo chmod +x ./generate_config.sh
sleep 0.5
./generate_config.sh
sleep 0.5
clear
echo ""
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
printf "\033[1;33m++                  Install Mailcow                    ++\e[0m\n"
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
echo ""
sleep 0.5
docker-compose pull
sleep 2
clear
echo ""
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
printf "\033[1;33m++                  Install Mailcow                    ++\e[0m\n"
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
echo ""
sleep 0.5
docker-compose up -d
sleep 3

clear
echo ""
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
printf "\033[1;33m++                 Instalasi Selesai                   ++\e[0m\n"
printf "\033[1;33m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[0m\n"
echo ""
echo "🎉🎉 Hore instalasi Anda sudah selesai"
echo ""
echo "⚠️ Tunggu ± 5 menit untuk install SSL. Setelah itu masuk ke halaman url."
echo ""
echo "Login : https://"$HOSTS
echo "User  : admin"
echo "Pass  : moohoo"
echo ""
printf "\033[1;31m⚠️ Silahkan restart VPS Anda sebelum menuju link/url di atas!!!\e[0m\n"
echo ""
echo "copyright © 2022 Bang Den"
