#!/bin/bash -ex

rm -f /tmp/.X1-lock
Xvfb :1 -screen 0 800x600x24 &
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

# Does a YAML for the instance exist?
if [ ! -f "/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/dedicated_${INSTANCE_NAME}.yaml" ]
then
	# No, copy for edit
	cp "/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/dedicated.yaml" "/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/dedicated_${INSTANCE_NAME}.yaml"
fi

cd "/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/DedicatedServer"

sh -c 'until [ "`netstat -ntl | tail -n+3`" ]; do sleep 1; done
sleep 5 # gotta wait for it to open a logfile
tail -F ../Logs/current.log ../Logs/*/*.log 2>/dev/null' &
/opt/wine-staging/bin/wine ./EmpyrionDedicated.exe -batchmode -logFile ../Logs/current.log -dedicated ../dedicated_${INSTANCE_NAME}.yaml "$@" &> "/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/Logs/wine.log"