#!/bin/bash

#install dependencies
yum install -y unzip CUnit CUnit-devel make automake autoconf libtool wireshark wireshark-gnome xauth > /tmp/installation.results

if [ -f master.zip ] ;then
	rm master.zip
fi

if [ -d libiscsi-master ] ;then
	rm -r libiscsi-master
fi


#download and extract package
echo -e "\e[96m>>>Starting Installer...\e[0m"
wget https://github.com/opachevs/libiscsi/archive/master.zip
unzip master.zip > /tmp/master_unzip.results

#compile
cd libiscsi-master
chmod 777 autogen.sh
./autogen.sh > /tmp/autogen.results
./configure > /tmp/configure.results
grep libcunit /tmp/configure.results |grep yes
if [ $? -eq 0 ]; then
	echo -e "\e[32m>>>./configure run sucessfully\e[0m"
else
	echo -e "\e[31m>>>libcunit error, run configure manually to check\e[0m"
	exit 1
fi
make > /tmp/make.results
./test-tool/iscsi-test-cu -l | grep ALL
if [ $? -eq 0 ];then
	echo -e "\e[32m>>>libiscsi installed sucessfully\e[0m"
else
	echo -e "\e[31m>>>unexpected error\e[0m"
	exit 1
fi

cd ..
rm master.zip


