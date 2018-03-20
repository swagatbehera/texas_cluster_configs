#!/bin/bash

# install mysql connector
yum -y install mysql-connector-java

# create nifi user
useradd nifi

# create nifi dirs and permission
for i in $(seq 0 3);
do
    rm -rf /grid/${i}/*
    mkdir /grid/${i}/nifi
    chown nifi:nifi /grid/${i}/nifi
done
