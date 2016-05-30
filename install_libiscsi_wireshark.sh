#!/bin/bash

#install dependencies
yum install -y unzip CUnit CUnit-devel make automake autoconf libtool wireshark wireshark-gnome xauth

if [ -f master.zip ] ;then
	rm master.zip
fi

if [ -d libiscsi-master ] ;then
	rm -r libiscsi-master
fi


#download and extract package
echo "Starting Installer"
wget https://github.com/sahlberg/libiscsi/archive/master.zip
unzip master.zip > /tmp/master_unzip.results

#compile
cd libiscsi-master
chmod 777 autogen.sh
./autogen.sh > /tmp/autogen.results
./configure > /tmp/configure.results
grep libcunit /tmp/configure.results |grep yes
if [ $? -eq 0 ]; then
	echo " ./configure run sucessfully"
else
	echo "libcunit error, run configure manually to check"
	exit 1
fi
make > /tmp/make.results
./test-tool/iscsi-test-cu -l | grep ALL
if [ $? -eq 0 ];then
	echo "libiscsi installed sucessfully"
else
	echo "unexpected error"
	exit 1
fi



