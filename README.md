# Cisco Anyconnect VPN with 2 Factor Authentication Automator

## Motivation

My university has put many services behind a vpn connection, and users utilize Cisco Anyconnect VPN to connect to the vpn, where they have to enter their username, password, and the one time password. It is also a good practice to use a password manager with this workflow. Nonetheless, this ritual of opening the password manager, KeePassXC in my case, opening cisco vpn gui, and then alternating between password manager and the vpn gui to enter password and OTP has become quite tedious over the months.

This repo contains two scripts and a config file that automates this workflow.

## How it works

Cisco has an interactive cli tool called vpn, after installing cisco anyconnect, it should appear to linux users at "/opt/cisco/secureclient/bin/vpn". Using this CLI and the KeePassXC cli, it is possible to completely automate the vpn connection workflow. 

## Setting up

1. Download KeePassXC and Cisco Anyconnect, create an entry in KeePassXC with you uni id, password and set up OTP.
2. Clone this repository

```
git clone ...
```

3. Setup the config file, its default values reflect my use case, just change the strings between the quotations.

```
# This is the database file for KeePassXC.
DB_PATH="/home/yusuf/Sync/passwords.kdbx"
# Entry Name for the entry in the database file.
ENTRY_NAME="Uni-Heidelberg"
# This should be the connection url your organization provides.
VPN_HOST="vpn-ac.urz.uni-heidelberg.de"
# This is the path that the vpn cli by cisco resides in my system, may change in your system.
VPN_CLIENT="/opt/cisco/secureclient/bin/vpn"
```

4. Now you can use ./activatevpn.bash and ./deactivatevpn.bash, it asks for the password and then either activates or deactives the vpn connection.
5. (Optional) You can add symbolic links for these files to PATH for accessing outside of the repo folder.
```
ln -sf "$(pwd)/activatevpn.bash" ~/.local/bin/activatevpn
ln -sf "$(pwd)/deactivatevpn.bash" ~/.local/bin/deactivatevpn
ln -sf "$(pwd)/vpn_config.env" ~/.local/bin/vpn_config.env
```
