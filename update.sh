#!/bin/bash

cd $(dirname $0)

url=http://www.vpngate.net/api/iphone/
oPath=configs
sFile=servers
lFile=logs
tFile=temp

#Getting list of servers
notify-send -i network-vpn 'Updating VPN servers: DOWNLOADING'
wget -O $tFile -o $lFile $url

#Проверка 
if grep -q '*vpn_servers' $tFile
then
	grep -v '^#\|^\*\|,-,' $tFile > $sFile
else
	notify-send -i dialog-error 'Updating VPN servers: FAIL'
	exit 1
fi
rm $tFile

rm -r $oPath/*

#Parse file
while read line
do
	name=$(  echo $line | cut -d"," -f1)
	county=$(echo $line | cut -d"," -f7)
	base64=$(echo $line | cut -d"," -f15)
	path=$oPath/$county/$name

	mkdir -p $oPath/$county $path

	echo $base64 | base64 --decode > $path/$name'.ovpn'
	
	##Take  sertificates from file and save:
	#Server
	cat $path/$name'.ovpn' | sed -n '/<ca>/,/<\/ca>/p' | sed '/<ca>\|<\/ca>/d' > $path/ca.pem
	#Client
	cat $path/$name'.ovpn' | sed -n '/<cert>/,/<\/cert>/p' | sed '/<cert>\|<\/cert>/d' > $path/cert.pem
	#Key
	cat $path/$name'.ovpn' | sed -n '/<key>/,/<\/key>/p' | sed '/<key>\|<\/key>/d' > $path/key.pem
done < $sFile

notify-send -i network-vpn 'Updating VPN servers: SUCCESS'