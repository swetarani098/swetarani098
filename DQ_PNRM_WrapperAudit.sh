##########################################################################################################
# File Name                  Developer                       Create On                                   #
# DQ_PNRM_Audit_Check.sh          Cognizant DQ Developent Team           07-Jun-2018     #
# Version History:                                                                                       #
# 1.1 - 07-JUN-18 - Initial version                                                                      #
##########################################################################################################



. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

date=`date +%Y%m%d`
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_WrapperAudit_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile

f_gen_log()
{
PNRM_logtm=`date`
echo "$PNRM_logtm ----- $1" >> $logdirnfile
}

dt=$(date +%Y%m%d%H%M%S)

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
f_gen_log "var=$varFileExist"

##### IF at line 58 starts here #####
if [ $varFileExist = '1' ]
then
#echo 1.3
  f_gen_log "Source Master File $v_source_file_runtime exists in Metafile directory $meta_file_path"
#echo "Source Master File $v_source_file_runtime exists in Metafile directory $meta_file_path"
######################################################################################################################################
cd $target_file_path
v_BPD_check=`cat BPD_DistCnt.txt`

echo $v_BPD_check
cat $target_file_path/BPD_DistCnt.txt

if [ $v_BPD_check = 1 ];
then

######################################################################################################################################

f_gen_log "Total feed count check...."
##############################################Total Feed Count Check####################################################################

v_count_RunTime=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.csv|grep -c ^`
v_count_Audit=`cat $target_file_path/Panorama_Audit_Table_DQ_Interim_Local.csv|grep -c ^`
v_batch_id=`cat $meta_file_path/BatchID_consolidated.txt`


if [ $v_count_RunTime = $v_count_Audit ] ;
then
echo "Total feed count is 14 |~SUCCESS~" >> /work/DQ/DQdatafiles/PANORAMA/Target/$v_batch_id'_STATUS.txt'
else
echo "Total feed count is not 14 |~FAILURE~" >> /work/DQ/DQdatafiles/PANORAMA/Target/$v_batch_id'_STATUS.txt'
fi

f_gen_log "Individual target count check with BD count from interediate audit file...."
###############################################Target count check with Interim Audit file#####################################################################################

v_audit_file=$target_file_path'/Panorama_Audit_Table_DQ_Interim_Local.csv'
AUDIT_FILE=$v_audit_file
IFS='|'
while read  BATCH_ID FILE_ID BUS_PROC_DT USER_ID SOURCE_FILE_NAME CONTROL_FILE_NAME ENTITY_NAME ARCHIVE_FILE_NAME BD_LOAD_DT BD_LOAD_START_TIME BD_LOAD_END_TIME BD_COUNT_DATA_FILE BD_COUNT_CTRL_FILE BD_STAT_CD BD_STAT_DSCR DQ_LOAD_START_TIME DQ_LOAD_END_TIME DQ_COUNT_DATA_FILE DQ_ERR_COUNT DQ_STAT_CD DQ_STAT_DSCR
do
  if [ "$BD_COUNT_DATA_FILE" = "$DQ_COUNT_DATA_FILE" ] ;
  then
    v_FLAG="SUCCESS" 
echo "for file $SOURCE_FILE_NAME BD count is $BD_COUNT_DATA_FILE and DQ count is $DQ_COUNT_DATA_FILE |~$v_FLAG~ " >> /work/DQ/DQdatafiles/PANORAMA/Target/$v_batch_id'_STATUS.txt'

else
     v_FLAG="FAILURE"
echo "for file $SOURCE_FILE_NAME BD count is $BD_COUNT_DATA_FILE and DQ count is $DQ_COUNT_DATA_FILE |~$v_FLAG~ " >> /work/DQ/DQdatafiles/PANORAMA/Target/$v_batch_id'_STATUS.txt'


fi
  done < $AUDIT_FILE


#chmod 777 /work/DQ/DQdatafiles/PANORAMA/Target/$v_batch_id'_STATUS.txt'

f_gen_log "Replacing the parameters for in wf_DQ_PNRM_Target_Audit_Check_Runtime file...."
###############################################################################################################################################
######################################Target count check with Bigdata audit table #######################################################################

sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_ReplaceParam_Target_Audit_Check.sh

#############################################################################################################

date=`date +%Y%m%d`
WF_NAME='wf_DQ_PNRM_Target_Audit_Check'
RUNTIME_PARAM_FILE='wf_DQ_PNRM_Target_Audit_Check_Runtime_'$date'.xml'

#############################################################################################################
f_gen_log  "Invoking Workflow invokaton script: DQ_PNRM_WF_Invoke.sh for Individual target and audit count check"

f_gen_log "Individual target count check with BD count after all the out files are generated in bigdata...."

sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_WF_Invoke.sh $WF_NAME $RUNTIME_PARAM_FILE true

#############################################################################################################

cd $target_file_path
echo `cat Count_Status.txt >> $v_batch_id'_STATUS.txt'`

v_status_filenm=$v_batch_id'_STATUS.txt'
v_status_count=`cat $target_file_path/$v_status_filenm |grep -c 'FAILURE'`
v_out_record_count=`cat $target_file_path/'COUNT_STATUS.txt' |grep -c 'Fail'`
Complete_done=$v_batch_id'_PANORAMA_DQ_COMPLETE.done'
v_status_file_dts=$target_file_path/$v_status_filenm

if [ $v_status_count = 0 -a $v_count_RunTime = $v_count_Audit ] 
then 
echo -e "Please Find Attached Audit Count Details Report......" | mailx -s "$var_subject_audit $var_ENV " -a $v_status_file_dts $ALL_Vldtn_success_mailid_list
cp $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done $etltrig_file_path/$Complete_done
chmod 777 $etltrig_file_path*.*  

f_gen_log "All Validation Workflows have been executed....."
echo -e "All Validation Workflows have been executed.....\nDate_Timestamp : $checker_timestamp \n\n" | mailx -s "$var_subject_ALL_Vldtn_success $var_ENV" $ALL_Vldtn_success_mailid_list
 
else
echo -e "Please Find Attached Audit Count Details Report......" | mailx -s "$var_subject_audit_error $var_ENV " -a $v_status_file_dts  $ALL_Vldtn_success_mailid_list
echo "Panorama Audit count validation failed...."
f_gen_log "Panorama Audit count validation failed...."
exit 2
fi

fi
else
  f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
  echo "Source File Base $v_source_file_runtime does not exist in Metafile directory" 
  exit 98
fi

#####################################archiving current status file######################################################################
#mv $target_file_path/$v_status_filenm $archive_file_path/$v_status_filenm'_'$dt
#mv $target_file_path/'Count_Status.txt' $archive_file_path/'Count_Status.txt_'$dt'.txt' 


