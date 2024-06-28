-- master上添加slave账号

CREATE USER 'slave'@'%' IDENTIFIED BY 'slave_passwd@local';
GRANT REPLICATION SLAVE, REPLICATION CLIENT on *.* to 'slave'@'%';
FLUSH PRIVILEGES;

-- slave上添加master配置信息

CHANGE MASTER TO master_host='m1', master_user='slave', master_password='slave_passwd@local', master_port=3306, master_connect_retry=30, get_master_public_key=1;
START SLAVE;
