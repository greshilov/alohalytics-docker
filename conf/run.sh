yes | cp -rf /conf/nginx.conf /etc/nginx/nginx.conf
spawn-fcgi -a 127.0.0.1 -p 8888 -P /aloha/run/aloha.pid \
-- /aloha/bin/server/fcgi_server /data /monitoring
nginx
logrotate /conf/logrotate.conf
while :; do
  sleep 300
done
