# PROFTP  Setup Program 
# DjAmol Group Pvt Ltd.
# WWW.DjAmol.Com
# djamolpatil@gmail.com

## Pro ftpd installation
rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
yum -y install proftpd proftpd-utils
cp -f $SCRIPTPATH/conf/proftpd.conf /etc/proftpd.conf
systemctl start proftpd.service
systemctl enable proftpd.service

## INSTALLation End proftpd
date +"%r" >> $BUILD;echo "PROFTPD Program Complete" >> $BUILD
