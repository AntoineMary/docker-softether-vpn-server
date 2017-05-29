# Lightweight [Softether VPN][softether] Server
[![Build Status][project-build-image]][project-build-link] [![Docker Build][docker-build-image]][docker-build-link] [![Docker Stars][docker-stars-image]][docker-stars-link] [![Docker Pulls][docker-pulls-image]][docker-pulls-link]

[![MicroBadger Version][micro-version-image]][micro-version-links] [![MicroBadger Size][micro-size-image]][micro-size-link]

This docker only contains a working **SoftEther VPN Server** other components have been removed.

If you need other parts :
* [SoftEther VPN Bridge][bridge-link]
* [SoftEther VPN Client][client-link]
* [SoftEther VPN CMD][cmd-link]
___

# What is SoftEther VPN Server
> SoftEther VPN ("SoftEther" means "Software Ethernet") is one of the world's most powerful and easy-to-use multi-protocol VPN software. It runs on Windows, Linux, Mac, FreeBSD and Solaris.

> SoftEther VPN is open source. You can use SoftEther for any personal or commercial use for free charge.

>SoftEther VPN is an optimum alternative to OpenVPN and Microsoft's VPN servers. SoftEther VPN has a clone-function of OpenVPN Server. You can integrate from OpenVPN to SoftEther VPN smoothly. SoftEther VPN is faster than OpenVPN. SoftEther VPN also supports Microsoft SSTP VPN for Windows Vista / 7 / 8. No more need to pay expensive charges for Windows Server license for Remote-Access VPN function.

>SoftEther VPN can be used to realize BYOD (Bring your own device) on your business. If you have smartphones, tablets or laptop PCs, SoftEther VPN's L2TP/IPsec server function will help you to establish a remote-access VPN from your local network. SoftEther VPN's L2TP VPN Server has strong compatible with Windows, Mac, iOS and Android.

[https://www.softether.org/][softether]

# About this image
Versions will follow [Softether VPN Github Repository][softether-repository] tags and [Alpine][alpine-link] update.

This image is make'd from [the offical Softether VPN Github Repository][softether-repository] with 2 patchs :
1. [Server Patch][server-patch]:
  * Default Server cipher changed from **"RC4-MD5"** to **"DHE-RSA-AES256-SHA"**
  * Default HUB name changed from **"DEFAULT"** to **"HUB"**
* [OpenVPN Patch][openvpn-patch]:
  * Default OpenVPN cipher changed from **"AES-128-CBC"** to **"AES-256-CBC"**
  * Default OpenVPN auth changed from **"SHA1" to "RMD160"**
  * Client string option edited according to modification

Nothing else have been edited. So when you will start it the first time you will get the default configuration which is :
* **/!\ Administration without any password /!\**
* Server listenning on 443/tcp, 992/tcp, 1194/tcp+udp, tcp/5555
* A Virtual hub named "HUB" Without any user and SecureNAT off
* Connection on 443/tcp, 992/tcp, 1194/tcp, 5555/tcp with Softether VPN Protocol
* Connection on 1194/udp, 443/tcp, 992/tcp, 1194/tcp, 5555/tcp with OpenVPN Protocol
* MS-SSTP Connection
* Dynamic DNS

You will have to configure it. To do so use :
* [SoftEther VPN CMD][cmd-link] (any platform - Console)
* [SoftEther VPN Server Manager][softether-download] (Windows, Mac OS X - GUI)
* Edit by hand /usr/vpnserver/vpn_server.config then restart the server (Not Recommended)

# How to use this image
For a simple use without persistence :
```
docker run -d --cap-add NET_ADMIN -p 443:443/tcp -p 992:992/tcp -p 1194:1194/udp -p 5555:5555/tcp amary/softether-vpn-server
```
For a simple use with persistence (will give you access to configuration and logs) :
```
docker run -d --cap-add NET_ADMIN -p 443:443/tcp -p 992:992/tcp -p 1194:1194/udp -p 5555:5555/tcp -v /host/path/vpnserver:/usr/vpnserver:Z amary/softether-vpn-server
```
Add/delete any ```-p $PORT:$PORT/{tcp,udp} depending on you will ```

# Changelog
* v4.22-9634-beta : Initial Release
* v4.22-9634-beta.patch1 : Update Alpine to 3.6, Improve Dockerfile, Secure Entrypoint

[//]: <> (==== Reference Part ====)

[//]: <> (External Websites)
[softether]: https://www.softether.org/
[softether-download]: http://www.softether-download.com/en.aspx?product=softether
[softether-repository]: https://github.com/SoftEtherVPN/SoftEtherVPN

[bridge-link]: https://hub.docker.com/r/amary/softether-vpn-bridge/
[client-link]: https://hub.docker.com/r/amary/softether-vpn-client/
[cmd-link]: https://hub.docker.com/r/amary/softether-vpn-cmd/

[alpine-link]: https://hub.docker.com/_/alpine/

[//]: <> (Repository Link)
[server-patch]: https://github.com/AntoineMary/docker-softether-vpn-server/blob/master/assets/patchs/00_Server.sh
[openvpn-patch]: https://github.com/AntoineMary/docker-softether-vpn-server/blob/master/assets/patchs/01_OpenVPN.sh

[//]: <> (Badges)
[project-build-image]: https://travis-ci.org/AntoineMary/docker-softether-vpn-server.svg?branch=master
[project-build-link]: https://travis-ci.org/AntoineMary/docker-softether-vpn-server

[docker-build-image]: https://img.shields.io/docker/automated/amary/softether-vpn-server.svg
[docker-build-link]: https://hub.docker.com/r/amary/softether-vpn-server/

[docker-stars-image]: https://img.shields.io/docker/stars/amary/softether-vpn-server.svg
[docker-stars-link]: https://hub.docker.com/r/amary/softether-vpn-server/

[docker-pulls-image]: https://img.shields.io/docker/pulls/amary/softether-vpn-server.svg
[docker-pulls-link]: https://hub.docker.com/r/amary/softether-vpn-server/

[micro-size-image]:https://images.microbadger.com/badges/image/amary/softether-vpn-server.svg
[micro-size-link]: https://microbadger.com/images/amary/softether-vpn-server

[micro-version-image]: https://images.microbadger.com/badges/version/amary/softether-vpn-server.svg
[micro-version-links]: https://microbadger.com/images/amary/softether-vpn-server
