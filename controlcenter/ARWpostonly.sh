#!/bin/bash
#####################################################################################################
#[1]Use Domain Wizerd...,but you must NOT excute the "geogrid.exe" (Only make "namelist.input" file)
#[2]
#####################################################################################################
#####[USER SETTINGs]#################################################################################
#####################################################################################################
#(Please edit following PATH setting)
#<==Caution==> [[Don't enter the "/" letter]]
#WRF HOME Directory
export WRF_HOME="$HOME/WRFV3.7.1"
#Main Program file place(the place of This file)
export PROGRAMplace=${WRF_HOME}/controlcenter/FNLandMANAL
#Sub Program place(the place of wrf-ARWpost-builtin.sh)
export SubPROGRAMplace=${PROGRAMplace}/program_components/ARWpostonly_components
#Share Pragram file place
export SharePROGRAMplace=${PROGRAMplace}/program_components/share_components
##################################################
##################################################
#
export year=2017
export month=08
export day=08
#####################################################################################################
#####[USER SETTINGs]#################################################################################
#####################################################################################################
#[Embed some program]
source ${PROGRAMplace}/share/coloring_setting
source ${SharePROGRAMplace}/sharefunction
#####################################################################################################
#####################################################################################################
#[begin contents]####################################################################################
#####################################################################################################
###function###
#copy the domain directory files to work directory

function _namelistarw_confirmation_and_interpolation_() {
if [ "${ARWPOSTEXEDIR}" -ne '${WRF_HOME}/ARWpost' ]; then
  echo "namelist.ARWpost is nothing in ${ARWPOSTEXEDIR} directory!"
  echo "We need to put latest(=usually used) namelist.ARWpost in ${ARWPOSTEXEDIR}..."
  echored "If ${WRF_HOME}/ARWpost/namelist.ARWpost is NOT latest, ... Please put latest version of namelist.ARWpost!!!"
  echonred "\nDo you want to copy ${WRF_HOME}/ARWpost/namelist.ARWpost to ${ARWPOSTEXEDIR}/ ?[yes/no]:"
  read nlARW_confirmation
  if [ "${nlARW_confirmation}" -eq "yes" ]; then
    cp ${WRF_HOME}/ARWpost/namelist.ARWpost ${ARWPOSTEXEDIR}/
    echo "We copied ${WRF_HOME}/ARWpost/namelist.ARWpost to ${ARWPOSTEXEDIR}/ ..."
  else
    echonyellow "Do you want to proceed?[yes/no]:"
    _confirmation_
  fi
else
  if [ ! -f ${ARWPOSTEXEDIR}/namelist.ARWpost ]; then
    echo -e "namelist.ARWpost is nothing in ${ARWPOSTEXEDIR} directory...\nStopped"
    exit;
  fi
fi
}
#####################################################################################################
#####################################################################################################
#
########################################################################
### [ configuration of environment (directory and file and variables) ]
########################################################################
#[definition of this project name]
echocyan "Please enter some information!"
echonblue "PROJECT:"
read PROJECT
export PROJECT
##################################################
#[Enbed usersettings]
source ${SubPROGRAMplace}/usersettings
##################################################
#[make directory under ${WRF_HOME}/domain]
mkdir -m 755 ${DOMAIN_DIR}
DOMAINDIR=${DOMAIN_DIR}
export DOMAINDIR
#[make directory under ${WRF_HOME}/work]
mkdir ${WORK_DIR}
export WORKDIR=${WORK_DIR}
##################################################
#[clear up and make the log file]
export LogFile=${WORKDIR}/${Logfile_name}
export Log='tee -a '${LogFile}
rm ${Log} >& /dev/null
touch ${LogFile}
##################################################
#[definition of domain and time for these scripts]
source ${SubPROGRAMplace}/def_domain_and_time
########################################################################
### [ configuration of environment (directory and file and variables) ]
########################################################################
cd ${DOMAINDIR}
echo "We moved to $(echo ${PWD})!!!"
##################################################

################################################################
################################################################
#[Editing of namelist.ARWpost]
source ${SubPROGRAMplace}/firstedit_namelistarwpost
################################################################
################################################################
#[confirmation of executing wrf-ARWpost-builtin.sh(after confirmation of namelist.ARWpost)]
echo -e "\n===== confirmation of strage capacity =====" | ${Log}
df -h | ${Log}
echo -e "===== confirmation of strage capacity =====\n" | ${Log}
echoncyan "Are you sure to continue(run ARWpostonly_builtin.sh)?[yes/no]:"
_confirmation_
############################################
#[creating the grads folda]
mkdir ${WORKDIR}/grads
grads=${WORKDIR}/grads
export grads
############################################
#*****************************
#(pre cording)
bash ${SubPROGRAMplace}/ARWpostonly_builtin.sh &
arwpostonly_pid=$!
#wait ${arwpostonly_pid}
export arwpostonly_pid
echo "$arwpostonly_pid" > ${SubPROGRAMplace}/arwpostonly_result
#*****************************
#[WRF-PJ-All-Automatic.sh job finished]
################################################################
#
################################################################
exit
#####################################################################################################
#[end contents]######################################################################################
#####################################################################################################
#####################################################################################################
#[Solution for some Errors]
#[1]you see this file as white color file, you should type "chmod 755 ./WRF-PJ-All-Automatic.sh"
#[2]if you have an error "bad interpreter: No such file or directory", you can type this command "sed -i 's/\r//' WRF-PJ-All-Automatic.sh"...and try again!
#This file was made by Yohei Inokuchi(2018/4/28)
