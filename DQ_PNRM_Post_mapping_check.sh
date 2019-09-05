##########################################################################################################
# File Name                                      Developer                              Create On        #
# DQ_PNRM_Post_mapping_check.sh                  Cognizant DQ Developent Team           24-May-2017      #
# Version History:                                                                                       #
# 1.1 - 24-May-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/FIRST/Param/env_file_PNRM.parm

cd $meta_file_path

### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_'$4'_post_mapping_check_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile
#echo $logdirnfile

###Log File Function
f_gen_log()
{
log_time=`date`
## commented can be used for debugging ---- echo "$log_time ----- $1" ">> $logdirnfile"
echo -e "$log_time ----- $1" >> $logdirnfile
}

f_gen_log "----Script Arguments----"
f_gen_log "argument 1["'${var:v_map_start_time}'"]: $1"
f_gen_log "argument 2["'${var:v_map_end_time}'"]: $2"
f_gen_log "argument 3["'${var:v_seg_null}'"]: $3"
f_gen_log "argument 4["'${var:v_check_map_name}'"]: $4"
f_gen_log "argument 5["'${var:v_source_system_name}'"]: $5"
f_gen_log "argument 6["'${par:Source_File_Name}'"]: $6"
f_gen_log "argument 7["'${par:Control_File_Name}'"]: $7"
f_gen_log "argument 8["'${par:Column_Header_File}'"]: $8"
f_gen_log "argument 9["'${par:failure_file}'"]: $9"
f_gen_log "argument 10["'${par:success_file}'"]: ${10}"
f_gen_log "argument 11["'${par:error_file}'"]: ${11}"

### Checking for Mapping Failure
f_gen_log "----Starting to check whether the Informatica mapping is completed without runtime errors----"
if [ "$3" = "true" ];
then
        f_gen_log "--Mapping Name : $4 has run successfully--"

else
        f_gen_log "--Mapping Name : $4 has failed with runtime errors--"
        exit 1
fi

f_gen_log  "End of Script"
