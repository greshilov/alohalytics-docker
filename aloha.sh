#!/bin/bash
set -u -e

OPT_HOST=localhost
OPT_PORT=80

while getopts ":h:p:" opt; do
  case $opt in
    h)
      OPT_HOST="$OPTARG"
      ;;
    p)
      OPT_PORT="$OPTARG"
      ;;
    *)
      echo "This scripts run alohalytics server for specifed host and port"
      echo "Usage: $0 [-h] [host] [-p] [port]"
      echo
      echo -e "-h\tPossible hostnames"
      echo -e "-p\tPorts to use"
      exit 1
      ;;
  esac
done

! [ -x "$(command -v docker)" ] && echo 'Docker is not installed.' >&2 && exit 1
echo "Pulling image from docker repo..."
docker pull greshilov/mapsme:alohalytics
echo "Done."
docker stop $(docker ps -a -q)
docker run -td --mount type=bind,source="$(pwd)"/conf,target=/conf --volume "$(pwd)"/data:/data:rw --volume "$(pwd)"/logs:/logs:rw -p $OPT_PORT:80 alohalytics
echo "Running on $OPT_HOST:$OPT_PORT"
