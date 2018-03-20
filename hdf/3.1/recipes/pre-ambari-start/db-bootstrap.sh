#!/bin/bash


# function to create mysql-community repo file
create_mysql_community_repo()
{

	cat > /etc/yum.repos.d/maria.repo << MYSQLEOF
[mysql-connectors-community]
name=MySQL Connectors Community
baseurl=http://repo.mysql.com/yum/mysql-connectors-community/el/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql-tools-community]
name=MySQL Tools Community
baseurl=http://repo.mysql.com/yum/mysql-tools-community/el/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

# Enable to use MySQL 5.5
[mysql55-community]
name=MySQL 5.5 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.5-community/el/7/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

# Enable to use MySQL 5.6
[mysql56-community]
name=MySQL 5.6 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

# Note: MySQL 5.7 is currently in development. For use at your own risk.
# Please read with sub pages: https://dev.mysql.com/doc/relnotes/mysql/5.7/en/
[mysql57-community-dmr]
name=MySQL 5.7 Community Server Development Milestone Release
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
MYSQLEOF

}

# function to create mysql-community-source repo file
create_mysql_community_source_repo()
{

	cat > /etc/yum.repos.d/maria.repo << MYSQLSEOF
[mysql-connectors-community-source]
name=MySQL Connectors Community - Source
baseurl=http://repo.mysql.com/yum/mysql-connectors-community/el/7/SRPMS
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql-tools-community-source]
name=MySQL Tools Community - Source
baseurl=http://repo.mysql.com/yum/mysql-tools-community/el/7/SRPMS
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql55-community-source]
name=MySQL 5.5 Community Server - Source
baseurl=http://repo.mysql.com/yum/mysql-5.5-community/el/7/SRPMS
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql56-community-source]
name=MySQL 5.6 Community Server - Source
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/7/SRPMS
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

[mysql57-community-dmr-source]
name=MySQL 5.7 Community Server Development Milestone Release - Source
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/SRPMS
enabled=0
gpgcheck=1
gpgkey=file:/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
MYSQLSEOF
}


# create db init script
create_db_init_sql_file()	
{

	cat > /tmp/db-script.sql <<ENDDBSQLOF
# TODO fix this to only grant for specific db and also does not work if Ranger is on the same host as the DB
# ranger db setup
# CREATE USER 'rangerdba'@'%' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON *.* to 'rangerdba'@'%' WITH GRANT OPTION;
# GRANT ALL PRIVILEGES ON *.* to 'rangerdba'@'localhost' IDENTIFIED BY 'password';
# FLUSH PRIVILEGES;

CREATE USER 'rangerdba'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'rangerdba'@'localhost';
CREATE USER 'rangerdba'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'rangerdba'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'rangerdba'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'rangerdba'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

# create database for oozie
CREATE DATABASE oozie;
CREATE USER 'oozie'@'%' IDENTIFIED BY 'oozie';
GRANT ALL PRIVILEGES ON oozie.* TO 'oozie'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

# create database for hive
CREATE DATABASE hive;
CREATE USER 'hive'@'%' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON hive.* TO 'hive'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

# create database for druid
CREATE DATABASE druid DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'druid'@'%' IDENTIFIED BY 'druid';
GRANT ALL PRIVILEGES ON druid.* TO 'druid'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

# create database for streamline
CREATE DATABASE streamline;
CREATE USER 'streamline'@'%' IDENTIFIED BY 'streamline';
CREATE USER 'streamline'@'localhost' IDENTIFIED BY 'streamline';
GRANT ALL PRIVILEGES ON streamline.* TO 'streamline'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON streamline.* TO 'streamline'@'localhost' IDENTIFIED BY 'streamline' WITH GRANT OPTION;
FLUSH PRIVILEGES;
 
#create database for registry
CREATE DATABASE registry;
CREATE USER 'registry'@'%' IDENTIFIED BY 'registry';
CREATE USER 'registry'@'localhost' IDENTIFIED BY 'registry';
GRANT ALL PRIVILEGES ON registry.* TO 'registry'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON registry.* TO 'registry'@'localhost' IDENTIFIED BY 'registry' WITH GRANT OPTION;
FLUSH PRIVILEGES;
ENDDBSQLOF

}

# install mysql-server
install_mysql_server()
{

	yum -y install mysql-community-release-el7-5.noarch
	yum -y install mysql-community-common-5.6.38-2.el7.x86_64
	yum -y install mysql-community-libs-5.6.38-2.el7.x86_64
	yum -y install mysql-community-client-5.6.38-2.el7.x86_64
	yum -y install mysql-community-server-5.6.38-2.el7.x86_64

}


# start mysql-server
start_mysql_server()
{

	service mysqld start
}

# run db bootstrap script
init_db_bootstrap_script()
{

	mysql -u root < /tmp/db-script.sql

}

# main function
main()
{

	create_mysql_community_repo
	create_mysql_community_source_repo
	create_db_init_sql_file
	install_mysql_server
	start_mysql_server
	init_db_bootstrap_script
}


# start main
main
