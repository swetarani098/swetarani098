##########################################################################################################
# File Name                  Developer                       Create On                                   #
# DQ_EVFIRST_NormalizerProcessing_LifeComm_ME_VAL_POLICY_NORMALIZER.sh    Cognizant DQ Developent Team           11-Sep-2018 	 #
# Version History:                                                                                       #
# 1.1 - 11-Sep-2018 - Initial version                                                                    #
##########################################################################################################

. /work/DQ/DQApps/FIRST/Param/env_file_EV.parm

rm /work/DQ/DQApps/FIRST/ev_Normalizer/LifeComm_ME_VAL_POLICY_NORM_COMPLETE.done

cd $meta_file_path

### Script variables
tmstmp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_EVFIRST_NormalizerProcessing_LifeComm_ME_VAL_POLICY_NORMALIZER_'$checker_timestamp'.log'
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

############################################################################################################
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
#echo batchid
#echo batchpwd
rm -f rpass.tmp
#############################################################################################################

f_gen_log "Source is being processed.."           
#echo 1.1
v_source_file_runtime_NORMALIZER=$meta_file_path'/DQ_EVFIRST_RUNTIME_LifeComm_ME_VAL_POLICY_NORMALIZER.csv'
export varFileExist='0'
#echo 1.2
echo $v_source_file_runtime_NORMALIZER

ifFileExist $v_source_file_runtime_NORMALIZER
echo 1.25
echo "var=$varFileExist"
if [ $varFileExist = '1' ];
then
echo 1.3
  f_gen_log "Source Master File $v_source_file_runtime_NORMALIZER exists in Metafile directory $meta_file_path"
  
  INPUT_FILE=$v_source_file_runtime_NORMALIZER
  IFS=','
f_gen_log "Entered the Loop"
  while read SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM EVFRST_CYCLE_CD EVFRST_FILE_ID EVFRST_LOAD_TS EVFRST_DATA_SRC_NM EVFRST_USR_ID SOURCE_SYSTEM PRODUCT_NAME FILE_FORMAT MAINFRAME_FILE_NAME INFORMATICA_FILENAME CONTROL_FILE_NAME FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME BASE_FILE_NAME COUNTRY DUMMY
  
  do
#######BEGIN - Added on 06/18/2018 for NORMALIZER
 f_gen_log 'Checking for row_val_col_err_dtl file under the path: /work/DQ/DQApps/FIRST/ev_Normalizer/Source/'$BASE_FILE_NAME'_row_val_col_err_dtl.err'
    if [ -s '/work/DQ/DQApps/FIRST/ev_Normalizer/Source/'$BASE_FILE_NAME'_row_val_col_err_dtl.err' ]; 
    then
    #echo "Entered inside the loop"
    f_gen_log  "Entered inside the loop to run the Normaliser Worflows"
#######END - Added on 06/18/2018 for NORMALIZER
#echo 2
    f_gen_log "#Parameters#"
    f_gen_log  "Cycle Id: $EVFRST_CYCLE_CD"
    f_gen_log  "File Id: $EVFRST_FILE_ID"
    f_gen_log  "Source System Name: $EVFRST_DATA_SRC_NM"
    f_gen_log  "Base Source File Name: $BASE_FILE_NAME"
    f_gen_log  "Mainframe File Name: $MAINFRAME_FILE_NAME"
    f_gen_log  "Runtime Source File Name: $SOURCE_FILE_NAME_RUNTM"
    f_gen_log  "Runtime Control File Name: $CONTROL_FILE_NAME_RUNTM"
    f_gen_log  "Normalizer Application Name: $APPLICATION_NAME"
    f_gen_log  "Normalizer Workflow Name: $WORK_FLOW_NAME"
    f_gen_log  "Normalizer Parameter File Name: $PARAMETER_FILE_NAME"
    f_gen_log  "Country Name: $COUNTRY"
#echo 3	
    v_DQ_EVFIRST_NORMALIZER_RUNTIME_filewise_source_file_runtm="DQ_EVFIRST_NORMALIZER_RUNTIME_$BASE_FILE_NAME.csv"
    f_gen_log  "Creating Runtime Source File Metadata Information in file $v_DQ_EVFIRST_NORMALIZER_RUNTIME_filewise_source_file_runtm"
    #echo "$SOURCE_FILE_NAME_RUNTM,$CONTROL_FILE_NAME_RUNTM,$EVFRST_CYCLE_CD,$EVFRST_FILE_ID,$EVFRST_LOAD_TS,$EVFRST_DATA_SRC_NM,$EVFRST_USR_ID,$SOURCE_SYSTEM,$PRODUCT_NAME,$FILE_FORMAT,$MAINFRAME_FILE_NAME,$INFORMATICA_FILENAME,$CONTROL_FILE_NAME,$FILE_NAME,$APPLICATION_NAME,$WORK_FLOW_NAME,$PARAMETER_FILE_NAME,$BASE_FILE_NAME,$COUNTRY,$DUMMY" > "$v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm"
#echo 4  
    f_gen_log  "Updating NORMALIZER Param file"
    NORMALIZER_BASE_PARAM_FILE_NAME="$FILE_FORMAT"'_PARAM_NORMALIZER.XML'

    f_gen_log "cp $parm_file_path/$NORMALIZER_BASE_PARAM_FILE_NAME $parm_file_path/'NORMALIZER_'$PARAMETER_FILE_NAME"
    cp $parm_file_path/$NORMALIZER_BASE_PARAM_FILE_NAME $parm_file_path/'NORMALIZER_'$PARAMETER_FILE_NAME

    f_gen_log  "Base Param File Name $BASE_PARAM_FILE_NAME"
    f_gen_log "sh $script_file_path/DQ_EVFIRST_ReplaceStringInParamFile.sh $PARAMETER_FILE_NAME $FILE_FORMAT $SOURCE_FILE_NAME_RUNTM $BASE_FILE_NAME $COUNTRY $EVFRST_CYCLE_CD $EVFRST_FILE_ID"
    sh $script_file_path/DQ_EVFIRST_ReplaceStringInParamFile.sh 'NORMALIZER_'$PARAMETER_FILE_NAME $FILE_FORMAT $SOURCE_FILE_NAME_RUNTM $BASE_FILE_NAME $COUNTRY $CONTROL_FILE_NAME_RUNTM $EVFRST_CYCLE_CD $EVFRST_FILE_ID

    f_gen_log  "Calling NORMALIZER Workflow"
    f_gen_log  "INFA Command: /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn DMN_GRID_DQ_DEV -sn DIS_SVC_DQ_DEV -un $batchid -pd $batchpwd -a app_policy_normalizer -wf $WORK_FLOW_NAME_NORMALIZER -w true -pf $parm_file_path/'NORMALIZER_'$PARAMETER_FILE_NAME"
    #sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un batchid -pd batchpwd -a $APPLICATION_NAME -wf $WORK_FLOW_NAME -w false -pf $parm_file_path/$PARAMETER_FILE_NAME
    sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -sdn METNET.NET -a app_Policy_normalizer -wf $WORK_FLOW_NAME'_NORMALIZER' -w true -pf $parm_file_path/'NORMALIZER_'$PARAMETER_FILE_NAME

    f_gen_log "Archiving NORMALIZER Param file $PARAMETER_FILE_NAME file to $archive_file_path"
    mv $parm_file_path/'NORMALIZER_'$PARAMETER_FILE_NAME $archive_file_path/'NORMALIZER_'$PARAMETER_FILE_NAME'_'$tmstmp

    f_gen_log "Archiving NORMALIZER source file $BASE_FILE_NAME_row_val_col_err_dtl.err  to $archive_file_path"
    mv '/work/DQ/DQApps/FIRST/ev_Normalizer/Source/'$BASE_FILE_NAME'_row_val_col_err_dtl.err' $archive_file_path/$BASE_FILE_NAME'_row_val_col_err_dtl.err_'$tmstmp

    #f_gen_log "Archiving Param file $PARAMETER_FILE_NAME file to $archive_file_path"
    #mv $parm_file_path/$PARAMETER_FILE_NAME $archive_file_path/$PARAMETER_FILE_NAME
    sleep 2m
	
echo $EVFRST_CYCLE_CD"|"$EVFRST_FILE_ID"|"$SOURCE_FILE_NAME_RUNTM >> /work/DQ/DQApps/FIRST/ev_Normalizer/LifeComm_ME_VAL_POLICY_NORMALIZER.done
#######BEGIN - Added on 06/18/2018 for NORMALIZER
else
f_gen_log "No NORMALIZER executed for $SOURCE_FILE_NAME_RUNTM file."
fi
#######END - Added on 06/18/2018 for NORMALIZER
  done < $INPUT_FILE

#######BEGIN - added on 07-06-2018 for NORMALIZER
f_gen_log "Start of Normalized Output insertion into T_FRST_ERR_LOG table"
f_gen_log "sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn DMN_GRID_DQ_DEV -sn DIS_SVC_DQ_DEV -un batchid -pd batchpwd -a app_Push_To_T_FRST_ERR_LOG_policy -wf wf_Push_to_T_FRST_ERR_LOG_Policy"
sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -sdn METNET.NET -a app_Push_To_TFRST_ERR_LOG_Policy -wf wf_Push_to_T_FRST_ERR_LOG_Policy -w true -pf $parm_file_path/wf_Push_to_T_FRST_ERR_LOG_Policy.xml
f_gen_log "End of Normalized Output insertion into T_FRST_ERR_LOG table"
#######END - added on 07-06-2018 for NORMALIZER

#######BEGIN - added on 12-12-2018 for update PROC_CD
f_gen_log "Start of update PROC_CD change in T_FRST_CTRL table"
f_gen_log "sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un batchid -pd batchpwd -a app_Update_Control_Table_Proc_Cd_Policy -wf wf_DQ_EVFIRST_Update_Control_Table_Proc_Cd_E_To_R -w true -pf $parm_file_path/wf_DQ_EVFIRST_Update_Control_Table_Proc_Cd_E_To_R.XML"
sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -sdn METNET.NET -a app_Update_Control_Table_Proc_Cd_Policy -wf wf_DQ_EVFIRST_Update_Control_Table_Proc_Cd_E_To_R -w true -pf $parm_file_path/wf_DQ_EVFIRST_Update_Control_Table_Proc_Cd_E_To_R_ME_VAL_POLICY.XML
f_gen_log "End of update PROC_CD change in T_FRST_CTRL table"
#######END - added on 12-12-2018 for update PROC_CD


    f_gen_log "Archiving $v_source_file_runtime_NORMALIZER to $archive_file_path'DQ_EVFIRST_RUNTIME_LifeComm_ME_VAL_POLICY_NORMALIZER.csv_'$tmstmp"
    mv $v_source_file_runtime_NORMALIZER $archive_file_path'DQ_EVFIRST_RUNTIME_LifeComm_ME_VAL_POLICY_NORMALIZER.csv_'$tmstmp

      f_gen_log "Archiving DQ_EVFIRST_RUNTIME_STATUS_CHANGE_POLICY.csv To Archive"
    mv DQ_EVFIRST_RUNTIME_STATUS_CHANGE_ME_VAL_POLICY.csv $archive_file_path'DQ_EVFIRST_RUNTIME_STATUS_CHANGE_ME_VAL_POLICY.csv_'$tmstmp

else
  f_gen_log "Source File Base $v_source_file_runtime_NORMALIZER does not exist in Metafile directory"
echo 99
fi

f_gen_log  "End of Script"
