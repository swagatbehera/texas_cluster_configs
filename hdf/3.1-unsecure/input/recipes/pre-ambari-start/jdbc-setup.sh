#!/bin/bash
yum -y install mysql-connector-java
mkdir -p /var/lib/ambari-server/jdbc-drivers
cp /usr/share/java/mysql-connector-java.jar /var/lib/ambari-server/jdbc-drivers
