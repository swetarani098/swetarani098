##########################################################################################################
# File Name                                             Developer                              Created On#
# DQ_PNRM_SubWrapper_KRICheck.sh                Cognizant DQ Developent Team                  22-May-2017#
# Version History:                                                                                       #
# 1.1 - 22-May-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm


### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S%N`
logfile='DQ_PNRM_SubWrapper_KRICheck_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile
#echo $logdirnfile
#echo 1.0
###Log File Function
f_gen_log()
{
log_time=`date`
## commented can be used for debugging ---- echo "$log_time ----- $1" ">> $logdirnfile"
echo -e "$log_time ----- $1" >> $logdirnfile
}

###File Exist Function
function ifFileExist()
{
FILE=$1
f_gen_log "Checking if File Name - $FILE exists.."
if [ -f $FILE ];
then
   f_gen_log "File $FILE exists."
   varFileExist='1'
else
   f_gen_log "File $FILE does not exist."
   varFileExist='9'
fi
#echo "varFileExist - $varFileExist"
return $varFileExist
}


#############################################################################################################

sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_ReplaceParam.sh

#############################################################################################################

date=`date +%Y%m%d`
WF_NAME='wf_DQ_PNRM_PK_RI'
RUNTIME_PARAM_FILE='wf_DQ_PNRM_PK_RI_Runtime_'$date'.xml'

#############################################################################################################

f_gen_log  "Invoking Workflow invokaton script: DQ_PNRM_WF_Invoke.sh for PK RI check"

sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_WF_Invoke.sh $WF_NAME $RUNTIME_PARAM_FILE true

#############################################################################################################

var_cnt=1
var_i=1

while [ $var_i -le $var_cnt ] 
do
  sleep .0005m
  f_gen_log "var_i := $var_i, slept for 1 minute."
  var_i=`expr $var_i + 1`
  if [ $var_i -gt $var_cnt ] 
  then
    f_gen_log "var_i := $var_i, Pre Processor workflow run for all files is complete"  
  fi
done

##################### End of Script ########################################################

