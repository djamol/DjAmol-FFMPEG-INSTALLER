# DjAmol-PHP+Apache+OpenSSL+Curl+FFMPEG+More-INSTALLER
Firstly remove old version using command :
yum remove libvpx libogg libvorbis libtheora libx264 x264 ffmpeg ffmpeg-devel

Login Root With Using Puty/Ssh Client ( Copy And paste command in Putty application Using Shift+Insert )
Commands To Start ( SSH Command ):




yum -y install wget unzip;wget --no-check-certificate -O installer.zip https://github.com/djamol/centos-INSTALLER/archive/master.zip; unzip installer.zip;
cd centos-INSTALLER-master;chmod +x setup;chmod +x inc/*.sh; ./setup > /root/output.txt & 
#Server/VPS Information

wget https://raw.githubusercontent.com/djamol/centos-INSTALLER/master/server.info.sh;sh server.info.sh

# Run This Script (With SSH command)
&#x1F536;Install Centos Minimal Version Os in Virtual/Dedicated Server<br />
&#x1F536;Login SSH With root username and password<br />
&#x1F53D;Then Type This Command at ssh<br /><code>
yum -y install wget unzip;wget --no-check-certificate -O installer.zip https://github.com/djamol/centos-INSTALLER/archive/master.zip; unzip installer.zip; cd centos-INSTALLER-master;chmod +x setup;chmod +x inc/*.sh;
./setup</code>

# Install ffmpeg

Run command <code>./ffmpeg </code>
OR More info at https://github.com/djamol/FFMPEG-CENTOS/blob/master/README.md

# Install Webmin

yum -y install wget unzip;wget --no-check-certificate -O installer.zip https://github.com/djamol/centos-INSTALLER/archive/master.zip; unzip installer.zip;
cd centos-INSTALLER-master;chmod +x setup;chmod +x inc/*.sh; ./setup > /root/output.txt & 
Backgroud: nohup ./install > /root/output.txt & 
Create Cetificate

mkdir /usr;mkdir /usr/share;mkdir /usr/share/ssl; mkdir /usr/share/ssl//certs;
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/share/ssl/certs/ssl.crt -out /usr/share/ssl/certs/ssl.crt

more example watermark ffmpeg :http://ksloan.net/watermarking-videos-from-the-command-line-using-ffmpeg-filters/


# Backup DATABASE
Commands : https://github.com/djamol/centos-INSTALLER/blob/master/database_backup.sh
# Restore DATABASE (All)
Shell>   mysql -u root -p < schema.sql

# Find in Files String in( Directory,subdirectory all files )
cd /home/directoy; grep -nr 'yourString*'  
grep -r --include=*.txt 'searchterm' ./  ...or case-insensitive version... grep -r -i --include=*.txt 'searchterm' ./
// /home/directory location directory, find string,word yourString* (* means after yourString any thing word character)
---Find And Replace String or word
cd /home/directoy; grep -rl FindString | xargs sed -i 's/FindString/ReplaceString/g'

example: find google.in string and replace with yahoo.com
cd /home/directoy; grep -rl google.in | xargs sed -i 's/google.in/yahoo.com/g'



If you have list of files you can use

replace "old_string" "new_string" -- file_name1 file_name2 file_name3

If you have all files you can use

replace "old_string" "new_string" -- *

If you have list of files with extension, you can use

replace "old_string" "new_string" -- *.extension

#scan only extension files and replace whole line .line start with 
"ErrorDocument 401" 
all txt file only 
in /home folder and sub folder

find /home/ -type f -name '*.txt' -readable -writable -exec sed -i "/^ErrorDocument 401/c\  " {} +


# repo files and update package/install clean cache with yum
 yum clean all; yum update; yum clean all; yum update;yum clean all; yum update;

# BAckup specific extension files in folder sub folder directory in zip
find . | egrep "\.(html|css|js|php)$" | zip -@ test.zip

One approach could be using find change in subdirectory and all directory in current:
#for directories

find . -type d -print0 | xargs -0 chmod 0755

#for files( all files in current)

find . -type f -print0 | xargs -0 chmod 0644

