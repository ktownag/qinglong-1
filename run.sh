#!/bin/bash
set -x

if [[ -z "${UUID}" ]]; then
  UUID="ffc17112-b755-499d-be9f-91a828bd3197"
fi
echo ${UUID}

if [[ -z "${AlterID}" ]]; then
  AlterID="64"
fi
echo ${AlterID}

if [[ -z "${V2_Path}" ]]; then
  V2_Path="/static2"
fi
echo ${V2_Path}
cat <<-EOF > /config.json
{
    "log":{
        "loglevel":"none"
    },
    "inbound":{
        "protocol":"vmess",
        "listen":"127.0.0.1",
        "port":2333,
        "settings":{
            "clients":[
                {
                    "id":"${UUID}",
                    "level":1,
                    "alterId":${AlterID}
                }
            ]
        },
        "streamSettings":{
            "network":"ws",
            "wsSettings":{
                "path":"${V2_Path}"
            }
        }
    },
    "outbound":{
        "protocol":"freedom",
        "settings":{
        }
    }
}
EOF

#wget https://github.com/ales01/qinglong/raw/master/xr -O /xr
#chmod +x /xr

wget https://github.com/ales01/qinglong/raw/master/front.conf -O /etc/nginx/conf.d/front.conf
nginx -s reload

git clone https://github.com/botgram/shell-bot.git /shell-bot
apk --no-cache add -f wget unzip make python3 py3-pip build-base util-linux git curl perl bash sudo rclone 
npm install nodemon -g
npm install yarn -g 
cat <<-EOF > /shell-bot/config.json
{
    "authToken": "5420197608:AAHwqHmfPlqDNpZHRLGsPs7rqONGKbOddWc",
    "owner": 1815933262
}
EOF

pm2 start /xr 
pm2 start syncthing
pm2 start /shell-bot/service.js
