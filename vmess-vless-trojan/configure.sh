#!/bin/sh
# V2Ray generate configuration
# Download and install V2Ray
config_path="config.json"
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl
# Remove temporary directory
rm -rf /tmp/v2ray
# V2Ray new configuration
install -d /usr/local/etc/v2ray
envsubst '\$UUID' < $config_path > /usr/local/etc/v2ray/config.json
# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json &
# Run nginx
/bin/bash -c "envsubst '\$PORT,\$UUID' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'
