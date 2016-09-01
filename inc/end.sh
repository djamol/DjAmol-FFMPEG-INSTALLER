/etc/init.d/apache2 restart
systemctl restart proftpd
service named restart


date +"%r" >> $BUILD;/usr/local/apache2/bin/httpd -v >> $BUILD;openssl version >> $BUILD;
/usr/local/bin/php -v >> $BUILD;mysql -V >> $BUILD;named -v >> $BUILD;curl -V >> $BUILD;


echo -e "\033[33;34m OPENLSSL Testing";
if openssl version; then 
echo -e "\033[33;32m OPENLSSL is Installed";
else
echo -e "\033[33;31m OPENLSSL is Not Install (Try Manually Install) "
fi


echo -e "\033[33;34m CURL Testing";
if curl -V; then 
echo -e "\033[33;32m CURL is Installed";
else
echo -e "\033[33;31m CURL is Not Install (Try Manually Install) "
fi


echo -e "\033[33;34m MariaDB/Mysql Testing";
if mysql -V; then 
echo -e "\033[33;32m Mariadb is Installed";
else
echo -e "\033[33;31m MariaDB is Not Install (Try Manually Install) "
fi

echo -e "\033[33;34m BIND DNS Testing";
if named -v; then 
echo -e "\033[33;32m BIND DNS is Installed";
else
echo -e "\033[33;31m BIND DNS is Not Install (Try Manually Install) "
fi


echo -e "\033[33;34m Apache Testing";
if /usr/local/apache2/bin/httpd -v; then 
echo -e "\033[33;32m Apache is Installed";
else
echo -e "\033[33;31m Apache is Not Install (Try Manually Install or Restart Program) "
fi

echo -e "\033[33;34m PHP 5 Testing";
if /usr/local/bin/php -v; then 
echo -e "\033[33;32m PHP is Installed";
else
echo -e "\033[33;31m PHP is Not Install (Try Manually Install or Restart Program) "
fi
