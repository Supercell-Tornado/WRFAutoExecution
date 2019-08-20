#!/bin/bash
#####################################################################################################
#This script is for built-in program of WRF-PJ-Automatic.sh
#Please edit following PATH setting(the directory place of namelist.ARWpost which you should use)
#export ARWPOSTEXEDIR=${WRF_HOME}/ARWpost
#==Caution==Don't enter the "/" letter
#####################################################################################################
#[begin contents]####################################################################################
#####################################################################################################
#[Execution of wrf.exe]
source ${SubPROGRAMplace}/wrfpj_allautomatic_wrf
################################################################
#[excute ARWpost.exe]
cd ${ARWPOSTEXEDIR}
#source ${PROGRAMplace}/share/debug_function
#debug_func
################################
# error message
if [ ${domainnumber} != 1 -a ${domainnumber} != 2 -a ${domainnumber} != 3 -a ${domainnumber} != 4 ]; then
  echo -e "This file is NOT deal with 5 or more domain!!!\n
  Stoped" | ${Log}
  exit;
fi
######################
# [ARWpost processing]
source ${SharePROGRAMplace}/arwpost_domainnumber

############################################################################
############################################################################
echo -e "ARWpost.exe job is complete!!!!!!\n
\n
\n
WRF-PJ-All-Automatic.sh job is success !!!!!!" | ${Log}
################################################################
#[copy job of namelist.ARWpost]
#Please comment out foloowing if you don't have to do it
cp ${ARWPOSTEXEDIR}/namelist.ARWpost ${WORKDIR}/
echo "namelist.ARWpost was copied to ${WORKDIR}..." | ${Log}
#mv ${WORKDIR}/${OUTNAME} ${grads}
echo "All jobs were over..." | ${Log}
ln -sf ${GrADS_COLORING_DIR}/loop_color.gs ${grads}/
#############################################################################
exit
#####################################################################################################
#[end contents]######################################################################################
#####################################################################################################
#[Solution for some Errors]
#[1]you see this file as white color file, you should type "chmod 755 ./wrf-ARWpost_builtin.sh"
#[2]if you have an error "bad interpreter: No such file or directory", you can type this command "sed -i 's/\r//' wrf-ARWpost-builtin.sh"...and try again!
#This file was made by Yohei Inokuchi(2018/4/28)
