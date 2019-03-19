cd $SRC_OLD
FILE=csf.tgz
if [ ! -f $FILE ]
then
		echo -e "\033[33;34m file " $FILE " does not exist.";date +"%r" >> $LOG_FILE;echo "Status : Downloading $FILE" >> $LOG_FILE
		wget http://www.configserver.com/free/csf.tgz
else
		echo -e "\033[33;32m file " $FILE " exists.";date +"%r" >> $LOG_FILE;echo "Status : Exist $FILE" >> $LOG_FILE
fi

tar -xzf csf.tgz
cd csf
sh install.sh
date +"%r" >> $BUILD;echo "CSF Program Complete" >> $LOG_FILE
