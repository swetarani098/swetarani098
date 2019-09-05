##########################################################################################################
# File Name                  Developer                       Create On                                   #
# wf_DQ_PNRM_PK_RI.XML       Cognizant DQ Developent Team                                    22-May-2017 #
# Version History:                                                                                       #
# 1.1 - 22-May-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

cd $meta_file_path

### Script variables
success_txt="The workflow instance completed successfully."
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_WF_Invoke_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile
echo $logdirnfile
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

#########################################################################################
token0=`date +%A`
token0=`echo $token0|cut -c1-|rev`
token0=`echo $token0|cut -c1-3|rev`
token0='DQ'$token0
token2=0
token1=0
while [ $token2 -le 0 ]
do
token1=`expr $RANDOM % 2`
if [ $token1 != '0' ]
then
  token2=$token1
fi
token1=0
done
token=`expr $token2 \* 2`
token3=`expr $token \* 3`
token=$token$token1
token=$token$token2
token=$token$token3
token=$token0$token
#echo $token
#echo $restrict_file_path$enc_DpassFile
openssl enc -in $restrict_file_path$enc_DpassFile -d -aes-256-cbc  -pass pass:$token > rpass.tmp

dqwfuser=`openssl enc -in $restrict_file_path$enc_UserFile -d -aes-256-cbc  -pass file:rpass.tmp`
dqwfpass=`openssl enc -in $restrict_file_path$enc_PassFile -d -aes-256-cbc  -pass file:rpass.tmp`
#echo $dqwfuser
#echo $dqwfpass
rm -f rpass.tmp
#########################################################################################

f_gen_log "----Script Arguments----"
f_gen_log "argument 1["'${var:~Workflow To Run~}'"]: $1"
f_gen_log "argument 2["'${var:~Workflow Parameter FileName~}'"]: $2"
f_gen_log "argument 3["'${var:~Wait Status~}'"]: $3"

v_WF_name=$1
v_param_filename=$parm_file_path/$2
v_WaitStatus=$3

if [ "$v_WaitStatus" != 'true' ]
then
 v_WaitStatus='false'
 f_gen_log "Inside IF condition, v_WaitStatus: $v_WaitStatus"
fi

echo $v_WF_name
echo $v_param_filename


sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -a $APP_NAME -wf $v_WF_name -w $v_WaitStatus -pf $v_param_filename
##varWorkflowStatus=$(sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -a $APP_NAME -wf $v_WF_name -w $v_WaitStatus -pf $v_param_filename)
#varWorkflowStatus=$(sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -a $APP_NAME -wf $v_WF_name -w true -pf $v_param_filename)
#echo $varWorkflowStatus

#echo "$varWorkflowStatus" | grep -q "$success_txt"
#if [ $varWorkflowStatus -eq 0 ];then
  echo "$v_WF_name|Passed|$varWorkflowStatus" >> $target_file_path/DQ_Panorama_Processflow.txt
 # f_gen_log "$v_WF_name Workflow is completed successfully."
#else
#  echo "$v_WF_name|Failed|$varWorkflowStatus" >> $target_file_path/DQ_Panorama_Processflow.txt
 # f_gen_log "$v_WF_name Workflow is Failed."
#fi

echo "sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -a $APP_NAME -wf $v_WF_name -w $v_WaitStatus -pf $v_param_filename"

f_gen_log "End of Workflow Invoke"