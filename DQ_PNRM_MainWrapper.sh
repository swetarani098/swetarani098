#DQ_PNRM_MainWrapper1.sh    Cognizant DQ Developent Team                          05-Jul-2017      #
# Version History:                                                                                       #
# 1.1 - 05-Jul-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_MainWrapper1_'$checker_timestamp'.log'
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

#########################################################################################################

f_gen_log "Source is being processed.."
#echo 1.1
v_trigger_file_BD=$bdtrig_file_path'/*.done' 
#echo $v_trigger_file_BD
export varFileExist='0'
#echo 1.2
#echo $v_source_file_runtime
ifFileExist $v_trigger_file_BD
#echo 1.25
echo "var=$varFileExist"

##### IF at line 58 starts here #####
if [ $varFileExist = '1' ]
then
#echo 1.3
  f_gen_log "Bigdata Trigger file $v_trigger_file_BD exists in directory $bdtrig_file_path"
  
######################################################################################################################################
f_gen_log "Execution of PreProcessor workflow will now be invoked.."
f_gen_log "********** SECTION 1 OF THE SCRIPT STARTED **************"
######################################################################################################################################

sh $script_file_path/DQ_PNRM_PreProcessor.sh

fi
#sleep 0.5m
######################################################################################################################################
f_gen_log "Execution of BPD workflow will now be invoked............"
f_gen_log "********** SECTION 1 OF THE SCRIPT STARTED **************"
######################################################################################################################################

v_metadata_runtime_file=$meta_file_path'/DQ_PANORAMA_Source_File_Metadata_RunTime.csv' 
#echo $v_trigger_file_BD
export varFileExist='0'
#echo 1.2
#echo $v_source_file_runtime
ifFileExist $v_metadata_runtime_file
#echo 1.25
echo "var=$varFileExist"

##### IF at line 58 starts here #####
if [ $varFileExist = '1' ]
then


sh $script_file_path/DQ_PNRM_PreProcessor_BPDCheck.sh
# sleep 0.5m
 f_gen_log "Execution of BPD workflows are completed............"
 echo "Execution of BPD workflows are completed............"
cd $target_file_path
v_BPD_check=`cat BPD_DistCnt.txt`

echo $v_BPD_check
cat $target_file_path/BPD_DistCnt.txt

if [ $v_BPD_check = 1 ];
then
 
 cd $target_file_path
 echo -e "Unique Business Process date present among the files......" | mailx -s "$var_subject_BPD_succ $var_ENV" -a BPD_DtlsStatusFile.csv $BPD_error_mailid_list
 echo "Unique Business Process date present among the files...."
 f_gen_log "Unique Business Process date present among the files...."


######################################################################################################################################
f_gen_log "Execution of PK & RI workflows will now be invoked............"
f_gen_log "********** SECTION 2 OF THE SCRIPT STARTED **************"
######################################################################################################################################

 sh $script_file_path/DQ_PNRM_SubWrapper_PKRICheck.sh
 
 f_gen_log "Execution of PK & RI workflows are completed............"
 echo "Execution of PK & RI workflows are completed............"
# sleep 0.5m
######################################################################################################################################
f_gen_log "Execution of RowValidation workflows for 13 tables will now be invoked............"
f_gen_log "********** SECTION 3 OF THE SCRIPT STARTED **************"
######################################################################################################################################
 sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_Wrapper_RowValdtn.sh
 f_gen_log "sh $script_file_path/DQ_PNRM_Wrapper_RowValdtn.sh"

#sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_Financial_Error.sh
#f_gen_log "sh $script_file_path/DQ_PNRM_Financial_Error.sh"

else 

 
 echo "Different Business Process date present among the files...."
 f_gen_log "More than one Business Process date present among the files......"
 
 cd $target_file_path
echo -e "More than one Business Process date present among the files......" | mailx -s "$var_subject_BPD_error $var_ENV" -a BPD_DtlsStatusFile.csv $BPD_error_mailid_list

#echo -e "More than one Business Process date present among the files......" | mailx -s "$var_subject_BPD_error $var_ENV" -a BPD_DtlsStatusFile.csv 'mandira.dewanjee@metlife.com'
	        
 exit 1
 
 fi

fi


f_gen_log  "End of Script"


