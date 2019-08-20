#!/bin/bash
#
#=== [ drobo user ] ======================================#
# if you are Not drobo user, please comment out the following line,
# and then, you should set WORK_DIR PATH adequately!
#
DROBO_WRF_HOME="/mnt/drobo/inokuchi/WRFV3.7.1"
#=========================================================#
#
#set -x
WRF_HOME="$HOME/WRFV3.7.1"
PROGRAMplace=${WRF_HOME}/controlcenter/FNLandMANAL
##################################################
source ${PROGRAMplace}/share/coloring_setting
##################################################
echo -n PROJECT:
read PROJECT
DOMAINDIR=${WRF_HOME}/domain/${PROJECT}
# < the directory of putting into the wrfout files >
WORK_DIR=${DROBO_WRF_HOME}/work/${PROJECT}
echonred "Are you sure to reset Project?[yes/no]:"
read confirmation
if [ "${confirmation}" = "yes" ]; then
  rm ${DOMAINDIR}/MANAL:*
  rm ${DOMAINDIR}/FNL:*
  rm ${DOMAINDIR}/PFILE:*
  rm ${DOMAINDIR}/GRIBFILE*
  rm ${DOMAINDIR}/FNLFILE*
  rm ${DOMAINDIR}/MANALFILE*
  rm ${DOMAINDIR}/geo_em*
  rm ${DOMAINDIR}/met_em*
  rm ${DOMAINDIR}/*.log
  rm -r ${WORK_DIR}
else
  echo "Stoped..."
  exit;
fi
#set +x
