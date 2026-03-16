# Cisco Anyconnect VPN with 2 Factor Authentication Automator

I forked this very useful project from https://github.com/yusufozgur/Cisco_Anyconnect_2FA_VPN_Automator and adapted it to my needs. At my university there is a similar solution, using Cisco AnyConnect.
I made small changes to vpn_config.env to reflect TU Wien VPN settings.
I also adjusted activatevpn.bash since in our implementation of 2FA, the server expects additional newline after username is provided. Therefore, the solution with a single variable `pwd_info` doesn't work.
I adjusted the output of keepassxc to an array, and then separate USERNAME, PASSWORD and TOTP are passed to the vpn client.

## Motivation

My university has put many services behind a vpn connection, and users utilize Cisco Anyconnect VPN to connect to the vpn, where they have to enter their username, password, and the one time password. It is also a good practice to use a password manager with this workflow. Nonetheless, this ritual of opening the password manager, KeePassXC in my case, opening cisco vpn gui, and then alternating between password manager and the vpn gui to enter password and OTP has become quite tedious over the months.

This repo contains two scripts and a config file that automates this workflow.

## How it works

Cisco has an interactive cli tool called vpn, after installing cisco anyconnect, it should appear to linux users at "/opt/cisco/secureclient/bin/vpn". Using this CLI and the KeePassXC cli, it is possible to completely automate the vpn connection workflow. 

## Setting up

1. Download KeePassXC and Cisco Anyconnect, create an entry in KeePassXC with you uni id, password and set up OTP.

2. Clone this repository

```
git clone [https://github.com/yusufozgur/Cisco_Anyconnect_2FA_VPN_Automator](https://github.com/zbabac/Cisco_Anyconnect_2FA_VPN_Automator.git)
cd Cisco_Anyconnect_2FA_VPN_Automator
```

3. Setup the config file (vpn_config.env), its default values reflect my use case, just change the strings between the quotations.

```
# This is the database file for KeePassXC.
DB_PATH="/home/z/.keepass/Passwords.kdbx"
# Entry Name for the entry in the database file.
ENTRY_NAME="TUvpn"
# This should be the connection url your organization provides.
VPN_HOST="vpn.tuwien.ac.at"
# This is the path that the vpn cli by cisco resides in my system, may change in your system.
VPN_CLIENT="/opt/cisco/secureclient/bin/vpn"
```

4. Now you can use ./activatevpn.bash and ./deactivatevpn.bash, it asks for the password and then either activates or deactives the vpn connection.
5. (Optional) You can add symbolic links for these files to PATH for accessing outside of the repo folder.
```
ln -sf "$(pwd)/activatevpn.bash" ~/.local/bin/activatevpn
ln -sf "$(pwd)/deactivatevpn.bash" ~/.local/bin/deactivatevpn
ln -sf "$(pwd)/statusvpn.bash" ~/.local/bin/statusvpn
ln -sf "$(pwd)/vpn_config.env" ~/.local/bin/vpn_config.env
```
Then the usage becomes
```
activatevpn
deactivatevpn
```

6. (Optional) Create Desktop file to be able to click from desktop or/and App Launcher to connect VPN
Modify desktop file with your paths in sections Exec and Path.  
Cisco-VPN-Activate.desktop
```
[Desktop Entry]
Categories=Network
Comment[en_US]=
Comment=
Exec="/home/z/programi/2fa_vpn/activatevpn.bash"
GenericName[en_US]=
GenericName=
Icon=cisco-secure-client
MimeType=
Name[en_US]=Cisco VPN Activate
Name=Cisco VPN Activate
Path=/home/z/programi/2fa_vpn/
StartupNotify=false
Terminal=true
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
```
Copy to your desktop and launcher path:
cp Cisco-VPN-Activate.desktop ~/Desktop/
cp Cisco-VPN-Activate.desktop ~/.local/share/applications

7. (Optional) Create Desktop file to disconnect from VPN
Modify desktop file with your paths in sections Exec and Path.  
Cisco-VPN-Disconnect.desktop
```
[Desktop Entry]
Categories=Network;Utilities
Comment[en_US]=
Comment=
Exec=/home/z/programi/2fa_vpn/deactivatevpn.bash
GenericName[en_US]=
GenericName=
Icon=D23E_msiexec.0
MimeType=
Name[en_US]=Cisco-VPN-Disconnect
Name=Cisco-VPN-Disconnect
Path=~/programi/2fa_vpn/
StartupNotify=false
Terminal=true
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
```
Copy to your desktop and launcher path:
cp Cisco-VPN-Disconnect.desktop ~/Desktop/
cp Cisco-VPN-Disconnect.desktop ~/.local/share/applications
