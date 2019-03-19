if yum -y install bind; then 
echo -e "\033[33;32m yum -y BIND DNS Success "
date +"%r" >> $LOG_FILE;echo "Success : BIND DNS Install" >> $LOG_FILE
#chkconfig named on
chkconfig --level 35 named on
service named start

else
echo -e "\033[33;31m yum -y BIND DNS Failed";date +"%r" >> $LOG_FILE;echo "Failed : BIND DNS Install" >> $LOG_FILE
fi

sed -i '/listen-on port/c\	listen-on port 53 { any; };' /etc/named.conf
sed -i '/allow-query/c\	allow-query     { any; };' /etc/named.conf
touch /etc/named.main.zones; chmod 640 /etc/named.main.zones; chown -R root:named /etc/named.main.zones
echo -e 'include "/etc/named.main.zones";' >> /etc/named.conf
echo -e '$TTL 14400\n@      86400	IN      SOA     ns1.'$MAINDOMAIN'. djamolpatil.gmail.com. (\n		2016033001	; serial, todays date+todays\n		3600		; refresh, seconds\n		7200		; retry, seconds\n		1209600		; expire, seconds\n		86400 )		; minimum, seconds\n\nns1.'$MAINDOMAIN'. 86400 IN NS ns1.'$MAINDOMAIN'.\nns1.'$MAINDOMAIN'. 86400 IN NS ns2.'$MAINDOMAIN'.\n\n\nns1.'$MAINDOMAIN'. IN A '$MAINIP'\n\nns1.'$MAINDOMAIN'. IN MX 0 ns1.'$MAINDOMAIN'.\n\nmail IN CNAME ns1.'$MAINDOMAIN'.\nwww IN CNAME ns1.'$MAINDOMAIN'.\nftp IN CNAME ns1.'$MAINDOMAIN'.\n' >> /var/named/ns1.$MAINDOMAIN.db
echo -e '$TTL 14400\n@      86400	IN      SOA     ns1.'$MAINDOMAIN'. djamolpatil.gmail.com. (\n		2016033001	; serial, todays date+todays\n		3600		; refresh, seconds\n		7200		; retry, seconds\n		1209600		; expire, seconds\n		86400 )		; minimum, seconds\n\nns2.'$MAINDOMAIN'. 86400 IN NS ns1.'$MAINDOMAIN'.\nns2.'$MAINDOMAIN'. 86400 IN NS ns2.'$MAINDOMAIN'.\n\n\nns2.'$MAINDOMAIN'. IN A '$MAINIP'\n\nns2.'$MAINDOMAIN'. IN MX 0 ns2.'$MAINDOMAIN'.\n\nmail IN CNAME ns2.'$MAINDOMAIN'.\nwww IN CNAME ns2.'$MAINDOMAIN'.\nftp IN CNAME ns2.'$MAINDOMAIN'.\n' >> /var/named/ns2.$MAINDOMAIN.db
echo -e '$TTL 14400\n@      86400	IN      SOA     ns1.'$MAINDOMAIN'. djamolpatil.gmail.com. (\n		2016033003	; serial, todays date+todays\n		3600		; refresh, seconds\n		7200		; retry, seconds\n		1209600		; expire, seconds\n		86400 )		; minimum, seconds\n\n'$MAINDOMAIN'. 86400 IN NS ns1.'$MAINDOMAIN'.\n'$MAINDOMAIN'. 86400 IN NS ns2.'$MAINDOMAIN'.\n\n\n'$MAINDOMAIN'. IN A '$MAINIP'\nmail.'$MAINDOMAIN'. IN A '$MAINIP'\nns1.'$MAINDOMAIN'. IN A '$MAINIP'\nns2.'$MAINDOMAIN'. IN A '$MAINIP'\n'$MAINDOMAIN'. IN MX 5 '$MAINDOMAIN'.\n\n\nwww IN CNAME '$MAINDOMAIN'.\nftp IN CNAME '$MAINDOMAIN'.\nmobile IN CNAME '$MAINDOMAIN'.\nwap IN CNAME '$MAINDOMAIN'.\n' >> /var/named/$MAINDOMAIN.db
echo -e 'zone "ns1.'$MAINDOMAIN'" {	type master;	file "/var/named/ns1.'$MAINDOMAIN'.db";};\nzone "ns2.'$MAINDOMAIN'" {	type master;	file "/var/named/ns2.'$MAINDOMAIN'.db";};\nzone "'$MAINDOMAIN'" {	type master;	file "/var/named/'$MAINDOMAIN'.db";};' >> /etc/named.main.zones
