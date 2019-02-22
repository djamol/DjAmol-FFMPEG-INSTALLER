rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
cp /etc/yum.conf /etc/yum.conf.llnmp
sed -i 's:exclude=.*:exclude=:g' /etc/yum.conf

yum remove httpd* php* mysql-server mysql* php-mysql -y

yum -y update
yum -y install ncurses ncurses-devel glibc wget flex re2c unzip bison gcc gcc-c++ autoconf autoconf213 patch make automake cmake expect ruby file ntp bzip2 bzip2-devel diff* mhash-devel libtool libtool-libs libjpeg libjpeg-devel libpng libpng-devel libxml2 libxml2-devel libmcrypt-devel curl curl-devel freetype freetype-devel zlib zlib-devel libtool-ltdl-devel expat-devel pcre-devel geoip-devel openssl openssl-devel openldap-devel e2fsprogs e2fsprogs-devel krb5-devel libidn libidn-devel vixie-cron libevent libevent-devel

[ "$bit" = "64" ] && yum -y install glibc.i686

yum clean all

#set timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ntpdate pool.ntpdate.org
echo "01 1 * * * root ntpdate pool.ntpdate.org /etc/cron.daily" >> /etc/crontab
service crond restart

#selinux
if [ -f /etc/selinux/config ]; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi



#####################
[ ! -f $SRC_DIR/jemalloc-3.6.0.tar.bz2 ] && wget -c http://www.canonware.com/jemalloc-3.6.0.tar.bz2 -O $SRC_DIR/jemalloc-3.6.0.tar.bz2

cd $SRC_DIR
tar xjf jemalloc-3.6.0.tar.bz2
cd jemalloc-3.6.0
./configure && make -j $cpu_num && make install
echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
ldconfig


#######################
useradd -M -s /sbin/nologin mysql
rm -f /etc/my.cnf
mkdir -p /data/mysql
COMMAND="-DCMAKE_EXE_LINKER_FLAGS='-ljemalloc'"

##[ ! -f $SRC_DIR/mariadb-10.0.11.tar.gz ] && wget -c http://ftp.osuosl.org/pub/mariadb/mariadb-10.0.11/source/mariadb-10.0.11.tar.gz -O $SRC_DIR/mariadb-10.0.11.tar.gz

cd $SRC_DIR
tar zxf mariadb-10.0.11.tar.gz
cd mariadb-10.0.11
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/data/mysql \
-DWITH_ARIA_STORAGE_ENGINE=1 \
-DWITH_XTRADB_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATEDX_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EMBEDDED_SERVER=OFF \
$COMMAND
make  && make install

#####Litespeed Open###########
useradd -M -s /sbin/nologin wwwwww
mkdir -p /home/wwwroot/default

wget -c http://open.litespeedtech.com/packages/openlitespeed-1.3.2.tgz -O openlitespeed-1.3.2.tgz
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
###########nginx############
##[ "$jemalloc_install" = "y" ] && COMMAND="--with-ld-opt='-ljemalloc'"
 COMMAND="--with-ld-opt='-ljemalloc'"
##[ ! -s $SRC_DIR/nginx-1.6.0.tar.gz ] && wget -c http://nginx.org/download/nginx-1.6.0.tar.gz -O $SRC_DIR/nginx-1.6.0.tar.gz
#wget http://nginx.org/download/nginx-1.6.0.tar.gz -O nginx-1.6.0.tar.gz
wget http://nginx.org/download/nginx-1.9.9.tar.gz
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
############php 5.3##############
wget -c http://www.php.net/distributions/php-5.3.28.tar.gz -O php-5.3.28.tar.gz
wget -c http://www.litespeedtech.com/packages/lsapi/php-litespeed-6.6.tgz -O php-litespeed-6.6.tgz
[ -f /etc/redhat-release ] && yum install -y autoconf213 || apt-get install autoconf2.13 -y

[ ! -s /usr/local/lsws/phpbuild ] && mkdir -p /usr/local/lsws/phpbuild
tar zxf php-litespeed-6.6.tgz
tar zxf php-5.3.28.tar.gz
mv litespeed php-5.3.28/sapi/litespeed/
mv php-5.3.28 /usr/local/lsws/phpbuild
cd /usr/local/lsws/phpbuild/php-5.3.28
make clean
touch ac*
rm -rf autom4te.*
[ -f /etc/redhat-release ] && export PHP_AUTOCONF=/usr/bin/autoconf-2.13 || export PHP_AUTOCONF=/usr/bin/autoconf2.13
./buildconf --force

#if [ `getconf LONG_BIT` = 64 ]; then
    ln -s /usr/local/mysql/lib /usr/local/mysql/lib64
    [ ! -f /etc/redhat-release ] && ln -fs /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib64/libldap.so
    [ ! -z "`cat /etc/issue | grep Ubuntu`" ] && ln -fs /usr/lib/x86_64-linux-gnu/liblber* /usr/lib64/
    ./configure '--disable-fileinfo' '--prefix=/usr/local/lsws/lsphp5' '--with-libdir=lib64' '--with-pdo-mysql=mysqlnd' '--with-mysql=mysqlnd' '--with-mysqli=mysqlnd' '--with-zlib' '--with-gd' '--enable-shmop' '--enable-sockets' '--enable-sysvsem' '--enable-sysvshm' '--enable-magic-quotes' '--enable-mbstring' '--with-iconv' '--enable-inline-optimization' '--with-curl' '--with-curlwrappers' '--with-mcrypt' '--with-mhash' '--with-openssl' '--with-freetype' '--with-jpeg-dir=/usr/lib' '--with-png-dir' '--with-libxml-dir=/usr' '--enable-xml' '--disable-rpath' '--enable-mbregex' '--enable-gd-native-ttf' '--enable-pcntl' '--with-ldap' '--with-ldap-sasl' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--enable-ftp' '--disable-debug' '--with-gettext' '--enable-bcmath' '--with-litespeed'
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

yes | cp -rf /usr/local/lsws/phpbuild/php-5.3.28/php.ini-production /usr/local/lsws/lsphp5/lib/php.ini

cd /usr/local/lsws/fcgi-bin

[ -e "lsphp-5.3.28" ] && mv -s lsphp-5.3.28 lsphp-5.3.28.bak

cp /usr/local/lsws/phpbuild/php-5.3.28/sapi/litespeed/php lsphp-5.3.28
ln -sf lsphp-5.3.28 lsphp5
ln -sf lsphp-5.3.28 lsphp55
chmod a+x lsphp-5.3.28
chown -R lsadm:lsadm /usr/local/lsws/phpbuild/php-5.3.28

sed -i 's/post_max_size = 8M/post_max_size = 50M/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/display_errors = On/display_errors = Off/g' /usr/local/lsws/lsphp5/lib/php.ini
sed -i 's/expose_php = On/expose_php = Off/g' /usr/local/lsws/lsphp5/lib/php.ini

service lsws restart


######redis ###################
 wget http://download.redis.io/releases/redis-2.8.11.tar.gz -O redis-2.8.11.tar.gz
wget http://pecl.php.net/get/redis-2.2.5.tgz -O redis-2.2.5.tgz
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
cd ~
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
useradd -M -s /sbin/nologin memcached
wget http://www.memcached.org/files/memcached-1.4.20.tar.gz -O memcached-1.4.20.tar.gz
wget http://pecl.php.net/get/memcached-2.2.0.tgz -O memcached-2.2.0.tgz
wget --no-check-certificate -c https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz -O libmemcached-1.0.18.tar.gz
wget  http://pecl.php.net/get/memcache-2.2.7.tgz -O memcache-2.2.7.tgz
tar zxf memcached-1.4.20.tar.gz
./configure --prefix=/usr/local/memcached
make && make install

ln -s /usr/local/memcached/bin/memcached /usr/bin/memcached

 cp $PWD_DIR/conf/memcached-centos /etc/init.d/memcached
  chmod +x /etc/init.d/memcached
    chkconfig --add memcached
chkconfig memcached on
service memcached start

cd ~
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

cd ~
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



cd ~
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
wget --no-check-certificate https://github.com/zendtech/ZendOptimizerPlus/archive/master.zip -O ZendOptimizerPlus-master.zip

cd ~
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
pureftpd_install="y"
PWD_DIR="~"
SRC_DIR="~"
IP ="104.223.87.83"

cp $PWD_DIR/conf/p.php /home/wwwroot/default/p.php
cp $PWD_DIR/conf/llnmp.jpg /home/wwwroot/default/llnmp.jpg
cp $PWD_DIR/conf/index.html /home/wwwroot/default/index.html

[ "$cache_select" = 1 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/opcache\.php\" title=\"Zend Opcache\" target=\"_blank\">Zend Opcache<\/a>/g' /home/wwwroot/default/index.html
[ "$cache_select" = 2 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/apcu\.php\" title=\"APCU\" target=\"_blank\">APCU<\/a>/g' /home/wwwroot/default/index.html
[ "$cache_select" = 3 ] && sed -i 's/{cache}/\&nbsp;<a href=\"http:\/\/{ip}\/xcache\/\" title=\"xCache\" target=\"_blank\">xCache<\/a>/g' /home/wwwroot/default/index.html

[ "$redis_install" = "y" ] && sed -i 's/{redis}/\&nbsp;<a href=\"http:\/\/{ip}\/redis\.php\" title=\"Redis\" target=\"_blank\">Redis<\/a>/g' /home/wwwroot/default/index.html || sed -i 's/{redis}//g' /home/wwwroot/default/index.html
[ "$memcache_install" = "y" ] && sed -i 's/{memcached}/\&nbsp;<a href=\"http:\/\/{ip}\/memcached\.php\" title=\"MemCached\" target=\"_blank\">MemCached<\/a>/g' /home/wwwroot/default/index.html || sed -i 's/{memcached}//g' /home/wwwroot/default/index.html

[ "$pureftpd_install" = "y" ] && sed -i 's/{ftp}/<a href=\"http:\/\/{ip}\/ftp\/\" title=\"FTP Manager\" target=\"_blank\">FTP Manager<\/a>\&nbsp;/g' /home/wwwroot/default/index.html || sed -i 's/{ftp}//g' /home/wwwroot/default/index.html

sed -i "s/{ip}/$IP/g" /home/wwwroot/default/index.html


wget  https://files.phpmyadmin.net/phpMyAdmin/4.1.14/phpMyAdmin-4.1.14-english.tar.gz -O phpMyAdmin-4.1.14-english.tar.gz
cd ~
tar zxf phpMyAdmin-4.1.14-english.tar.gz
mv phpMyAdmin-4.1.14-english /home/wwwroot/default/phpmyadmin/

chown -R www:www /home/wwwroot/

#####Litespeed Premium###########
useradd -M -s /sbin/nologin www
mkdir -p /home/wwwroot/default

wget http://www.litespeedtech.com/packages/4.0/lsws-4.2.12-ent-x86_64-linux.tar.gz
tar -zxvf lsws*
cd lsws-4.2.12
./install.sh
##port=8088 || port=80
port=80
PWD_DIR=`pwd`
webuser="admin"
webpass="admin"
webemail="admin@djamol.com"
expect -c "
spawn ./install.sh
expect \"license?\" { send \"Yes\r\" }
expect \"Destination\" { send \"\r\" }
expect \"User name\" { send \"$webuser\r\" }
expect \"Password:\" { send \"$webpass\r\" }
expect \"Retype password:\" { send \"$webpass\r\" }
expect \"Email addresses\" { send \"$webemail\r\" }
expect \"User\" { send \"www\r\" }
expect \"Group\" { send \"www\r\" }
expect \"HTTP port\" { send \"$port\r\" }
expect \"Admin HTTP port\" { send \"\r\" }
expect \"Setup up PHP\" { send \"Y\r\" }
expect \"separated list)\" { send \"\r\" }
expect \"Add-on module\" { send \"N\r\" }
expect \"server restarts\" { send \"Y\r\" }
expect \"right now\" { send \"Y\r\" }
"

#if [ "$nginx_install" = "y" ]; then
    sed -i 's/<autoUpdateInterval>/<useIpInProxyHeader>1<\/useIpInProxyHeader>\n    &/' /usr/local/lsws/conf/httpd_config.xml
    sed -i 's/<address>*:$port<\/address>/<address>127.0.0.1:$port<\/address>/g' /usr/local/lsws/conf/httpd_config.xml
#fi

sed -i 's/<vhRoot>\$SERVER_ROOT\/DEFAULT\/<\/vhRoot>/<vhRoot>\/home\/wwwroot\/default\/<\/vhRoot>/g' /usr/local/lsws/conf/httpd_config.xml
sed -i 's/<configFile>\$VH_ROOT\/conf\/vhconf\.xml<\/configFile>/<configFile>\$SERVER_ROOT\/conf\/default\.xml<\/configFile>/g' /usr/local/lsws/conf/httpd_config.xml

cp $PWD_DIR/conf/vhconf.xml /usr/local/lsws/conf/default.xml
rm -rf /usr/local/lsws/DEFAULT/
mkdir -p /home/wwwlogs/litespeed
chown -R lsadm:lsadm /usr/local/lsws/admin/

service lsws restart


####################
COMMAND="--with-ld-opt='-ljemalloc'"
wget -c http://nginx.org/download/nginx-1.6.0.tar.gz -O $SRC_DIR/nginx-1.6.0.tar.gz
tar zxf nginx-1.6.0.tar.gz
cd nginx-1.6.0
