# OK Home / Homepad

Termux 기반 안드로이드 Home Assistant 서버 설치 스크립트

1. Android 10인치 태블릿 추천
2. F-Droid / Termux / Termux:API / Termux:Boot 사전 설치
3. Home Assistant / Mosquitto 설치 (스크립트 내)
4. PM2 로 Hass, Mosquitto 백그라운드 서비스 유지 및 설정 저장
5. Termux:Boot 설정으로 기기 재부팅 시 PM2 설정 자동 복구 (기기를 재부팅해도 Home Assistant 서버 및 Mosquitto 자동 재시작)


# Known Issue

1. 안드로이드 10 이상 보안지침에 따라 기기 재부팅 시 Mac 주소가 자동으로 변경됨

> 기기 재부팅 시에 Mac 주소 변경으로 Local IP 주소가 변경됨 (라우터에서는 Mac 주소를 기반으로 IP를 고정하기 떄문에 라우터 설정으로 IP 고정이 불가)
> 따라서, 안드로이드 기기 설정에서 Wi-Fi > 라우터 선택 > 고급 설정 > 개인정보 보호 > 기기 MAC 사용을 설정


