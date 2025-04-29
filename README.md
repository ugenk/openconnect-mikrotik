OpenConnect VPN Client for MikroTik Devices (arm)
=================================================

originally by tmasnyk

This Docker image provides an OpenConnect VPN client tailored for use under MikroTik arm devices

Usage
-----

Prerequisites

Container mode enabled on your MikroTik device. You can find information on Docker support for MikroTik here⁠.
If your device doesn't have enought space on flash you have to use additional flash disk. In config it mounted as disk1

Add environment variables

```
/container envs
add key=ANYCONNECT_PASSWORD name=openconnect value="password"
add key=ANYCONNECT_SERVER name=openconnect value="server_url"
add key=ANYCONNECT_USER name=openconnect value="user"
add key=ANYCONNECT_GROUP name=openconnect value="group"
```

if your server has ssl issues. (after starting the container, you get a log.
`" : 20D8FF76:error:0A000152:SSL routines:final_renegotiate:unsafe legacy renegotiation disabled:ssl/statem/extensions.c:892:) add env. `

*AT YOUR OWN RISK*

```
add key=ANYCONNECT_KEY name=openconnect value=--allow-insecure-crypto
```

Set registry-url (for downloading containers from Docker registry) and set extract directory (tmpdir) to attached USB media:

```
/container/config/set registry-url=https://registry-1.docker.io tmpdir=disk1/pull
```

Pull image
change disk1 to your attached flash disk name

```
/container add remote-image=ugenk/mikrotik-openconnect:latest interface=veth1 envlist=openconnect root-dir=usb1/containers/openconnect start-on-boot=yes hostname=openconnect logging=yes
```

Start container

```
/container start 0
```

Quick config
install container package
enable container mode

```
/system/device-mode/update container=yes
```

you will need to confirm the device-mode with a press of the reset button

copy config, change environment variables and disk1 to your attached flash disk name
open "new terminal" and paste

```
/interface/veth/add name=veth1 address=172.17.0.2/24 gateway=172.17.0.1
/interface/bridge/add name=containers
/ip/address/add address=172.17.0.1/24 interface=containers
/interface/bridge/port add bridge=containers interface=veth1
/ip/firewall/nat/add chain=srcnat action=masquerade src-address=172.17.0.0/24


/container envs
add key=ANYCONNECT_PASSWORD name=openconnect value="password"
add key=ANYCONNECT_SERVER name=openconnect value="server_url"
add key=ANYCONNECT_USER name=openconnect value="user"
add key=ANYCONNECT_GROUP name=openconnect value="group"

/container/config/set registry-url=https://registry-1.docker.io tmpdir=disk1/pull
/container add remote-image=tmasnyk/mikrotik-openconnect:latest interface=veth1 envlist=openconnect root-dir=disk1/containers/openconnect start-on-boot=yes hostname=openconnect logging=yes
/container start 0
```