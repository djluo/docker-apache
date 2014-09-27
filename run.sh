#!/bin/bash
# vim:set et ts=2 sw=2:

current_dir=`dirname $0`
current_dir=`readlink -f $current_dir`
cd ${current_dir} && export current_dir

app="apache"
cid="/var/lock/docker-cid"
port="-p 8080:8080"

run() {
  local cidfile=""
  local mode="-d"

  if [ "x${1:0:9}" == "x--cidfile" ];then
    cidfile="$1"
    shift
  elif [ "x$1" == "xdebug" ];then
    local mode="-ti --rm"
    local app="debug_$app"
    unset port
    shift
  fi

  local cmd="$@"
  [ -d "$cid" ] || mkdir "${cid}"

  sudo docker run $mode $cidfile $port \
      -v ${current_dir}/conf/:${current_dir}/conf/ \
      -v ${current_dir}/logs/:${current_dir}/logs/ \
      -v ${current_dir}/html/:${current_dir}/html/ \
      -e "TZ=Asia/Shanghai" \
      --name ${app} apache  \
      $cmd
}
usage() {
  echo "Usage: $0 [start|stop|debug]"
  exit 127
}
###############
case "$1" in
  start)
    if [ ! -f "$cid/$app.cid" ];then
      run --cidfile="$cid/$app.cid" /usr/sbin/httpd -DFOREGROUND -f ${current_dir}/conf/httpd.conf
    else
      sudo docker start $app
    fi
    ;;
  stop)
    sudo docker stop -t 300 $app
    ;;
  debug)
    run debug /bin/bash -l
    ;;
  *)
    usage
    ;;
esac
