#!/bin/bash
set -u -e

HTTP_PORT_REGEXP="listen[[:space:]]*([0-9]*);"
HTTPS_PORT_REGEXP="[[:space:]]listen[[:space:]]*([0-9]*)[[:space:]]*ssl;"
CONF_DIR="$PWD"/conf
DATA_DIR="$PWD"/data
LOGS_DIR="$PWD"/logs
PORT="-p 80:80"
HTTPS_PORT=

[[ $(cat $CONF_DIR/nginx.conf) =~ $HTTP_PORT_REGEXP ]]
[ ! -z ${BASH_REMATCH[1]:-} ] && PORT="-p ${BASH_REMATCH[1]}:80"

[[ $(cat $CONF_DIR/nginx.conf) =~ $HTTPS_PORT_REGEXP ]]
[ ! -z ${BASH_REMATCH[1]:-} ] && HTTPS_PORT="-p ${BASH_REMATCH[1]}:443"


! [ -x "$(command -v docker)" ] && echo 'Docker is not installed.' >&2 && exit 1
echo "Pulling image from docker repo..."
docker pull greshilov/mapsme:alohalytics
echo "Done."
docker stop $(docker ps -a -q)

docker run -td \
--mount type=bind,source=$CONF_DIR,target=/conf \
--volume $DATA_DIR:/data:rw \
--volume $LOGS_DIR:/logs:rw \
${PORT:-} \
${HTTPS_PORT:-} \
alohalytics

echo "Running on ports ${PORT:-} ${HTTPS_PORT:-}"
