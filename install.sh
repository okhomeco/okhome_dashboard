#!/data/data/com.termux/files/usr/bin/bash
clear

echo -e "\033[43;31m*** 안드로이드 홈 서버 설치를 시작합니다. ***\033[0m"
echo -e "\033[43;31m*** Please check you installed termux, termux:API, termux:BOOT ***\033[0m"
cd ~
echo -e "\033[43;31m*** Updating Linux Package: When error occurs, please check your internet connection :) ***\033[0m"
pkg update
pkg upgrade
echo -e "\033[43;31m>>> Installing required package...\033[0m"
# autoconf 는 IKEA Tradfri 게이트웨이 연동 시 오류 수정을 위해 설치함

pkg install python coreutils nano clang mosquitto nodejs openssh termux-api autoconf
echo -e "\033[43;31m>>> Installing Process Manager...\033[0m"
npm i -g --unsafe-permn pm2

# Wheel 설치 
pip install wheel

# Home Assistant 설치 -- 버전별 이슈 체크 (2021.7.4 버전은 hacs 설치에 문제가 있음) // 2021.4.0 버전 hdcp 이슈 없음 // 최신버전으로 설치 시도(210830)

echo -e "\033[43;31m>>> Installing Home Server...\033[0m"
pip install homeassistant==2021.8.8

echo -e "\033[43;31m>>> Installing Image Library...\033[0m"
pkg install -y libjpeg-turbo
echo -e "\033[43;31m>>> Installing Time Zone Data...\033[0m"
pip install tzdata
echo -e "\033[43;31m>>> Installing http support...\033[0m"
pip install aiohttp_cors
echo -e "\033[43;31m>>> Installing Zeroconf support...\033[0m"
pip install zeroconf
echo -e "\033[43;31m>>> Installing Additional support...\033[0m"
# pip install sqlalchemy==1.4.17
# pip install pillow
# pip install pyturbojpeg
pip install dtlssocket
pip install pycountry # Required for LG Smart Thinq Custom Componant

echo -e "\033[43;31m>>> Starting ssh server... Connect with port 8022 \033[0m"
sshd

echo -e "\033[43;31m!!! Check your IP address !!!\033[41;37m"
ifconfig | grep inet
sleep 1
echo -e "\033[43;31m!!! Set your ssh password !!!\033[41;37m"
passwd

echo -e "\033[43;31m>>> Mosquitto test run : if finished, press Ctrl + C to abort\033[0m"
mosquitto

echo -e "\033[43;31m***** Initializing Home Servier...\033[0m"
echo -e "\033[43;31m***** When the timer starts, please open web-browser and set-up your home-server - http://localhost:8123\033[0m"
hass -v

echo -e "\033[41;37m>!!! If your Home Server running OK, Set the Process Manager Setting via TYPE ///pm2_setting.sh///  \033[0m"

# pm2_setting.sh 파일에 pm2 설정값 넣기

echo -e '#!/data/data/com.termux/files/usr/bin/sh\n pm2 start mosquitto -- -v -c /data/data/com.termux/files/usr/etc/mosquitto/mosquitto.conf\n pm2 start hass --interpreter=python -- --config /data/data/com.termux/files/home/.homeassistant\n pm2 save' | tee pm2_setting.sh
chmod 755 pm2_setting.sh

#echo -e "\033[41;37m>>> Process Manager Setting... \033[0m"
#pm2 start mosquitto -- -v -c /data/data/com.termux/files/usr/etc/mosquitto/mosquitto.conf
#pm2 start hass --interpreter=python -- --config /data/data/com.termux/files/home/.homeassistant
#pm2 save

echo -e "\033[41;37m>>> Enable Media Browser... \033[0m"
cd ~/.homeassistant
mkdir media

echo -e "\033[41;37m>>> Setting Termux Boot Environment... \033[0m"
mkdir ~/.termux/boot
cd ~/.termux/boot
echo -e "\033[41;37m>>> Creating start-pm2 file... \033[0m"
echo -e '#!/data/data/com.termux/files/usr/bin/sh\n termux-wake-lock\n sshd\n node /data/data/com.termux/files/usr/bin/pm2 resurrect' | tee start-pm2
chmod 755 start-pm2

echo -e "\033[41;31m!!! You should run Termux:Boot app once to enable device-boot auto-start server !!! \033[0m"

# # smbd 설치 >> root 권한 없이 설정 어려움 (재검토 필요)
# echo -e "\033[41;31m!!! 파일 접속용 Samba Server 를 설정합니다 !!! \033[0m"
# pkg install unstable-repo
# pkg install samba
# # smb.conf 설정 파일 생성
# mkdir /data/data/com.termux/files/usr/etc/samba
# echo -e '[share]\ncomment = share\npath = /data/data/com.termux/files/\npublic = no\nwritable = yes\nprintable = no\nwrite list = root\ncreate mask = 0777\n directory mask = 0777' | tee /data/data/com.termux/files/usr/etc/samba/smb.conf
# smbpasswd

# termux-setup-storage

echo -e "\033[41;31m*** 저장공간 접근 권한을 요청합니다. *** \033[0m"
termux-setup-storage

# VS Code Server Install
pkg install yarn
pkg install build-essential
pkg install git
yarn global add code-server
pkg install ripgrep

# VS Code Server 외부접속 설정
ip=`ip addr |
    grep lan0 |
    grep 192 |
    awk '{split($2, arr,"/"); print arr[1]}'`

sed -i "1s/.*/bind-addr: ${ip}:8080/g" ~/.config/code-server/config.yaml

code-server &

# Home Assistant 기본 설정 관련 파일 (custom_components, www, www/community, www/fonts, www/icons, www/sound, #include, #lovelace 관련 파일 자동설치 설정 예정)

# Google Assistant 연동 관련 자동화 추가 예정