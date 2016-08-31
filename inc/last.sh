# Some Config  apache Program (last.sh )
# DjAmol Group Pvt Ltd.
# WWW.DjAmol.Com
# djamolpatil@gmail.com



## Make Public folder And enable php allow to access makefolder/create file and more
mkdir /home; mkdir /home/www
echo "<html><body><h1>It works Apache!<br> <?php phpinfo(); ?></h1></body></html>" >> /home/www/index.php
#First :We need to set the owner/group of the web root (and any directories/files therein):
chown -R daemon:daemon /home/www
#Second:We need to setup the proper permissions for users and groups.'go'-'group' and 'other'.rwx-Read,Write,execute
chmod go-rwx /home/www/;chmod go+x /home/www/;chgrp -R www-data /home/www/;chmod -R go-rwx /home/www/
chmod -R g+rx /home/www/;chmod -R g+rwx /home/www/

#Auto Start Apache2 on boot/reboot server
#touch /etc/init.d/apache2
#echo -e '#!/bin/bash\n# apache2-Startup script for the Apache HTTP Server\n/usr/local/apache2/bin/apachectl $@' >> /etc/init.d/apache2
cp -f $SCRIPTPATH/apache2 /etc/init.d/apache2
chmod 755 /etc/init.d/apache2
chkconfig --add apache2
chkconfig --list apache2
chkconfig apache2 on
systemctl daemon-reload; /etc/init.d/apache2 restart
date +"%r" >> $BUILD;echo "Apache Make Boot script complete start it from webmin.panel Startup and bootup option" >> $BUILD


# sed '/pattern/a some text here\nNewline' filename
#sed '/libphp5.so/a # grep PHP set php.ini file declare path\nPHPIniDir /usr/'
# sed '/DirectoryIndex /c index.php index.cgi index.pl index.php index.xhtml index.htm ' filename.txt
# now comment out all the stuff below up to the EOF

##automatic setting
##apache conf
sed -i '/DirectoryIndex index/c\DirectoryIndex index.php index.html index.cgi index.pl index.php index.xhtml index.htm' /usr/local/apache2/conf/httpd.conf


echo -e "\033[33;32m Setup Status Log File Save At $BUILD"
echo -e "\033[33;32m Login With http://yourip:$webport (default username:$weba,password:$webp)"

# HTTPD Apache VERSION
echo /usr/local/apache2/bin/httpd -v
#PHP VERSION CHECK
echo /usr/local/bin/php -v
#MYSQL VERSION CHECK
echo mysql -V
#BIND DNS VERSION CHECK
echo named -v
#CURL VERSION
echo curl -V
#OPEN SSL VERSION
echo openssl version

/etc/init.d/apache2 restart
systemctl restart proftpd
service named restart

date +"%r" >> $BUILD;/usr/local/apache2/bin/httpd -v >> $BUILD;openssl version >> $BUILD;
/usr/local/bin/php -v >> $BUILD;mysql -V >> $BUILD;named -v >> $BUILD;curl -V >> $BUILD;
