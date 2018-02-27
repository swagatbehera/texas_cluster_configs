#!/bin/bash

# install mysql connector
yum -y install mysql-connector-java

# clean-up grid 0, 1, 2, 3
rm -rf /grid/0/*
rm -rf /grid/1/*
rm -rf /grid/2/*
rm -rf /grid/3/*

# create nifi user
useradd nifi

# create nifi dirs and permission

mkdir /grid/0/nifi
mkdir /grid/1/nifi
mkdir /grid/2/nifi
mkdir /grid/3/nifi

chown nifi:nifi /grid/0/nifi
chown nifi:nifi /grid/1/nifi
chown nifi:nifi /grid/2/nifi
chown nifi:nifi /grid/3/nifi
