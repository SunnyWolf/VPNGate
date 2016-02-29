# VPNGate
Update.sh
============
The script downloads list of servers, parsing it and saves config files '.ovpn' + keys 'key.pem, ca.pem, cert.pem' .

**Requirements:**

 - wget
 - notify-send

Set.sh
============
The script takes argument 'Country-Short'. It looks for servers in config's directory and add openvpn connections in network manager.

**Usage:** sudo set.sh '[Country-Short]' **or** gksu set.sh '[Country-Short]'

**Requirements:**

 - sudo | gksu
 - nmcli (NetworkManager)
 - notify-send
