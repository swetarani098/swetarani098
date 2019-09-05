#DQ_PNRM_MainWrapper3.sh    Cognizant DQ Developent Team                          05-Jul-2017      #
# Version History:                                                                                       #
# 1.1 - 05-MAR-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

### Script variables
date=`date +%Y%m%d`
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_ErrorReconciliation_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile
#echo $logdirnfile

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
f_gen_log "Error reconciliation is started.."
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
f_gen_log "Execution of error reconciliation is started.."

######################################################################################################################################

new_filename=`cut -d',' -f4 /work/DQ/DQdatafiles/PANORAMA/Metadata/DQ_PANORAMA_Source_File_Metadata_RunTime.csv| head -1` 

var_path=/work/DQ/DQdatafiles/PANORAMA/Param/wf_DQ_PNRM_Param_ErrorRecon_Runtime_$date.xml 

cp /work/DQ/DQdatafiles/PANORAMA/Param/wf_DQ_PNRM_Param_ErrorRecon.xml $var_path

sed -i -e "s/~1hld_file_name_runtime~/$new_filename/g" $var_path


sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn DMN_GRID_DQ_DEV -sn DIS_SVC_DQ_DEV -un GPMBatch -pd metlife123 -a app_panorama_error_recon -wf wf_DQ_PNRM_ErrorRecon -w true -pf /work/DQ/DQdatafiles/PANORAMA/Param/wf_DQ_PNRM_Param_ErrorRecon_Runtime_$date.xml

#sh $script_file_path/DQ_PNRM_WF_Invoke.sh wf_DQ_PNRM_ErrorRecon wf_DQ_PNRM_Param_ErrorRecon_Runtime_$date.xml true

f_gen_log "error reconciliation is completed.."

cd /work/DQ/DQdatafiles/PANORAMA/Error/
var2=`cat correction_request_feed.txt|wc -l`

if [ ${var2} -gt 0 ]
then 
echo -e "Please Find the Attached Correction Request feed......" | mailx -s "$var_subject_correction_req_error $var_ENV" -a correction_request_feed.txt $Corr_req_mailid_list
else
echo -e "No Correction Required." | mailx -s "$var_subject_correction_req_success $var_ENV" $Corr_req_mailid_list
fi

sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_Error_Metric.sh

fi
else
  f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
echo 99
fi