#!/bin/bash
#########################################################
#COLOR_USAGE_DIR=$(cd $(dirname $0); pwd)
#COLOR_USAGE_FILE=$($(dirname $0)/$(basename $0); pwd)
WRF_HOME="~/WRF"
COLORDIR=${WRF_HOME}/controlcenter/MANALrun/share
cd ${COLORDIR}
source ${COLORDIR}/coloring_setting
##########################################################
##########################################################
#Introduction of Usages
echo "[Introduction]"
echo -e "\n***************Usages***************"
echo "[example]"
echo "${cyan}Please enter some letter you want!${reset}"
echo -e "***************Usages***************\n"
#echo ""
echo -e "ex1)\n[${LINENO}]: ${green}How to use the "'${LINENO}'" environmental variable...!?${reset}"
echo ""
echo -e "ex2)\nNow, We in the ${green}${ul}${DIR}${reset} directory!\n"
##########################################################
#Practice1
echo "[Practice1](NotFunction)"
echo "${red}ABC${reset}DEF"
echo "${cyan}GHI${reset}${green}JKL${reset}"
echo "ABCDE"
echo -e "${red}${bold}"DIY"${reset}
${green}"DIY"${reset}
${bold}"DIY"${reset}"
echo -e "\n\n"
##########################################################
#Practice2
echocyan "Hello"
echobold "Hello"
echoul "Hello"
echo -e "\n\n"
##########################################################
echored "Hello"
echoblue "Hello"
echogreen "Hello"
echocyan "Hello"
echo -e "${red}${bold}"DIY"${reset}
${green}"DIY"${reset}
${bold}"DIY"${reset}"
exit

