#!/bin/bash
set -o errexit -o pipefail

declare -A VERSIONED_DEPS=(
['github.com/Sirupsen/logrus']='v1.0.5'
['github.com/eclipse/paho.mqtt.golang']='v1.1.1'
['github.com/mattn/go-colorable']='v0.0.9'
['github.com/urfave/cli']='v1.20.0'
['github.com/mattn/go-isatty']='v0.0.3'
['github.com/bitly/go-simplejson']='v0.5.0'
['github.com/gautaz/mqttcli']='0.1.0'
)

declare -a UNVERSIONED_DEPS=(
'golang.org/x/crypto/ssh/terminal'
'golang.org/x/net/proxy'
'golang.org/x/net/websocket'
'golang.org/x/sys/unix'
)

git config --global advice.detachedHead false

mkdir -p src
(cd src && xargs -n1 dirname <<< "${!VERSIONED_DEPS[@]}" | xargs mkdir -p)

for dep in "${!VERSIONED_DEPS[@]}"; do
	echo -n "Retrieving ${dep}... "
	git clone -q --single-branch --branch "${VERSIONED_DEPS["${dep}"]}" "https://${dep}.git" "src/${dep}"
	echo "done"
done

for dep in "${UNVERSIONED_DEPS[@]}"; do
	echo -n "Retrieving ${dep}... "
	go get -u "${dep}"
	echo "done"
done

echo -n "Building mqttcli... "
go build -o mqttcli src/github.com/gautaz/mqttcli/*.go
echo "done"
ls -l mqttcli
