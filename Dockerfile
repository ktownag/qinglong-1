FROM whyour/qinglong:latest
COPY xr /xr
COPY front.conf /etc/nginx/conf.d/front.conf

RUN set -x \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f wget unzip make python3 py3-pip build-base util-linux git curl perl bash sudo rclone transmission-cli syncthing\
    && rm -rf /var/cache/apk/* \
    && apk update \
    && git clone https://github.com/botgram/shell-bot.git /shell-bot \
    && cd /shell-bot \
    && npm install yarn -g \
    && npm install nodemon -g \
    && npm i \
    && rm -rf /root/.cache \
    && rm -rf /root/.npm \
    && mkdir -p /root/.config/rclone/ \
    && chmod +x /xr

EXPOSE 5700
ENTRYPOINT ["./docker/docker-entrypoint.sh"]
