dstring="test,POWer,TODAY, Fres styel,netwo.in"
IFS=', ' read -r -a array <<< "$dstring"
for element in "${array[@]}"
do
    echo -e '<VirtualHost '$element':80>\nServerName '$element'\nServerAlias www.'$element'\nDocumentRoot /home/www/domain/'$element'\nServerAdmin webmaster@djamol.com\n</VirtualHost>' >> /usr/local/apache2/conf/httpd.conf
    echo "Domain Added :$element (Directory:/home/www/domain/$element)"
done
