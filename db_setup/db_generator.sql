show databases;
create database catalog_development;
create database catalog_test;
CREATE USER 'catalog'@'%' IDENTIFIED BY 'catalog';
grant all on catalog_development.* to 'catalog'@'%';
grant all on catalog_test.* to 'catalog'@'%';

show databases;
select host, user from mysql.user;
flush privileges;
exit;
