#Structure With Data Backup
DATABASE_LIST=$(mysql -NBe 'show schemas' | grep -wv 'mysql\|personnel\|buildings\|information_schema\|performance_schema');echo $DATABASE_LIST;mysqldump --databases $DATABASE_LIST > bk.sql


#Structure only backup
DATABASE_LIST=$(mysql -NBe 'show schemas' | grep -wv 'mysql\|personnel\|buildings\|information_schema\|performance_schema');echo $DATABASE_LIST;mysqldump --no-data --databases $DATABASE_LIST > structure.sql


#Dump table backup in gz file

mysqldump db_name table_name | gzip > table_name.sql.gz

#Restore table from gz file

gunzip < table_name.sql.gz | mysql -u username -p db_name


# SQL Commands
#//delete all records/row
# DELETE FROM `table`
#//null value delete rows only example
# DELETE FROM `table` WHERE `gmc` ='null';
