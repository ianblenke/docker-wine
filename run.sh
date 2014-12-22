#!/bin/bash
set -xe

export CDRIVE=/root/.wine/drive_c

USER="${USER:-root}"
mkdir -p /tmp/${USER}-vnc
echo "${PASSWORD:-idontdowindows}" | tightvncpasswd -f > /tmp/${USER}-vnc/passwd

Xtightvnc :0 -nolisten tcp -geometry 1280x1024 -depth 16 -ac -rfbauth /tmp/${USER}-vnc/passwd &
XTIGHTVNC_PID=$!

cat <<EOF > /etc/xrdp/xrdp.ini
[globals]
bitmap_cache=yes
bitmap_compression=yes
port=3389
crypt_level=low
channel_code=1
max_bpp=24

[xrdp1]
name=Console
lib=libvnc.so
ip=127.0.0.1
port=5900
username=na
password=ask
EOF

xrdp-keygen xrdp /etc/xrdp/rsakeys.ini
xrdp -nodaemon &
XRDP_PID=$!

xfce4-session

kill $XTIGHTVNC_PID $XRDP_PID
