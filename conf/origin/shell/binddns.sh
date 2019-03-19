if yum -y install bind; then 
echo -e "\033[33;32m yum -y BIND DNS Success "
date +"%r" >> $LOG_FILE;echo "Success : BIND DNS Install" >> $LOG_FILE
#chkconfig named on
chkconfig --level 35 named on
service named start

else
echo -e "\033[33;31m yum -y BIND DNS Failed";date +"%r" >> $LOG_FILE;echo "Failed : BIND DNS Install" >> $LOG_FILE
fi
