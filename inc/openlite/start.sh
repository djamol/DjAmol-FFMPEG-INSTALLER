SRC_Source="/src"
PWD_DIR="/root"
cpu_num=`cat /proc/cpuinfo | grep processor | wc -l`

 sh jemalloc.sh 2>&1 | tee -a openl-jemalloc.txt
 sh openlite.sh 2>&1 | tee -a openl-openlite.txt
 sh nginx.sh 2>&1 | tee -a openl-jemalloc.txt
 sh php.sh 2>&1 | tee -a openl-php.txt
 sh ext-php-redis.sh 2>&1 | tee -a openl-redis.txt
 sh ext-php-mem.sh 2>&1 | tee -a openl-mem.txt
 sh ext-php-zendOPcache.sh 2>&1 | tee -a openl-zendOPcache.txt
 sh end.sh 2>&1 | tee -a openl-end.txt
