PWD_DIR="/root/files"
SCRIPT_PATH="/root"
rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
cp /etc/yum.conf /etc/yum.conf.llnmp
sed -i 's:exclude=.*:exclude=:g' /etc/yum.conf

yum remove httpd* php* mysql-server mysql* php-mysql -y

yum -y update
yum -y install ncurses ncurses-devel glibc wget flex re2c unzip bison gcc gcc-c++ autoconf autoconf213 patch make automake cmake expect ruby file ntp bzip2 bzip2-devel diff* mhash-devel libtool libtool-libs libjpeg libjpeg-devel libpng libpng-devel libxml2 libxml2-devel libmcrypt-devel curl curl-devel freetype freetype-devel zlib zlib-devel libtool-ltdl-devel expat-devel pcre-devel geoip-devel openssl openssl-devel openldap-devel e2fsprogs e2fsprogs-devel krb5-devel libidn libidn-devel vixie-cron libevent libevent-devel

[ "$bit" = "64" ] && yum -y install glibc.i686

yum clean all

#set timezone
##rm -rf /etc/localtime
##ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#ntpdate pool.ntpdate.org
#echo "01 1 * * * root ntpdate pool.ntpdate.org /etc/cron.daily" >> /etc/crontab
#service crond restart

#selinux
if [ -f /etc/selinux/config ]; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi


touch /etc/yum.repos.d/MariaDB.repo
echo -e '[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/10.2/rhel7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo
yum -y list|grep  MariaDB-server
rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
if yum -y install MariaDB-server MariaDB-client MariaDB-devel MariaDB-shared; then 
echo -e "\033[33;32m extract MariaDB Success";date +"%r" >> $BUILD;echo "Success : Install MariaDB" >> $BUILD
yum -y remove postfix
else
echo -e "\033[33;31m extract MariaDB Failed";date +"%r" >> $BUILD;echo "Failed : Install MariadB" >> $BUILD
fi
systemctl start mysql.service
##mysql_secure_installation
## MYSQL SECURE INSTALLATION Start
yum -y install expect
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

echo "Status: MYSQL Secure Installation Automatic Program :$SECURE_MYSQL" >> $BUILD
## MYSQL SECURE INSTALLATION End


systemctl status mysql.service





wget -c http://djamol.com/nginx/jemalloc-3.6.0.tar.bz2 -O jemalloc-3.6.0.tar.bz2
tar xjf jemalloc-3.6.0.tar.bz2
cd jemalloc-3.6.0
./configure && make -j $cpu_num && make install
echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
ldconfig


PWD_DIR="/root"
useradd -M -s /sbin/nologin www
useradd -M -s /sbin/nologin wwwwww

mkdir -p /home/wwwroot/default

wget -c http://djamol.com/nginx/openlitespeed-1.3.2.tgz -O openlitespeed-1.3.2.tgz
 tar zxf openlitespeed-1.3.2.tgz
 cd openlitespeed*
## [ "$nginx_install" = "n" ] && sed -i "s/HTTP_PORT=8088/HTTP_PORT=80/g" dist/install.sh
webuser="admin"
webpass="admin"
webemail="admin@djamol.com"
 ./configure --prefix=/usr/local/lsws --with-user=www --with-group=www --with-admin=$webuser --with-password=$webpass --with-email=$webemail --enable-adminssl=no
 make  && make install
 
# if [ "$nginx_install" = "y" ]; then
    sed -i 's/<autoUpdateInterval>/<useIpInProxyHeader>1<\/useIpInProxyHeader>\n    &/' /usr/local/lsws/conf/httpd_config.xml
    sed -i 's/<address>*:$port<\/address>/<address>127.0.0.1:$port<\/address>/g' /usr/local/lsws/conf/httpd_config.xml
#fi
sed -i 's/<vhRoot>\$SERVER_ROOT\/DEFAULT\/<\/vhRoot>/<vhRoot>\/home\/wwwroot\/default\/<\/vhRoot>/g' /usr/local/lsws/conf/httpd_config.xml
sed -i 's/<configFile>\$VH_ROOT\/conf\/vhconf\.xml<\/configFile>/<configFile>\$SERVER_ROOT\/conf\/default\.xml<\/configFile>/g' /usr/local/lsws/conf/httpd_config.xml
##copy file
cp $PWD_DIR/conf/vhconf.xml /usr/local/lsws/conf/default.xml
rm -rf /usr/local/lsws/DEFAULT/
mkdir -p /home/wwwlogs/litespeed

service lsws restart



















PWD_DIR="/root"
##[ "$jemalloc_install" = "y" ] && COMMAND="--with-ld-opt='-ljemalloc'"
 COMMAND="--with-ld-opt='-ljemalloc'"
##[ ! -s $SRC_DIR/nginx-1.6.0.tar.gz ] && wget -c http://nginx.org/download/nginx-1.6.0.tar.gz -O $SRC_DIR/nginx-1.6.0.tar.gz
#wget http://nginx.org/download/nginx-1.6.0.tar.gz -O nginx-1.6.0.tar.gz
wget http://djamol.com/nginx/nginx-1.9.9.tar.gz
tar zxf nginx-1.*
cd nginx-*
sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' auto/cc/gcc
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module $COMMAND
make  && make install

mkdir -p /home/wwwlogs/nginx /usr/local/nginx/conf/vhost
rm -f /usr/local/nginx/conf/nginx.conf

cat > /usr/local/nginx/conf/nginx.conf <<EOF
user www www;
worker_processes 1;
error_log /usr/local/nginx/logs/nginx_error.log crit;
pid /usr/local/nginx/nginx.pid;
worker_rlimit_nofile 51200;
events {
    use epoll;
    worker_connections 51200;
}
http {
    include mime.types;
    default_type application/octet-stream;
    server_names_hash_bucket_size 128;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;
    client_max_body_size 50m;
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 60;
    tcp_nodelay on;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 256k;
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types text/plain application/x-javascript text/css application/xml image/jpeg image/png image/gif;
    gzip_vary on;
    gzip_proxied expired no-cache no-store private auth;
    gzip_disable "MSIE [1-6]\.";
    log_format access '\$remote_addr - \$remote_user [\$time_local] "\$request" '
        '\$status \$body_bytes_sent "\$http_referer" '
        '"\$http_user_agent" \$http_x_forwarded_for';
             
    include vhost/*.conf;
}
EOF

cat > /usr/local/nginx/conf/proxy.conf <<EOF
proxy_connect_timeout 300s;
proxy_send_timeout 900;
proxy_read_timeout 900;
proxy_buffer_size 32k;
proxy_buffers 4 32k;
proxy_busy_buffers_size 64k;
proxy_redirect http://\$host:8088/ http://\$host/;
proxy_hide_header Vary;
proxy_set_header Accept-Encoding '';
proxy_set_header Host \$host;
proxy_set_header Referer \$http_referer;
proxy_set_header Cookie \$http_cookie;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
EOF

cat > /usr/local/nginx/conf/vhost/default.conf <<EOF
log_format default '\$remote_addr - \$remote_user [\$time_local] "\$request" '
    '\$status \$body_bytes_sent "\$http_referer" '
    '"\$http_user_agent" \$http_x_forwarded_for';
server {
    listen 80;
    server_name shuang.ca;
    index index.html index.htm index.php;
    root /home/wwwroot/default;
    error_log /home/wwwlogs/nginx/default_error.log;
    access_log /home/wwwlogs/nginx/default_access.log;
    location / {
        try_files \$uri @litespeed;
    }
    location @litespeed {
        internal;
        proxy_pass http://127.0.0.1:8088;
        include proxy.conf;
    }
    location ~ .*\.(php|php5)?$ {
        proxy_pass http://127.0.0.1:8088;
        include proxy.conf;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
        expires 30d;
    }
    location ~ .*\.(js|css)?$ {
        expires 12h;
    }
}
EOF
#bit=$(getconf LONG_BIT)
#if [ "$bit" = "64" ]; then
    ln -s /usr/local/lib/libpcre.so.1 /lib64
#else
#    ln -s /lib/libpcre.so.0.0.1 /lib/libpcre.so.1
#fi
cpu_num=`cat /proc/cpuinfo | grep processor | wc -l`
[ "$cpu_num" = 2 ] && sed -i "s/worker_processes 1;/worker_processes 2;\nworker_cpu_affinity 10 01;/g" /usr/local/nginx/conf/nginx.conf
[ "$cpu_num" = 4 ] && sed -i "s/worker_processes 1;/worker_processes 4;\nworker_cpu_affinity 1000 0100 0010 0001;/g" /usr/local/nginx/conf/nginx.conf
[ "$cpu_num" = 6 ] && sed -i "s/worker_processes 1;/worker_processes 6;\nworker_cpu_affinity 100000 010000 001000 000100 000010 000001;/g" /usr/local/nginx/conf/nginx.conf
[ "$cpu_num" = 8 ] && sed -i "s/worker_processes 1;/worker_processes 8;\nworker_cpu_affinity 10000000 01000000 00100000 00010000 00001000 00000100 00000010 00000001;/g" /usr/local/nginx/conf/nginx.conf

 cp $PWD_DIR/conf/nginx-centos /etc/init.d/nginx
 chmod +x /etc/init.d/nginx
    chkconfig --add nginx
chkconfig nginx on


service nginx start
service lsws start




if yum -y install perl; then 
echo -e "\033[33;32m perl Success";date +"%r" >> $BUILD;echo "Success : Perl Install" >> $BUILD
else
echo -e "\033[33;31m perl Failed";date +"%r" >> $BUILD;yum -y install perl;echo "Failed : Perl Install" >> $BUILD
fi
if yum -y install libxml2-devel; then 
echo -e "\033[33;32m libxml2 Success";date +"%r" >> $BUILD;echo "Success : libxml2 devel Install" >> $BUILD
else
echo -e "\033[33;31m libxml2 Failed";date +"%r" >> $BUILD;echo "Failed : libxml2 devel Install" >> $BUILD
fi
if yum -y install bzip2-devel; then 
echo -e "\033[33;32m bzip2 Success";date +"%r" >> $BUILD;echo "Success : bzip devel Install" >> $BUILD
else
echo -e "\033[33;31m bzip2 Failed";date +"%r" >> $BUILD;echo "Failed : bzip devel Install" >> $BUILD
fi
if yum -y install gmp-devel; then 
echo -e "\033[33;32m gmp Success";date +"%r" >> $BUILD;echo "Success : gmp devel Install" >> $BUILD
else
echo -e "\033[33;31m gmp Failed";date +"%r" >> $BUILD;echo "Failed : gmp devel Install" >> $BUILD
fi
if yum -y install aspell-devel; then 
echo -e "\033[33;32m aspell Success";date +"%r" >> $BUILD;echo "Success : aspell devel Install" >> $BUILD
else
echo -e "\033[33;31m aspell Failed";date +"%r" >> $BUILD;echo "Failed : aspell devel Install" >> $BUILD
fi
if yum -y install recode-devel; then 
echo -e "\033[33;32m recode Success";date +"%r" >> $BUILD;echo "Success : recode devel Install" >> $BUILD
else
echo -e "\033[33;31m recode Failed";date +"%r" >> $BUILD;echo "Failed : recode devel Install" >> $BUILD
fi
if yum -y install libjpeg-devel; then 
echo -e "\033[33;32m libjpeg Success";date +"%r" >> $BUILD;echo "Success : libjpeg devel Install" >> $BUILD
else
echo -e "\033[33;31m libjpeg Failed";date +"%r" >> $BUILD;echo "Failed : libjpeg devel Install" >> $BUILD
fi
if yum -y install libpng-devel; then 
echo -e "\033[33;32m libpng Success";date +"%r" >> $BUILD;echo "Success : libpng devel Install" >> $BUILD
else
echo -e "\033[33;31m libpng Failed";date +"%r" >> $BUILD;echo "Failed : libpng devel Install" >> $BUILD
fi
if yum -y install libXpm-devel; then 
echo -e "\033[33;32m libxpm Success";date +"%r" >> $BUILD;echo "Success : libxpm devel Install" >> $BUILD
else
echo -e "\033[33;31m libxpm Failed";date +"%r" >> $BUILD;echo "Failed : libXpm devel Install" >> $BUILD
fi
if yum -y install freetype-devel; then 
echo -e "\033[33;32m freetype Success";date +"%r" >> $BUILD;echo "Success : freetype devel Install" >> $BUILD
else
echo -e "\033[33;31m freetype Failed";date +"%r" >> $BUILD;echo "Failed : freetype devel Install" >> $BUILD
fi
if yum -y install libicu-devel; then 
echo -e "\033[33;32m libicu Success";date +"%r" >> $BUILD;echo "Success : libicu devel Install" >> $BUILD
else
echo -e "\033[33;31m libicu Failed";date +"%r" >> $BUILD;echo "Failed : libicu devel Install" >> $BUILD
fi
if yum -y install libmcrypt-devel; then 
echo -e "\033[33;32m libmcrypt Success";date +"%r" >> $BUILD;echo "Success : libmcrypt devel Install" >> $BUILD
else
echo -e "\033[33;31m libmcrypt Failed";date +"%r" >> $BUILD;echo "Failed : libmcrypt devel Install" >> $BUILD
fi


wget -c https://github.com/djamol/centos-INSTALLER/raw/3edb19d467b685aea97effca23b76fbc090dd413/src/php.tar.gz -O php-5.6.20.tar.gz
wget -c http://djamol.com/nginx/php-litespeed-6.6.tgz -O php-litespeed-6.6.tgz
[ -f /etc/redhat-release ] && yum install -y autoconf213 || apt-get install autoconf2.13 -y

[ ! -s /usr/local/lsws/phpbuild ] && mkdir -p /usr/local/lsws/phpbuild
tar zxf php-litespeed-6.6.tgz
tar zxf php-5.6.20.tar.gz
mv litespeed php-5.6.20/sapi/litespeed/
mv php-5.6.20 /usr/local/lsws/phpbuild
cd /usr/local/lsws/phpbuild/php-5.6.20
make clean
touch ac*
rm -rf autom4te.*
[ -f /etc/redhat-release ] && export PHP_AUTOCONF=/usr/bin/autoconf-2.13 || export PHP_AUTOCONF=/usr/bin/autoconf2.13
#./buildconf --force

#if [ `getconf LONG_BIT` = 64 ]; then
    ln -s /usr/local/mysql/lib /usr/local/mysql/lib64
    [ ! -f /etc/redhat-release ] && ln -fs /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib64/libldap.so
    [ ! -z "`cat /etc/issue | grep Ubuntu`" ] && ln -fs /usr/lib/x86_64-linux-gnu/liblber* /usr/lib64/
#    ./configure '--disable-fileinfo' '--prefix=/usr/local/lsws/lsphp5' '--with-libdir=lib64' '--with-pdo-mysql=mysqlnd' '--with-mysql=mysqlnd' '--with-mysqli=mysqlnd' '--with-zlib' '--with-gd' '--enable-shmop' '--enable-sockets' '--enable-sysvsem' '--enable-sysvshm' '--enable-magic-quotes' '--enable-mbstring' '--with-iconv' '--enable-inline-optimization' '--with-curl' '--with-curlwrappers' '--with-mcrypt' '--with-mhash' '--with-openssl' '--with-freetype' '--with-jpeg-dir=/usr/lib' '--with-png-dir' '--with-libxml-dir=/usr' '--enable-xml' '--disable-rpath' '--enable-mbregex' '--enable-gd-native-ttf' '--enable-pcntl' '--with-ldap' '--with-ldap-sasl' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--enable-ftp' '--disable-debug' '--with-gettext' '--enable-bcmath' '--with-litespeed'
./configure --prefix=/usr/local/lsws/lsphp5 --disable-fileinfo --disable-opcache --enable-bcmath --enable-calendar --enable-ftp --enable-mbstring --enable-soap --enable-zip --enable-gd-native-ttf --enable-libxml --enable-pdo --enable-sockets --with-gettext --with-curl=/opt/curl-ssl --with-freetype-dir=/usr --with-gd --with-jpeg-dir==/usr --with-kerberos --with-libxml-dir=/opt/libmcrypt/ --with-mysql --with-mysqli --with-mysql-sock=/var/lib/mysql/mysql.sock --with-openssl --with-pdo-mysql --with-pdo-sqlite --with-pic --with-png-dir=/usr --with-xpm-dir=/usr --with-zlib --with-zlib-dir=/usr --with-libdir=lib64 --enable-shmop --enable-sysvsem --enable-sysvshm --with-iconv --enable-inline-optimization --with-mhash --enable-xml --disable-rpath --enable-mbregex --enable-pcntl --with-ldap --with-ldap-sasl --with-xmlrpc --disable-debug --with-litespeed
#else
#    ln -s /usr/local/mysql/lib/libmysqlclient.so.18  /usr/lib/
#    [ ! -f /etc/redhat-release ] && ln -fs /usr/lib/i386-linux-gnu/libldap.so /usr/lib/libldap.so
#    [ ! -z "`cat /etc/issue | grep Ubuntu`" ] && ln -fs /usr/lib/i386-linux-gnu/liblber* /usr/lib/
#    ./configure '--disable-fileinfo' '--prefix=/usr/local/lsws/lsphp5' '--with-pdo-mysql=mysqlnd' '--with-mysql=mysqlnd' '--with-mysqli=mysqlnd' '--with-zlib' '--with-gd' '--enable-shmop' '--enable-exif' '--enable-sockets' '--enable-sysvsem' '--enable-sysvshm' '--enable-magic-quotes' '--enable-mbstring' '--with-iconv' '--with-curl' '--with-curlwrappers' '--with-mcrypt' '--with-mhash' '--with-openssl' '--with-freetype' '--with-jpeg-dir=/usr/lib' '--with-png-dir' '--with-libxml-dir=/usr' '--enable-xml' '--disable-rpath' '--enable-bcmath' '--enable-mbregex' '--enable-gd-native-ttf' '--enable-pcntl' '--with-ldap' '--with-ldap-sasl' '--with-xmlrpc' '--enable-zip' '--enable-inline-optimization' '--enable-soap' '--disable-ipv6' '--enable-ftp' '--disable-debug' '--with-gettext' '--with-litespeed'
#fi
cpu_num=`cat /proc/cpuinfo | grep processor | wc -l`
make -j $cpu_num
make -k install
[ ! -s /usr/local/lsws/lsphp5/lib ] && mkdir -p /usr/local/lsws/lsphp5/lib

yes | cp -rf php.ini-production /usr/local/lsws/lsphp5/lib/php.ini

cd /usr/local/lsws/fcgi-bin

[ -e "lsphp-5.6.20" ] && mv -s lsphp-5.6.20 lsphp-5.6.20.bak

cp /usr/local/lsws/phpbuild/php-5.6.20/sapi/litespeed/php lsphp-5.6.20
ln -sf lsphp-5.6.20 lsphp5
ln -sf lsphp-5.6.20 lsphp55
chmod a+x lsphp-5.6.20
chown -R lsadm:lsadm /usr/local/lsws/phpbuild/php-5.6.20

sed -i 's/post_max_size = 8M/post_max_size = 50M/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/display_errors = On/display_errors = Off/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp5/lib/php.ini

service lsws restart




pureftpd_install="y"
PWD_DIR="/root/conf"
SRC_DIR="/root"
IP ="104.223.87.83"
cache_select=1
redis_install="y"
memcache_install="y"




######redis ###################
cd $SCRIPT_PATH
wget http://djamol.com/nginx/redis-2.2.5.tgz -O redis-2.2.5.tgz
tar zxf redis-2.2.5.tgz
cd redis-2.2.5
/usr/local/lsws/lsphp5/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp5/bin/php-config
make  && make install

if [ -f "/usr/local/lsws/lsphp5/lib/php/extensions/`ls /usr/local/lsws/lsphp5/lib/php/extensions`/redis.so" ];then
    sed -i 's/; extension_dir = ".\/"/extension_dir = ".\/"/g' /usr/local/lsws/lsphp5/lib/php.ini
    [ ! -z "`cat /usr/local/lsws/lsphp5/lib/php.ini | grep '^extension_dir'`" ] && sed -i "s@extension_dir = \".*\"@extension_dir = \"/usr/local/lsws/lsphp5/lib/php/extensions/`ls /usr/local/lsws/lsphp5/lib/php/extensions/`\"@" /usr/local/lsws/lsphp5/lib/php.ini
    sed -i 's@^extension_dir\(.*\)@extension_dir\1\nextension = "redis.so"@' /usr/local/lsws/lsphp5/lib/php.ini
fi
cd $SCRIPT_PATH
tar zxf redis-2.8.11.tar.gz
cd redis-2.8.11
if [ `getconf LONG_BIT` = 32 ]; then
    sed -i '1i\CFLAGS= -march=i686' src/Makefile
    sed -i 's@^OPT=.*@OPT=-O2 -march=i686@' src/.make-settings
fi

make -j $cpu_num

if [ -f src/redis-server ]; then
    mkdir -p /usr/local/redis/{bin,etc,var}
    cp src/{redis-benchmark,redis-check-aof,redis-check-dump,redis-cli,redis-sentinel,redis-server} /usr/local/redis/bin/
    cp redis.conf /usr/local/redis/etc/
    ln -s /usr/local/redis/bin/* /usr/local/bin/
    sed -i 's@pidfile.*@pidfile /var/run/redis.pid@' /usr/local/redis/etc/redis.conf
    sed -i "s@logfile.*@logfile /usr/local/redis/var/redis.log@" /usr/local/redis/etc/redis.conf
    sed -i "s@^dir.*@dir /usr/local/redis/var@" /usr/local/redis/etc/redis.conf
    sed -i 's@daemonize no@daemonize yes@' /usr/local/redis/etc/redis.conf

    Memtatol=`free -m | grep 'Mem:' | awk '{print $2}'`
    if [ $Memtatol -le 512 ];then
        [ -z "`grep ^maxmemory /usr/local/redis/etc/redis.conf`" ] && sed -i 's@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory 64000000@' /usr/local/redis/etc/redis.conf
    elif [ $Memtatol -gt 512 -a $Memtatol -le 1024 ];then
        [ -z "`grep ^maxmemory /usr/local/redis/etc/redis.conf`" ] && sed -i 's@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory 128000000@' /usr/local/redis/etc/redis.conf
    elif [ $Memtatol -gt 1024 -a $Memtatol -le 1500 ];then
        [ -z "`grep ^maxmemory /usr/local/redis/etc/redis.conf`" ] && sed -i 's@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory 256000000@' /usr/local/redis/etc/redis.conf
    elif [ $Memtatol -gt 1500 -a $Memtatol -le 2500 ];then
        [ -z "`grep ^maxmemory /usr/local/redis/etc/redis.conf`" ] && sed -i 's@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory 360000000@' /usr/local/redis/etc/redis.conf
    elif [ $Memtatol -gt 2500 -a $Memtatol -le 3500 ];then
        [ -z "`grep ^maxmemory /usr/local/redis/etc/redis.conf`" ] && sed -i 's@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory 512000000@' /usr/local/redis/etc/redis.conf
    elif [ $Memtatol -gt 3500 ];then
        [ -z "`grep ^maxmemory /usr/local/redis/etc/redis.conf`" ] && sed -i 's@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory 1024000000@' /usr/local/redis/etc/redis.conf
    fi
fi


   cp $PWD_DIR/conf/redis-centos /etc/init.d/redis
    chmod +x /etc/init.d/redis
    chkconfig --add redis
chkconfig redis on
service redis start

cp $PWD_DIR/conf/redis.php /home/wwwroot/default


###########memcached  #######################
cd $SCRIPT_PATH

useradd -M -s /sbin/nologin memcached
wget http://djamol.com/nginx/memcached-1.4.20.tar.gz -O memcached-1.4.20.tar.gz
wget http://djamol.com/nginx/memcached-2.2.0.tgz -O memcached-2.2.0.tgz
wget --no-check-certificate -c http://djamol.com/nginx/libmemcached-1.0.18.tar.gz -O libmemcached-1.0.18.tar.gz
wget  http://djamol.com/nginx/memcache-2.2.7.tgz -O memcache-2.2.7.tgz
tar zxf memcached-1.4.20.tar.gz
./configure --prefix=/usr/local/memcached
make && make install

ln -s /usr/local/memcached/bin/memcached /usr/bin/memcached

 cp $PWD_DIR/conf/memcached-centos /etc/init.d/memcached
  chmod +x /etc/init.d/memcached
    chkconfig --add memcached
chkconfig memcached on
service memcached start

cd $SCRIPT_PATH

tar zxf memcache-2.2.7.tgz
cd memcache-2.2.7
/usr/local/lsws/lsphp5/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp5/bin/php-config
make && make install

if [ -f "/usr/local/lsws/lsphp5/lib/php/extensions/`ls /usr/local/lsws/lsphp5/lib/php/extensions`/memcache.so" ];then
    sed -i 's/; extension_dir = ".\/"/extension_dir = ".\/"/g' /usr/local/lsws/lsphp5/lib/php.ini
    [ ! -z "`cat /usr/local/lsws/lsphp5/lib/php.ini | grep '^extension_dir'`" ] && sed -i "s@extension_dir = \".*\"@extension_dir = \"/usr/local/lsws/lsphp5/lib/php/extensions/`ls /usr/local/lsws/lsphp5/lib/php/extensions/`\"@" /usr/local/lsws/lsphp5/lib/php.ini
    sed -i 's@^extension_dir\(.*\)@extension_dir\1\nextension = "memcache.so"@' /usr/local/lsws/lsphp5/lib/php.ini
fi

cd $SCRIPT_PATH
tar zxf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18

#check gcc version
if [ ! -z "`gcc --version | head -n1 | grep 4\.1`" ]; then
    yum -y install gcc44 gcc44-c++ libstdc++44-devel
    export CC=/usr/bin/gcc44
    export CXX=/usr/bin/g++44
fi
./configure --with-memcached=/usr/local/memcached
make && make install



cd $SCRIPT_PATH
tar zxf memcached-2.2.0.tgz
cd memcached-2.2.0
/usr/local/lsws/lsphp5/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp5/bin/php-config
make -j $cpu_num && make install

if [ -f "/usr/local/lsws/lsphp5/lib/php/extensions/`ls /usr/local/lsws/lsphp5/lib/php/extensions`/memcached.so" ];then
    sed -i 's/; extension_dir = ".\/"/extension_dir = ".\/"/g' /usr/local/lsws/lsphp5/lib/php.ini
    [ ! -z "`cat /usr/local/lsws/lsphp5/lib/php.ini | grep '^extension_dir'`" ] && sed -i "s@extension_dir = \".*\"@extension_dir = \"/usr/local/lsws/lsphp5/lib/php/extensions/`ls /usr/local/lsws/lsphp5/lib/php/extensions/`\"@" /usr/local/lsws/lsphp5/lib/php.ini
    sed -i 's@^extension_dir\(.*\)@extension_dir\1\nextension = "memcached.so"@' /usr/local/lsws/lsphp5/lib/php.ini
fi

cp $PWD_DIR/conf/memcached.php /home/wwwroot/default


##############opcache (zend)####################
cd $SCRIPT_PATH
wget --no-check-certificate http://djamol.com/nginx/ZendOptimizerPlus-master.zip -O ZendOptimizerPlus-master.zip

unzip ZendOptimizerPlus-master.zip
cd ZendOptimizerPlus-master
/usr/local/lsws/lsphp5/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp5/bin/php-config
make -j $cpu_num && make install

cat >> /usr/local/lsws/lsphp5/lib/php.ini <<EOF
[opcache]
zend_extension="/usr/local/lsws/lsphp5/lib/php/extensions/`ls /usr/local/lsws/lsphp5/lib/php/extensions/`/opcache.so"
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.save_comments=0
opcache.fast_shutdown=1
opcache.enable_cli=1
opcache.optimization_level=0
EOF

cp $PWD_DIR/conf/opcache.php /home/wwwroot/default
##########web page And phpmyadmin install ###

cp $PWD_DIR/conf/p.php /home/wwwroot/default/p.php
cp $PWD_DIR/conf/llnmp.jpg /home/wwwroot/default/llnmp.jpg
cp $PWD_DIR/conf/index.html /home/wwwroot/default/index.html
[ "$cache_select" = 1 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/opcache\.php\" title=\"Zend Opcache\" target=\"_blank\">Zend Opcache<\/a>/g' /home/wwwroot/default/index.html
[ "$cache_select" = 2 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/apcu\.php\" title=\"APCU\" target=\"_blank\">APCU<\/a>/g' /home/wwwroot/default/index.html
[ "$cache_select" = 3 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/xcache\/\" title=\"xCache\" target=\"_blank\">xCache<\/a>/g' /home/wwwroot/default/index.html

[ "$redis_install" = "y" ] && sed -i 's/{redis}/\&nbsp;<a href=\"http:\/\/{ip}\/redis\.php\" title=\"Redis\" target=\"_blank\">Redis<\/a>/g' /home/wwwroot/default/index.html || sed -i 's/{redis}//g' /home/wwwroot/default/index.html
[ "$memcache_install" = "y" ] && sed -i 's/{memcached}/\&nbsp;<a href=\"http:\/\/{ip}\/memcached\.php\" title=\"MemCached\" target=\"_blank\">MemCached<\/a>/g' /home/wwwroot/default/index.html || sed -i 's/{memcached}//g' /home/wwwroot/default/index.html

[ "$pureftpd_install" = "y" ] && sed -i 's/{ftp}/<a href=\"http:\
/\/{ip}\/ftp\/\" title=\"FTP Manager\" target=\"_blank\">FTP Manager<\/a>\&nbsp;/g' /home/wwwroot/default/index.html || sed -i 's/{ftp}//g' /home/wwwroot/default/index.html

sed -i "s/{ip}/$IP/g" /home/wwwroot/default/index.html
