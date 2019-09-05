. /work/DQ/DQdatafiles/PANORAMA/Param_Error_Recon/env_file_PNRM.parm

cd $meta_file_path

### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_Test_Mail_'$checker_timestamp'.log'
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

cd $error_file_path
date=`date +%Y%m%d`
v_mail='cat Error_mail_format.txt'

f_gen_log "Sending error mail ......"
echo -e "Please Find Attached Error Report......" | mailx -s "$var_subject_Test_Mail $var_ENV" -a Error_mail_format.txt $Test_Mail_error_mailid_list
echo $v_mail | mailx -s "$var_subject_Test_Mail $var_ENV" -a Error_mail_format.txt $Test_Mail_error_mailid_list

