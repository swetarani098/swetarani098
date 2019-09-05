##########################################################################################################
# File Name                       Developer                                             Create On        #
# DQ_PNRM_ErrorNormalizer.sh    Cognizant DQ Developent Team                          01-Jun-2017      #
# Version History:                                                                                       #
# 1.1 - 01-Jun-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

cd $meta_file_path

### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_Error_Notification_'$checker_timestamp'.log'
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
f_gen_log "Start of Error Notification Script.."
cd $error_file_path
var1=`cat Error_STATUS_Final.txt|grep -c 'FAILURE'`


if [ $var1 = 1 ]
then 
f_gen_log "Errors are present in consolidated error file......"
mv $error_file_path/Error_STATUS_Final.txt $archive_file_path/'Error_STATUS_Final_'$dt'.txt'
exit 95
else
f_gen_log "No error found in consolidated error file......"
mv $error_file_path/Error_STATUS_Final.txt $archive_file_path/'Error_STATUS_Final_'$dt'.txt'

fi


#echo $var_status
f_gen_log "End of Error Notification Script.."