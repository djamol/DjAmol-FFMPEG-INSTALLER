##############################start server

mkdir /home
mkdir /home/www
touch /home/www/index.html
cp $PWD_DIR/conf/vhost.sh $SRC_Sourcevhost.sh
chmod +x $SRC_Sourcevhost.sh

cp $PWD_DIR/conf/p.php /home/www/p.php
cp $PWD_DIR/conf/llnmp.jpg /home/www/llnmp.jpg
cp $PWD_DIR/conf/index.html /home/www/index.html
cache_select="1"
[ "$cache_select" = 1 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/opcache\.php\" title=\"Zend Opcache\" target=\"_blank\">Zend Opcache<\/a>/g' /home/www/index.html
[ "$cache_select" = 2 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/apcu\.php\" title=\"APCU\" target=\"_blank\">APCU<\/a>/g' /home/www/index.html
[ "$cache_select" = 3 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/xcache\/\" title=\"xCache\" target=\"_blank\">xCache<\/a>/g' /home/www/index.html
redis_install="y"
memcache_install="y"
pureftpd_install="y"
[ "$redis_install" = "y" ] && sed -i 's/{redis}/\&nbsp;<a href=\"http:\/\/{ip}\/redis\.php\" title=\"Redis\" target=\"_blank\">Redis<\/a>/g' /home/www/index.html || sed -i 's/{redis}//g' /home/www/index.html
[ "$memcache_install" = "y" ] && sed -i 's/{memcached}/\&nbsp;<a href=\"http:\/\/{ip}\/memcached\.php\" title=\"MemCached\" target=\"_blank\">MemCached<\/a>/g' /home/www/index.html || sed -i 's/{memcached}//g' /home/www/index.html

[ "$pureftpd_install" = "y" ] && sed -i 's/{ftp}/<a href=\"http:\/\/{ip}\/ftp\/\" title=\"FTP Manager\" target=\"_blank\">FTP Manager<\/a>\&nbsp;/g' /home/www/index.html || sed -i 's/{ftp}//g' /home/www/index.html

sed -i "s/{ip}/$IP/g" /home/www/index.html
#check litespeed
[ -s /usr/local/lsws ] && service lsws restart
[ -s /usr/local/nginx ] && service nginx restart
[ -s /usr/local/mysql ] && service mysqld restart
[ -s /usr/local/redis ] && service redis restart
[ -s /usr/local/memcached ] && service memcached restart
[ -s /usr/local/pureftpd ] && service pureftpd restart
