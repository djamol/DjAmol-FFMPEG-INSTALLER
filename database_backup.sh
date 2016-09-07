#Structure With Data Backup
DATABASE_LIST=$(mysql -NBe 'show schemas' | grep -wv 'mysql\|personnel\|buildings\|information_schema\|performance_schema');echo $DATABASE_LIST;mysqldump --databases $DATABASE_LIST > home/www/bk.sql


#Structure only backup
DATABASE_LIST=$(mysql -NBe 'show schemas' | grep -wv 'mysql\|personnel\|buildings\|information_schema\|performance_schema');echo $DATABASE_LIST;mysqldump --databases $DATABASE_LIST > home/www/structure.sql
