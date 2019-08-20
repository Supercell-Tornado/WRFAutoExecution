#!/bin/bash
#SIMULATION_TYPE={ MANAL or FNL }
export SIMULATION_TYPE=FNL
export mpi_calculation_number=16
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
export SubPROGRAMplace=${PROGRAMplace}/program_components/WRF_PJ_ALL_Automatic_components
#Share Pragram file place
export SharePROGRAMplace=${PROGRAMplace}/program_components/share_components
##################################################
#position of DATA
export DATAPATH_FNL="${WRF_HOME}/data/20170809_NCEP-FNL/*"
export DATAPATH_MANAL="${WRF_HOME}/data/20170809_MANAL/*"
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
function _copyjob_ () {
  echo -e "\n==================copy job is starting !==================\n" | ${Log}
  cp ${DOMAINDIR}/met_em* ${WORKDIR}/
  cp ${DOMAINDIR}/namelist.input ${WORKDIR}/
  cp ${WRF_HOME}/WRFV3/run/*DATA* ${WORKDIR}/
  cp ${WRF_HOME}/WRFV3/run/*DBL* ${WORKDIR}/
  cp ${WRF_HOME}/WRFV3/run/*TBL* ${WORKDIR}/
  echo -e "\n==================copy job is completed!==================\n" | ${Log}
}

function _namelistarw_confirmation_and_interpolation_() {
  if [ "${ARWPOSTEXEDIR}" -ne '${WRF_HOME}/ARWpost' ]; then
    echo "namelist.ARWpost is nothing in ${ARWPOSTEXEDIR} directory!"
    echo "We need to put latest(=usually used) namelist.ARWpost in ${ARWPOSTEXEDIR}..."
    echored "If ${WRF_HOME}/ARWpost/namelist.ARWpost is NOT latest, ... Please put latest version of namelist.ARWpost!!!"

    echonred "\nDo you want to copy ${WRF_HOME}/ARWpost/namelist.ARWpost to ${ARWPOSTEXEDIR}/ ?[yes/no]:"
    local nlARW_confirmation
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
#[copying to Table File]
#if there are these files, you should select "no"!!!
if [ ! -e GEOGRID.TBL ]; then
  echo "There are Not GEOGRID.TBL file"
  cp -i ${WRF_HOME}/WPS/geogrid/GEOGRID.TBL.ARW ${DOMAINDIR}/GEOGRID.TBL
fi
if [ ! -e METGRID.TBL ]; then
  echo "No exist METGRID.TBL file"
  cp -i ${WRF_HOME}/WPS/metgrid/METGRID.TBL.ARW ${DOMAINDIR}/METGRID.TBL
fi
################################################################
################################################################
#[Store Vtable value as for NCEP-FNL DATA format](in any case...)
ln -sf ${WRF_HOME}/WPS/ungrib/Variable_Tables/Vtable.GFS Vtable
ln -sf ${WRF_HOME}/WPS/ungrib/Variable_Tables/Vtable.GFS Vtable.GFS
################################################################
################################################################
#[Confirmation and Execution of WPS jobs(geo to met)]
source ${SubPROGRAMplace}/wrfpj_allautomatic_geotomet
################################################################
################################################################
#[copyjob-domain-work.csh]
#mkdir -m 755 ${WRF_HOME}/work/${PROJECT}
cd ${WORKDIR}
_copyjob_
################################################################
################################################################
#[Confirmation and Execution of real.exe]
source ${SubPROGRAMplace}/wrfpj_allautomatic_real
#[Editing of namelist.ARWpost]
source ${SubPROGRAMplace}/firstedit_namelistarwpost
################################################################
################################################################
#[confirmation of executing wrf-ARWpost-builtin.sh(after confirmation of namelist.ARWpost)]
echo -e "\n===== confirmation of strage capacity =====" | ${Log}
df -h | ${Log}
echo -e "===== confirmation of strage capacity =====\n" | ${Log}
echoncyan "Are you sure to continue(run wrf-ARWpost-builtin.sh)?[yes/no]:"
_confirmation_
############################################
#Please edit following PATH for muching your environment
echored "\n\nOK..we begin to execute wrf-ARWpost-builtin.sh\n
so... after execution of wrf-ARWpost-builtin.sh, \n
you should press Enter key, and then you can enter the "exit" command!\n
"
echonyellow "Does it make sense?...[yes/no]:"
_confirmation_
echo "let's begin...!(press Enter)"
############################################
#[creating the grads folda]
mkdir ${WORKDIR}/grads
grads=${WORKDIR}/grads
export grads
############################################
#[executing wrf-ARWpost-builtin.sh]
#source ${SubPROGRAMplace}/wrf-ARWpost-builtin.sh
#*****************************
#(pre cording)
bash ${SubPROGRAMplace}/wrf-ARWpost-builtin.sh &
wrfpjallautomatic_pid=$!
#wait ${wrfpjallautomatic_pid}
export wrfpjallautomatic_pid
#*****************************
#
################################################################
#exit
#####################################################################################################
#[end contents]######################################################################################
#####################################################################################################
#####################################################################################################
#[Solution for some Errors]
#[1]you see this file as white color file, you should type "chmod 755 ./WRF-PJ-All-Automatic.sh"
#[2]if you have an error "bad interpreter: No such file or directory", you can type this command "sed -i 's/\r//' WRF-PJ-All-Automatic.sh"...and try again!
#This file was made by Yohei Inokuchi(2018/4/28)
