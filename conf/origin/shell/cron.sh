if yum -y install cronie; then 
echo -e "\033[33;32m cronie For CronJOB Success";date +"%r" >> $LOG_FILE;echo "Success : Cronie for cronjob Install" >> $LOG_FILE
else
echo -e "\033[33;31m cronie For CronJoB Failed";date +"%r" >> $LOG_FILE;echo "Failed : cronie for CronJOB Install" >> $LOG_FILE
fi
chkconfig crond on
service crond start
service crond status
date +"%r" >> $BUILD;echo "Cronjob Program Complete" >> $LOG_FILE
