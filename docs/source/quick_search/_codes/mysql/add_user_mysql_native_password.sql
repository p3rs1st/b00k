create user 'remote'@'localhost' identified with mysql_native_password by 'password';
grant all on *.* to 'remote'@'localhost';
create user 'remote'@'%' identified with mysql_native_password by 'password';
grant all on *.* to 'remote'@'%';
flush privileges;
