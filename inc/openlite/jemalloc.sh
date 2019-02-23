#####  Jemalloc #####
# sh centos.sh 2>&1 | tee -a mylog.txt
cd $SRC_Source
wget -c http://djamol.com/nginx/jemalloc-3.6.0.tar.bz2 -O jemalloc-3.6.0.tar.bz2

cd $SRC_Source
tar xjf jemalloc-3.6.0.tar.bz2
cd jemalloc-3.6.0
./configure && make -j $cpu_num && make install
echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
ldconfig
