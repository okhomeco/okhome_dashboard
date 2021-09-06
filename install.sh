#!/data/data/com.termux/files/usr/bin/bash
clear

echo -e "\033[43;31m*** 안드로이드 홈 서버 설치를 시작합니다. ***\033[0m"
echo -e "\033[43;31m*** Please check you installed termux, termux:API, termux:BOOT ***\033[0m"
cd ~
echo -e "\033[43;31m*** Updating Linux Package: When error occurs, please check your internet connection :) ***\033[0m"
apt update
apt upgrade
echo -e "\033[43;31m>>> Installing required package...\033[0m"
# zeroconf 는 IKEA Tradfri 게이트웨이 연동 시 오류 수정을 위해 설치함

apt install -y python coreutils nano clang mosquitto nodejs openssh termux-api zeroconf 
echo -e "\033[43;31m>>> Installing Process Manager...\033[0m"
npm i -g --unsafe-permn pm2

# Home Assistant 설치 -- 버전별 이슈 체크 (2021.7.4 버전은 hacs 설치에 문제가 있음) // 2021.4.0 버전 hdcp 이슈 없음 // 최신버전으로 설치 시도(210830)

echo -e "\033[43;31m>>> Installing Home Server...\033[0m"
pip install homeassistant

echo -e "\033[43;31m>>> Installing Image Library...\033[0m"
apt install -y libjpeg-turbo
echo -e "\033[43;31m>>> Installing Time Zone Data...\033[0m"
pip install tzdata
echo -e "\033[43;31m>>> Installing http support...\033[0m"
pip install aiohttp_cors

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

# Home Assistant 기본 설정 관련 파일 (custom_components, www, www/community, www/fonts, www/icons, www/sound, #include, #lovelace 관련 파일 자동설치 설정)

# Google Assistant 연동 관련 자동화 고려할 것