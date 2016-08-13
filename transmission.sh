# How To Install Transmission on CentOS 7 
/*
In this tutorial we will show you how to install and configuration of Transmission on your CentOS 7. For those of you who didn’t know, Transmission BitTorrent Client features a simple interface on top of a cross-platform back-end. Transmission is licensed as a free software under the terms of the GNU General Public License (GPL), with parts under the MIT License. Transmission, like any other BitTorrent client allows users to download files from the Internet and upload their own files or torrents. By grabbing items and adding them to the interface, users can create queues of files to be downloaded and uploaded.

This article assumes you have at least basic knowledge of linux, know how to use the shell, and most importantly, you host your site on your own VPS. The installation is quite simple and assumes you are running in the root account, if not you may need to add ‘sudo’ to the commands to get root privileges. I will show you through the step by step installation Transmission on a CentOS 7 server.
*/

#First, you need to enable EPEL repository on your system.
yum install epel-release
yum -y update
#Step 2. Installing Transmission.
yum install transmission-cli transmission-common transmission-daemon

#Once complete, you can verify Transmission is installed by running the below command:
systemctl start transmission-daemon.service
systemctl stop transmission-daemon.service
#test with http://ip address:9091 (default port 9091)

#Step 3. Configuration Transmission.
nano /var/lib/transmission/.config/transmission-daemon/settings.json
#OK now let’s edit the settings (to your liking) and don’t forget to save.
# "rpc-authentication-required": true,
# "rpc-enabled": true,
# "rpc-password": "mypassword",
# "rpc-username": "mysuperlogin",
# "rpc-whitelist-enabled": false,
# "rpc-whitelist": "0.0.0.0",

systemctl start transmission-daemon.service


/*
Step 4. Accessing Transmission.

Transmission BitTorrent Client will be available on HTTP port 9091 by default. Open your favorite browser and navigate to http://yourdomain.com:9091 or http://server-ip:9091. You should be greeted with the Transmission WebUI. After logging in, you will notice that the value for the rpc-password inside the settings.json file will be hashed. If you are using a firewall, please open port 80 to enable access to the control panel.
*/

