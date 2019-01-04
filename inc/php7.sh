wget http://am1.php.net/get/php-7.1.25.tar.gz/from/this/mirror;
mkdir -p /usr/local/php7
mkdir -p /usr/local/php7/cli
yum -y install libxslt-devel;
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

./configure --prefix=/usr/local/php7 --with-apxs2=/usr/local/apache2/bin/apxs --with-freetype-dir=/usr --disable-short-tags --enable-xml --enable-cli -with-openssl=/usr/local/ssl --with-pcre-regex=/usr/local/pcre  --with-zlib --with-zlib-dir=/usr --enable-bcmath --with-bz2 --with-curl=/opt/curl-ssl --enable-exif --with-gd --enable-intl --with-mysqli --enable-pcntl --with-pdo-mysql --enable-soap --enable-sockets --with-xmlrpc --enable-zip  --with-jpeg-dir --with-png-dir --enable-json --enable-hash --enable-mbstring --with-mcrypt --enable-libxml --with-libxml-dir=/opt/libmcrypt/ --enable-ctype --enable-calendar --enable-dom --enable-fileinfo --with-mhash  --enable-opcache --enable-phar --enable-simplexml --with-xsl --with-pear --with-config-file-path=/usr/local/php7/cli
make
make install
chmod o+x /usr/local/php7/bin/phpize
chmod o+x /usr/local/php7/bin/php-config
cp -r php.ini-development /usr/local/php7/cli/php.ini
cp php.ini-development /usr/local/php7/cli/php-cli.ini
ln --symbolic /usr/local/php7/bin/php /usr/bin/php
#httpd.conf -> #LoadModule php7_module modules/libphp7.so <IfModule php7_module> AddType x-httpd-php .php AddType application/x-httpd-php-source .phps SetHandler application/x-httpd-php </IfModule>

