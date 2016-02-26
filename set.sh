#!/bin/bash

workPath=$(dirname $0)
cd $workPath
country=$1
confPath=/etc/NetworkManager/system-connections/

if ! (echo $country | grep '[a-z|A-Z]\{2\}')
then
	notify-send -i dialog-error 'Wrong argument!'
	exit 1
fi

country=$(echo $country | awk '{print toupper($0)}')

if ! (test -d configs/$country)
then
	notify-send -i dialog-error 'There's no such servers'
	exit 1
fi

if ! (ls configs/$country | grep '/')
then
	notify-send -i dialog-error 'There's no such servers'
	exit 1
fi

nmcli con show | grep 'vpn' | cut -d' ' -f1 | while read name
do
	nmcli con del $name
done

path=$workPath/configs/$country
ls -1 $path | while read name
do
	if ! (test -d $path/$name)
		then continue
	fi

	file=$path/$name/$name'.ovpn'
	if ! (test -f $file)
		then continue 
	fi

	nmcli con add con-name $name type vpn ifname "*" vpn-type openvpn

	auth=$(			cat $file | grep '^auth'  | tr ' ' '=')
	dev=$(			cat $file | grep '^dev'   | tr ' ' '=')
	cipher=$(		cat $file | grep '^cipher'| tr ' ' '=')
	remote=$(		cat $file | grep '^remote'| cut -d' ' -f1,2 | tr ' ' '=')
	port='port '$(	cat $file | grep '^remote'| cut -d' ' -f3)
	port=$(echo $port | tr ' ' '=')
	if (			cat $file | grep '^proto tcp')
	then proto='proto-tcp=yes'
	fi
	sed '/\[vpn\]/a\ca='$workPath/configs/$country/$name/ca.pem 	$confPath/$name > temp2
	sed '/\[vpn\]/a\cert='$workPath/configs/$country/$name/cert.pem temp2 > temp1
	sed '/\[vpn\]/a\key='$workPath/configs/$country/$name/key.pem 	temp1 > temp2

	sed '/\[vpn\]/a\'$proto					temp2 > temp1
	sed '/\[vpn\]/a\'$dev 					temp1 > temp2 
	sed '/\[vpn\]/a\'$cipher 				temp2 > temp1
	sed '/\[vpn\]/a\'$port 					temp1 > temp2
	sed '/\[vpn\]/a\'$remote 				temp2 > temp1
	sed '/\[vpn\]/a\'$auth 					temp1 > temp2
	sed '/\[vpn\]/a\'cert-pass-flags=0 		temp2 > temp1
	sed '/\[vpn\]/a\'connection-type=tls 	temp1 > $confPath/$name
	
	rm temp1 temp2
done

nmcli c reload

notifi-send -i network-vpn 'VPN servers was updated'


