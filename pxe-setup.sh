#!/bin/bash

BLACK='\033[0;30m'
DGRAY='\033[1;30m'
RED='\033[0;31m'
BRED='\033[1;31m'
GREEN='\033[0;32m'
BGREEN='\033[1;32m'
YELLOW='\033[0;33m'
BYELLOW='\033[1;33m'
BLUE='\033[0;34m'
BBLUE='\033[1;34m'
PURPLE='\033[0;35m'
BPURPLE='\033[1;35m'
CYAN='\033[0;36m'
BCYAN='\033[1;36m'
LGRAY='\033[0;37m'
WHITE='\033[1;37m'
NOCOLOR='\033[0m'


dir="/"
if [[ ! -z $1 ]];then
	[[ $(echo $1 | head -c 1) != "/" ]] && echo -e "${RED}> Please specify FULL PATH to destination dir. Exit${NOCOLOR}" && exit
	dir=$1
fi

[[ -d ${dir}/pxeserver ]] && rm -R ${dir}/pxeserver
mkdir -p ${dir}/pxeserver


[[ -d /tmp/pxe-server ]] && rm -R /tmp/pxe-server
mkdir -p /tmp/pxe-server > /dev/null 2>&1
cd /tmp/pxe-server
echo
echo -e "${GREEN}> Download PXE-server package${NOCOLOR}"
wget -t 5 --show-progress https://github.com/minershive/hiveos-pxe-diskless/archive/master.zip
echo
if [[ $? -eq 0 ]]; then
	echo -e "${GREEN}> Extract PXE-server package.Please wait${NOCOLOR}"
	unzip master.zip > /dev/null 2>&1
else
	echo -e "${RED}> Error download PXE-server package. Exit${NOCOLOR}"
	exit 1
fi

cat /tmp/pxe-server/hiveos-pxe-diskless-master/pxeserver/hiveramfs/x* > /tmp/pxe-server/hiveos-pxe-diskless-master/pxeserver/hiveramfs/hiveramfs.tar.xz
rm /tmp/pxe-server/hiveos-pxe-diskless-master/pxeserver/hiveramfs/x*

echo
echo -e "${GREEN}> Copy PXE-server package to destination directory.${NOCOLOR}"
cp -R /tmp/pxe-server/hiveos-pxe-diskless-master/pxeserver/* ${dir}/pxeserver/

rm -R /tmp/pxe-server > /dev/null 2>&1

cd ${dir}/pxeserver
exec sudo ./pxe-config.sh