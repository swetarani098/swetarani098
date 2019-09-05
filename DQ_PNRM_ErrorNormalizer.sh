##########################################################################################################
# File Name                       Developer                                             Create On        #
# DQ_PNRM_MainWrapper2.sh    Cognizant DQ Developent Team                          01-Jun-2017      #
# Version History:                                                                                       #
# 1.1 - 01-Jun-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

cd $meta_file_path

### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_ErrorNormalizer_'$checker_timestamp'.log'
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
f_gen_log "Source is being processed.."
#echo 1.1
v_source_file_runtime=$meta_file_path'/DQ_PANORAMA_Source_File_Metadata_RunTime.csv' 
#echo $v_source_master_file
export varFileExist='0'
#echo 1.2
#echo $v_source_file_runtime
ifFileExist $v_source_file_runtime
#echo 1.25
echo "var=$varFileExist"

##### IF at line 58 starts here #####
if [ $varFileExist = '1' ]
then
#echo 1.3
  f_gen_log "Source Master File $v_source_file_runtime exists in Metafile directory $meta_file_path"
 echo "Source Master File $v_source_file_runtime exists in Metafile directory $meta_file_path"
######################################################################################################################################
######################################################################################################################################
cd $target_file_path
v_BPD_check=`cat BPD_DistCnt.txt`

echo $v_BPD_check
cat $target_file_path/BPD_DistCnt.txt

if [ $v_BPD_check = 1 ];
then

######################################################################################################################################
f_gen_log "Execution of Individual DQ Validation workflows is complete, Error workflows will now be invoked.."
f_gen_log "****************************** SECTION 2 OF THE SCRIPT STARTED ***********************************"
######################################################################################################################################

  INPUT_FILE=$v_source_file_runtime
  IFS=','
#echo 1.4
  while read SOURCE_SYSTEM_NAME BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME WORK_FLOW_NAME_ERR PARAMETER_FILE_NAME_ERR DUMMY

  do
#echo 2
    f_gen_log "#Parameters#"
    f_gen_log  "SOURCE_SYSTEM_NAME: $SOURCE_SYSTEM_NAME"
    f_gen_log  "BATCH_ID: $BATCH_ID"
    f_gen_log  "FILE_ID: $FILE_ID"
    f_gen_log  "SOURCE_FILE_NAME_RUNTM: $SOURCE_FILE_NAME_RUNTM"
    f_gen_log  "CONTROL_FILE_NAME_RUNTM: $CONTROL_FILE_NAME_RUNTM"
    f_gen_log  "BASE_FILE_NAME: $BASE_FILE_NAME"
    f_gen_log  "SOURCE_FILE_NAME: $SOURCE_FILE_NAME"
    f_gen_log  "CONTROL_FILE_NAME: $CONTROL_FILE_NAME"
    f_gen_log  "APPLICATION_NAME: $APPLICATION_NAME"
    f_gen_log  "WORK_FLOW_NAME: $WORK_FLOW_NAME"
    f_gen_log  "PARAMETER_FILE_NAME: $PARAMETER_FILE_NAME"
    f_gen_log  "WORK_FLOW_NAME_ERR: $WORK_FLOW_NAME_ERR"
    f_gen_log  "PARAMETER_FILE_NAME_ERR: $PARAMETER_FILE_NAME_ERR"

#echo 3	

    v_STATIC_FILENAME_PART_WITHDT1=`echo $SOURCE_FILE_NAME_RUNTM | sed -e 's/.dat//g'`
    v_ERROR_FILENAME_RUNTM_BASE=$v_STATIC_FILENAME_PART_WITHDT1
    v_BATCH_ID_FILE_ID_ERROR_FILENAME_RUNTM_BASE=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT1

    f_gen_log  "Here is the file: $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
    f_gen_log  "Creating Runtime Source File Metadata Information in file $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
# Already created    echo "$SOURCE_SYSTEM_NAME,$BATCH_ID,$FILE_ID,$SOURCE_FILE_NAME_RUNTM,$CONTROL_FILE_NAME_RUNTM,$BASE_FILE_NAME,$SOURCE_FILE_NAME,$CONTROL_FILE_NAME,$APPLICATION_NAME,$WORK_FLOW_NAME,$PARAMETER_FILE_NAME,$WORK_FLOW_NAME_ERR,$PARAMETER_FILE_NAME_ERR,$DUMMY" > "$v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
#echo 4  
    f_gen_log  "Updating Param file"

    BASE_PARAM_FILE_NAME_ERR="$BASE_FILE_NAME"'_BASE_PARAM_ERR.XML'

#echo $BASE_PARAM_FILE_NAME

    f_gen_log "cp $parm_file_path/$BASE_PARAM_FILE_NAME_ERR $parm_file_path/$PARAMETER_FILE_NAME_ERR"

    cp $parm_file_path/$BASE_PARAM_FILE_NAME_ERR $parm_file_path/$PARAMETER_FILE_NAME_ERR

    f_gen_log  "Base Param File Name $BASE_PARAM_FILE_NAME_ERR"
    f_gen_log "sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn_Err.sh 'Dummy' $parm_file_path'/'$PARAMETER_FILE_NAME_ERR $v_ERROR_FILENAME_RUNTM_BASE $v_BATCH_ID_FILE_ID_ERROR_FILENAME_RUNTM_BASE"


    sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn_Err.sh 'Dummy' $parm_file_path'/'$PARAMETER_FILE_NAME_ERR $v_ERROR_FILENAME_RUNTM_BASE $v_BATCH_ID_FILE_ID_ERROR_FILENAME_RUNTM_BASE
 
    f_gen_log  "Calling Workflow"

sh $script_file_path/DQ_PNRM_WF_Invoke.sh $WORK_FLOW_NAME_ERR $PARAMETER_FILE_NAME_ERR

    f_gen_log "Archiving Param file $PARAMETER_FILE_NAME_ERR file to $archive_file_path"
#    mv $parm_file_path/$PARAMETER_FILE_NAME_ERR $archive_file_path/$PARAMETER_FILE_NAME_ERR

  
  done < $INPUT_FILE
#sleep 1m
######################################################################################################################################
f_gen_log "Invokation of Individual DQ Validation Error workflows are complete now.."
f_gen_log "****************************** SECTION 2 OF THE SCRIPT COMPLETED ***********************************"
######################################################################################################################################

######################################################################################################################################
# Check if all the DQ validation Error workflows completed or not
######################################################################################################################################
var_cnt=600
var_i=1

f_gen_log()
{
log_time=`date`
echo -e "$log_time ----- $1" >> $logdirnfile
}

f_gen_log "Verification Processing started to check if DQ Validation Error workflow run is complete or not.."
while [ $var_i -le $var_cnt ] 
do

  ##LineCount of Runtime file
  LC_RunTime=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.csv|grep -c ^`

  ##LineCount of .done file
  LC_Err_dotDone=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime_Err.done|grep -c ^`

  if [ $LC_RunTime = $LC_Err_dotDone ];
  then
    f_gen_log "Number of entries in Runtime file=$LC_RunTime is now equals number of files processed=$LC_Err_dotDone as per .done file"
    ############################################### Move and Archive files here #####################################################

    #cp $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime_Err.done $etltrig_file_path'DQ_PANORAMA_ERR.done'
    #chmod 777 $etltrig_file_path*.*     

    ####################################################### End of Archiving ########################################################
    var_i=$var_cnt
  fi
  sleep 0.2m
  f_gen_log "var_i := $var_i, Workflows are still running."
  var_i=`expr $var_i + 1`
  if [ $var_i -gt $var_cnt ] 
  then
    f_gen_log "var_i := $var_i, Workflow Run is complete"  
  fi
done
f_gen_log "All ERROR Validation Workflows have been executed....."
echo -e "All ERROR Validation Workflows have been executed.....\nDate_Timestamp : $checker_timestamp \n\n" | mailx -s "$var_subject_ALL_Vldtn_Err_success $var_ENV" $ALL_Vldtn_error_mailid_list

######################################################################################################################################
f_gen_log "Execution of Individual DQ Validation Error workflows is complete, Archival process will now be invoked.."
######################################################################################################################################

cd $error_file_path
echo "$col_header" >> Consolidated_mr_file.csv
echo `cat Holding_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingDates_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingMeasure_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingComponentMeasures_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingComponents_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingFinTran_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingInsuredUnderwriting_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingInvVehFinTran_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingInvVeh_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingLoanMeasures_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingLoans_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingProducer_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingRoleRegistration_mr.csv >> Consolidated_mr_file.csv`
echo `cat HoldingRestrictions_mr.csv >> Consolidated_mr_file.csv`

echo `zip Consolidated_mr_file.zip Consolidated_mr_file.csv`


echo "$col_header1" >> Consolidated_error_file.csv
echo `cat Holding_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingDates_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingMeasure_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingComponentMeasures_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingComponents_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingFinTran_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingInsuredUnderwriting_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingInvVehFinTran_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingInvVeh_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingLoanMeasures_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingLoans_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingProducer_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingRoleRegistration_error.csv >> Consolidated_error_file.csv`
echo `cat HoldingRestrictions_error.csv >> Consolidated_error_file.csv`

var_error=`cat Consolidated_error_file.csv|wc -l`


if [ ${var_error} -gt 1 ]
then 
f_gen_log "Errors are present in consolidated error file......"
echo "FAILURE" > /work/DQ/DQdatafiles/PANORAMA/Error/'Error_STATUS_Final.txt'
else
f_gen_log "No error found in consolidated error file......"
echo "SUCCESS" > /work/DQ/DQdatafiles/PANORAMA/Error/'Error_STATUS_Final.txt'
fi

echo `zip Consolidated_error_file.zip Consolidated_error_file.csv`

var1=`cat Consolidated_mr_file.csv|wc -l`

if [ ${var1} -gt 1 ]
then 
f_gen_log "Sending Reference value error mail ......"
echo -e "Please Find Attached the Consolidated Reference Value Error Report......" | mailx -s "$var_subject_reference_value_error $var_ENV" -a Consolidated_mr_file.zip -a Error_Metric.txt $Reference_error_mailid_list
else
f_gen_log "Sending Reference value error mail ......"
echo -e "No Reference Error found." | mailx -s "$var_subject_reference_value_success $var_ENV" $Reference_error_mailid_list
fi


f_gen_log "Sending Consolidated error mail ......"
echo -e "Please Find the Attached Consolidated Error Report......" | mailx -s "$var_subject_consolidated_error $var_ENV" -a Consolidated_error_file.zip -a Error_Metric.txt $Consolidated_error_mailid_list




  f_gen_log "Archiving $v_source_file_runtime to $archive_file_path"
#  mv $v_source_file_runtime $archive_file_path/$v_source_file_runtime

fi

else
  f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
echo 99
fi
##### IF at line 58 ends here #####

f_gen_log "ErrorReconciliation----"

sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_ErrorReconciliation.sh

f_gen_log "Archiving files----"

#sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_Archive.sh

f_gen_log  "End of Script"
