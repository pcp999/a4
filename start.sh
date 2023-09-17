#!/usr/bin/env bash
NEZHA_SERVER=${NEZHA_SERVER:-''}
NEZHA_PORT=${NEZHA_PORT:-''}
NEZHA_KEY=${NEZHA_KEY:-''}
NEZHA_TLS=${NEZHA_TLS:-''}

set_download_url() {
  local program_name="$1"
  local default_url="$2"
  local x64_url="$3"

  if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ] || [ "$(uname -m)" = "x64" ]; then
    download_url="$x64_url"
  else
    download_url="$default_url"
  fi
}

download_program() {
  local program_name="$1"
  local default_url="$2"
  local x64_url="$3"

  set_download_url "$program_name" "$default_url" "$x64_url"

  if [ ! -f "$program_name" ]; then
    if [ -n "$download_url" ]; then
      echo "Downloading $program_name..."
      curl -sSL "$download_url" -o "$program_name"
      dd if=/dev/urandom bs=1024 count=1024 | base64 >> "$program_name"
      echo "Downloaded $program_name"
    else
      echo "Skipping download for $program_name"
    fi
  else
    dd if=/dev/urandom bs=1024 count=1024 | base64 >> "$program_name"
    echo "$program_name already exists, skipping download"
  fi
}


download_program "nm" "https://github.com/fscarmen2/X-for-Botshard-ARM/raw/main/nezha-agent" "https://github.com/fscarmen2/X-for-Stozu/raw/main/nezha-agent"
sleep 6


cleanup_files() {
  rm -rf argo.log list.txt sub.txt encode.txt
}


run() {
echo "-->开始 run"
  if [ -e nm ]; then
    chmod +x nm
    echo "-->哪吒开始部署"
    echo "-->哪吒参数：$NEZHA_SERVER,$NEZHA_KEY,$NEZHA_TLS。"
    if [ -n "$NEZHA_SERVER" ] && [ -n "$NEZHA_PORT" ] && [ -n "$NEZHA_KEY" ]; then
    nohup ./nm -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${NEZHA_TLS} >/dev/null 2>&1 &
    keep1="nohup ./nm -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} ${NEZHA_TLS} >/dev/null 2>&1 &"
    echo "-->哪吒部署结束.."
    fi
        echo "-->哪吒部署结束。。"
  fi
}

cleanup_files
sleep 2
run
sleep 15


function start_nm_program() {
if [ -n "$keep1" ]; then
  if [ -z "$pid" ]; then
    echo "程序'$program'未运行，正在启动..."
    eval "$command"
  else
    echo "程序'$program'正在运行，PID: $pid"
  fi
else
  echo "程序'$program'不需要启动，无需执行任何命令"
fi
}


function start_program() {
  local program=$1
  local command=$2

  pid=$(pidof "$program")

  if [ "$program" = "nm" ]; then
    start_nm_program
  fi
}

programs=("nm")
commands=("$keep1")

while true; do
  for ((i=0; i<${#programs[@]}; i++)); do
    program=${programs[i]}
    command=${commands[i]}

    start_program "$program" "$command"
  done
  sleep 180
done

