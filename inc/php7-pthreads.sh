#!/bin/bash

mkdir -p /etc/php7
mkdir -p /etc/php7/cli

git clone https://github.com/php/php-src.git -b PHP-7.0.17 --depth=1
cd php-src/ext
git clone https://github.com/krakjoe/pthreads -b master pthreads

cd ..

./buildconf --force

./configure --prefix=/etc/php7 --with-bz2 --with-zlib --enable-zip --disable-cgi \
   --enable-soap --enable-intl --with-mcrypt --with-openssl --with-readline --with-curl \
   --enable-ftp --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
   --enable-sockets --enable-pcntl --with-pspell --with-enchant --with-gettext \
   --with-gd --enable-exif --with-jpeg-dir --with-png-dir --with-freetype-dir --with-xsl \
   --enable-bcmath --enable-mbstring --enable-calendar --enable-simplexml --enable-json \
   --enable-hash --enable-session --enable-xml --enable-wddx --enable-opcache \
   --with-pcre-regex --with-config-file-path=/etc/php7/cli \
   --with-config-file-scan-dir=/etc/php7/etc --enable-cli --enable-maintainer-zts \
   --with-tsrm-pthreads --enable-debug --enable-fpm \
   --with-fpm-user=www-data --with-fpm-group=www-data

make && make install

chmod o+x /etc/php7/bin/phpize
chmod o+x /etc/php7/bin/php-config

cd ext/pthreads*
/etc/php7/bin/phpize

./configure --prefix=/etc/php7 --with-libdir=/lib/x86_64-linux-gnu --enable-pthreads=shared --with-php-config=/etc/php7/bin/php-config

make && make install

cd ../../
cp -r php.ini-development /etc/php7/cli/php.ini

cp php.ini-development /etc/php7/cli/php-cli.ini
echo "extension=pthreads.so" > /etc/php7/cli/php-cli.ini
echo "zend_extension=opcache.so" >> /etc/php7/cli/php.ini

ln --symbolic /etc/php7/bin/php /usr/bin/php

export USE_ZEND_ALLOC=0
