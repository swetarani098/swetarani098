##########################################################################################################
# File Name                       Developer                                             Create On        #
# DQ_PNRM_ErrorNormalizer.sh    Cognizant DQ Developent Team                          01-Jun-2017      #
# Version History:                                                                                       #
# 1.1 - 01-Jun-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

cd $meta_file_path

### Script variables

date=`date +%Y%m%d`
dt=$(date +%Y%m%d%H%M%S)
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_ErrorAudit_'$checker_timestamp'.log'
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
#######################################################################################################################


#############################################################################################################
f_gen_log "Start of Error Audit Script.."


WF_NAME='wf_DQ_PNRM_Error_Audit'
RUNTIME_PARAM_FILE='wf_DQ_PNRM_Error_Audit_Runtime_'$date'.xml'
PARAMETER_FILE_PATH='/work/DQ/DQdatafiles/PANORAMA/Param/'
PARAMETER_FILE_NAME='wf_DQ_PNRM_Error_Audit_BASE_PARAM.xml'
RUNTIME_PARAMETER_FILE=$parm_file_path/wf_DQ_PNRM_Error_Audit_Runtime_$date.xml 


f_gen_log "Runtime Pararmeter File : $RUNTIME_PARAMETER_FILE"
f_gen_log "Copying original parameter file to create a runtime parameter file"

      cp $PARAMETER_FILE_PATH$PARAMETER_FILE_NAME $RUNTIME_PARAMETER_FILE


sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_WF_Invoke.sh $WF_NAME $RUNTIME_PARAM_FILE true

#############################################################################################################


v_error_status_count=`cat $target_file_path/Error_Count_dtls.txt |grep -c 'FAILURE'`

cd $target_file_path

if [ $v_error_status_count = 0  ] 
then 
echo -e "Please Find the Attached Error Count Details......" | mailx -s "DQ Panorama Error Audit Success Notification $var_ENV " -a Error_Count_dtls.txt $success_mailid_list

else
echo -e "Please Find the Attached Error Count Details......" | mailx -s "DQ Panorama Error Audit Failure Notification $var_ENV " -a Error_Count_dtls.txt $success_mailid_list

echo "Panorama Error Audit count validation failed...."
f_gen_log "Panorama Error Audit count validation failed...."

fi


f_gen_log  "End of Error Audit Script"




f_gen_log  "End of Error Audit Script"
fi
else
  f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
echo 99
fi


f_gen_log "Archiving files----"

sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_Archive.sh


