##########################################################################################################
# File Name                  Developer                       Create On                                   #
# DQ_PNRM_TrackFileLoadCompletion.sh          Cognizant DQ Developent Team           01-Jun-2017     #
# Version History:                                                                                       #
# 1.1 - 01-Sep-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

cd $meta_file_path

### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_TrackFileLoadCompletion_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile
#echo $logdirnfile

###Log File Function
f_gen_log()
{
log_time=`date`
## commented can be used for debugging ---- echo "$log_time ----- $1" ">> $logdirnfile"
echo -e "$log_time ----- $1" >> $logdirnfile
}

v_FileLoadTracker=$logdir'/DQ_PANORAMA_FileLoadTrack.txt'
f_gen_log "$1|$2|$3|$checker_timestamp"

v_BASE_FILE_NM=$1
v_SOURCE_FILE_NAME_RUNTM=$2
v_TARGET_FILENAME_RUNTM=$3
v_LEVEL=$4

################################## Making entry for .done file    ##################################
v_source_file_done_runtime=$meta_file_path'/DQ_PANORAMA_Source_File_Metadata_RunTime.done'
touch $v_source_file_done_runtime
chmod 777 $v_source_file_done_runtime

echo "$v_BASE_FILE_NM,$v_SOURCE_FILE_NAME_RUNTM,$v_TARGET_FILENAME_RUNTM,$v_LEVEL,1>>$v_source_file_done_runtime"
f_gen_log "$v_BASE_FILE_NM,$v_SOURCE_FILE_NAME_RUNTM,$v_TARGET_FILENAME_RUNTM,$v_LEVEL,1>>$v_source_file_done_runtime"
echo "$v_BASE_FILE_NM,$v_SOURCE_FILE_NAME_RUNTM,$v_TARGET_FILENAME_RUNTM,$v_LEVEL,1">>$v_source_file_done_runtime
f_gen_log "Creating entry for file $2 in PANORAMA RunTime .done file"
################################ End of Making entry for .done file  ###############################


echo $2 >> $v_FileLoadTracker

################################ Beginning of Mail Notification  ###############################

f_gen_log "BASE_FILE_NAME : $1"
f_gen_log "RUNTIME_SOURCE_FILENAME : $2"

BASE_FILENAME=$1
RUNTIME_SOURCE_FILENAME=$2

          RUNTIME_Err_Summary=$error_file_path${RUNTIME_SOURCE_FILENAME/.dat/_err_smry.dat}
          f_gen_log "Runtime Error Summary File : $RUNTIME_Err_Summary"

   if [ -s $RUNTIME_Err_Summary ]
   then
	  cat $RUNTIME_Err_Summary | while IFS="|" read NEG_FILENAME BATCH FILE IBDW 
	  do
	   
	   f_gen_log "NEG_FILENAME : $NEG_FILENAME"
	   f_gen_log "BATCH ID : $BATCH"
	   f_gen_log "FILE ID : $FILE"
	   f_gen_log "IBDW : $IBDW"
	   v_STATIC_FILENAME_PART=`echo $NEG_FILENAME | sed -e 's/csctomet_tst_pol_//g'`
	   v_DATE=${v_STATIC_FILENAME_PART: -16}
	   v_FEEDNAME=`echo $v_STATIC_FILENAME_PART | sed -e "s/$v_DATE//g"`
	   
	  case $v_FEEDNAME in
	hld)
		v_FEED_NAME="Holding"
		;;
	hld_dt)
		v_FEED_NAME="Holding Date"
		;;
	hld_ms)
		v_FEED_NAME="Holding Measures"
		;;
    hld_cmpnt_ms)
		v_FEED_NAME="Holding Component Measures"
		;;
    hld_cmpnt)
		v_FEED_NAME="Holding Components"
		;;
    hld_fin_tran)
		v_FEED_NAME="Holding Fin Tran"
		;;
    hld_ins_uw)
		v_FEED_NAME="Holding Insured Underwriting"
		;;
    hld_inv_veh_tran)
		v_FEED_NAME="Holding Inv Veh Fin Tran"
		;;
    hld_inv_veh)
		v_FEED_NAME="Holding Inv Veh"
		;;
    hld_ln_ms)
		v_FEED_NAME="Holding Loan Measures"
		;;
    hld_ln)
		v_FEED_NAME="Holding Loans"
		;;		
	hld_prdcr)
		v_FEED_NAME="Holding Producer"
		;;	
	hld_role_rgst)
		v_FEED_NAME="Holding Role Registration"
       		;;
         hld_restr)
		v_FEED_NAME="Holding Restrictions"
       		;;	
	
	*)
		echo " " 
		;;
  esac

	   
	     if [ "$IBDW" -gt "0" ]
		then
		  f_gen_log "DQ Error Notification sent for $RUNTIME_SOURCE_FILENAME"
                  echo -e "DQ Error Notification for the following file: $RUNTIME_SOURCE_FILENAME\nDQ Error Count: $IBDW\nDate_Timestamp : $checker_timestamp \n\n" | mailx -s "$var_subject_IBDW_error for $v_FEED_NAME $var_ENV " $IBDW_error_mailid_list
	        else
		  f_gen_log "DQ Success Notification sent for $RUNTIME_SOURCE_FILENAME"
                  echo -e "DQ Success Notification for the following file: $RUNTIME_SOURCE_FILENAME\nDQ Error Count: $IBDW\nDate_Timestamp : $checker_timestamp \n\n" | mailx -s "$var_subject_IBDW_success for $v_FEED_NAME $var_ENV" $IBDW_success_mailid_list
	     fi

	    
			 
	     
			
			 
	  done
   else
   f_gen_log "Runtime Error Summary File $RUNTIME_Err_Summary not found."
   fi

################################ End of Mail Notification  ###############################
  
f_gen_log  "End of Script"

