#   Config. DNS Required
# Add Entry in DNS (MX)
# Example 
# DNS(A) : mail.domain.com 00.00.00.00   (eg. [mail.Your Domain.tld] [Server IP])
# DNS(MX) : mail.domain.com 5 (eg. [mail.Your Domain.tld] [Peority:5]) 
#Example(BIND DNS):
#     mail.mobiletel.com. IN A 001.10.011.123
#     mail.mobiletel.com. IN MX 5 mail.mobiletel.com.


# INSTALL postfix(Mail Service/server)
yum -y install postfix

#
#
#           edit /etc/postfix/main.cf
#Then you need to edit /etc/postfix/main.cf customizing myhostname with your domain name and 
#add virtual_alias_maps and virtual_alias_domains parameters. Please also check that mynetworks is 
#configured exactly as I did, or you will make your mail server vulnerable to spam bots. 
#andreagrandi.it change to your domain in configuration setting
#You can see my complete configuration here:

myhostname = andreagrandi.it
smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
virtual_alias_domains = andreagrandi.it
virtual_alias_maps = hash:/etc/postfix/virtual
myorigin = /etc/mailname
mydestination = andreagrandi, localhost.localdomain, localhost
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all





#Add your email aliases

#Edit /etc/postfix/virtual file and add your aliases, one per line, like in this example:


info@andreagrandi.com youremail@gmail.com
sales@andreagrandi.com youremail@live.com






 postmap /etc/postfix/virtual
/etc/init.d/postfix reload



################  All Emails for to one Email Address ##################

#Create /etc/postfix/virtual-regexp with the following content:
/.+@.+/ email@gmail.com

#Edit /etc/postfix/main.cf and add regexp:/etc/postfix/virtual-regexp to the virtual_maps configuration. The end result might look like this in main.cf:

virtual_alias_maps = hash:/etc/postfix/virtual, regexp:/etc/postfix/virtual-regexp

#Build the mapfile by typing command:

postmap /etc/postfix/virtual-regexp

#This also requires a virtual.db to exist. If it doesn't create an empty file called virtual and run :

touch /etc/postfix/virtual && postmap /etc/postfix/virtual



##############   Generate Ssl cerificate ################
mkdir /etc/ssl/private/

#openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/certs/dovecot.pem -keyout /etc/ssl/private/dovecot.pem
#chmod o= /etc/ssl/private/dovecot.pem

openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/certs/postfix.pem -keyout /etc/ssl/private/postfix.pem
chmod o= /etc/ssl/private/postfix.pem
postconf -e smtpd_tls_cert_file=/etc/ssl/certs/postfix.pem
postconf -e smtpd_tls_key_file=/etc/ssl/private/postfix.pem
#service dovecot restart

service postfix restart
