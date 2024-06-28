CREATE USER 'remote'@'localhost' IDENTIFIED WITH mysql_native_password by 'password';
GRANT ALL ON *.* TO 'remote'@'localhost';
CREATE USER 'remote'@'%' IDENTIFIED WITH mysql_native_password by 'password';
GRANT ALL ON *.* TO 'remote'@'%';
FLUSH PRIVILEGES;
