# VPNGate
Update.sh
============
The script downloads list of servers, parsing it and saves config files.

**Requirements:**

 - wget
 - notifi-send

Set.sh
============
The script takes argument 'Country-Short'. It looks for servers in config files and add openvpn connections in network manager.

**Usage:** sudo set.sh '[Country-Short]'

**Requirements:**

 - sudo
 - nmcli (NetworkManager)
 - notifi-send
