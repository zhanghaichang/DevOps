#!/bin/sh

echo ">>>need root permission<<<\n"

echo "1. equipment brand: `dmidecode -s system-product-name`"

echo "2. OS info: `lsb_release -d | grep "Description"|awk -F: '{print $2}'`"

echo "3. kernel info: `uname -s -m -r`"

echo "4. hardware platform: `uname -i`"

echo "5. cpu info:"
echo "\tbrand and freq: `cat /proc/cpuinfo |grep "model name"|uniq |awk -F: '{print $2}'`"
echo "\tphysical CPUs:`cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l`"
echo "\tphysical cores per CPU: `cat /proc/cpuinfo |grep "cpu cores"|uniq|awk -F: '{print $2}'`"
echo "\tlogical cores per CPU: `cat /proc/cpuinfo |grep "siblings"|uniq|awk -F: '{print $2}'`"
echo "\ttotal logic cores: `cat /proc/cpuinfo |grep -c "processor"`"

echo "6. memory slots and size: \n `dmidecode|grep -P -A5 "Memory Device" |grep Size`"

echo "7. maximum capacity of memory: `dmidecode -t memory |grep "Maximum Capacity"| awk -F: '{print $2}'`"
echo "8. memory speed: \n`dmidecode|grep -A16 "Memory Device"|grep 'Speed'`"
