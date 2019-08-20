#!/bin/bash
#execution of edit_partofnamelist.sh
#####################################################################################################
export WRF_HOME="$HOME/WRFV3.7.1"
#####################################################################################################

#####################################################################################################
PROGRAMLOCALE=${WRF_HOME}/controlcenter/FNLandMANAL
SubPROGRAMLOCALE=${PROGRAMLOCALE}/program_components/edit_partofnamelist_components
#####################################################################################################
#user setting

#end date
export eday=09
export ehour=06
#Scheme
export PBLscheme=5
####################################################
export year=2017
export month=08
#####################################################################################################
DOMAINDIR=${WRF_HOME}/domain
export DOMAINDIR
echo -n "Project Name:"
read PROJECT
export PROJECT
echo -n "domain number:"
read domainnumber
export domainnumber
#####################################
#application of usersetting
source ${SubPROGRAMLOCALE}/usersetting
#####################################
#definition of parameter for editing some namelist files
source ${SubPROGRAMLOCALE}/call_domain_and_time
###################################
#Edit of namelist.wps
source ${SubPROGRAMLOCALE}/edit_namelistwps
#####################################################################################################
#move to namelist.input directory
NAMELISTDIR=${DOMAINDIR}/${PROJECT}
NAMELIST=${DOMAINDIR}/${PROJECT}/namelist.input
cd ${NAMELISTDIR}
echo "
"
#####################################################################################################
#editing of namelist.input
if [ ${domainnumber} = 1 ]; then
  source ${SubPROGRAMLOCALE}/edit_partofnamelist1
elif [ ${domainnumber} = 2 ]; then
  source ${SubPROGRAMLOCALE}/edit_partofnamelist2
elif [ ${domainnumber} = 3 ]; then
  source ${SubPROGRAMLOCALE}/edit_partofnamelist3
elif [ ${domainnumber} = 4 ]; then
  source ${SubPROGRAMLOCALE}/edit_partofnamelist4
else
  source ${SubPROGRAMLOCALE}/edit_partofnamelist4
fi
#####################################################################################################
#Made by Yohei Inokuchi(06/07/2018)

