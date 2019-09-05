#!/bin/bash

####***************************************************************************************************************************####
##SCRIPT FILE NAME: DQ_PNRM_ReplaceParam_Target_Audit_Check.sh
##Description: Replaces Audit and target parameter values in Panorama paramter file
##AUTHOR: Metlife DQ Team
##DATE OF CREATION: 11 June, 2018
####***************************************************************************************************************************####

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

date=`date +%Y%m%d`
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_ReplaceParam_Target_Audit_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile

f_gen_log()
{
PNRM_logtm=`date`
echo "$PNRM_logtm ----- $1" >> $logdirnfile
}


RUNTIME_FILEPATH='/work/DQ/DQdatafiles/PANORAMA/Metadata/'
RUNTIME_FILENAME='DQ_PANORAMA_Source_File_Metadata_RunTime.csv'

RUNTIME_LC=`grep -c ^ $RUNTIME_FILEPATH$RUNTIME_FILENAME`
PARAMETER_FILE_PATH='/work/DQ/DQdatafiles/PANORAMA/Param/'
PARAMETER_FILE_NAME='wf_DQ_PNRM_Target_Audit_Check_BASE_PARAM.xml'
RUNTIME_PARAMETER_FILE=$parm_file_path/wf_DQ_PNRM_Target_Audit_Check_Runtime_$date.xml 


f_gen_log "Runtime Pararmeter File : $RUNTIME_PARAMETER_FILE"
f_gen_log "Copying original parameter file to create a runtime parameter file"

      cp $PARAMETER_FILE_PATH$PARAMETER_FILE_NAME $RUNTIME_PARAMETER_FILE

if [[ "$RUNTIME_LC" -gt "0" ]]
  then
    cat $RUNTIME_FILEPATH$RUNTIME_FILENAME | while IFS="," read SOURCE_SYSTEM BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORKFLOW_NAME PARAMETER_FN WORKFLOW_NAME_ERR PARAMETER_FN_ERR DUMMY
    do

f_gen_log "Replacing parameters in runtime parameter file : $RUNTIME_PARAMETER_FILE"
f_gen_log "SOURCE_SYSTEM : $SOURCE_SYSTEM"
f_gen_log "BASE_FILE_NAME : $BASE_FILE_NAME"
f_gen_log "SOURCE_FILE_NAME : $SOURCE_FILE_NAME"
f_gen_log "CONTROL_FILE_NAME : $CONTROL_FILE_NAME"
f_gen_log "APPLICATION_NAME : $APPLICATION_NAME"
f_gen_log "WORKFLOW_NAME : $WORKFLOW_NAME"
f_gen_log "PARAMETER_FILE_NAME : $PARAMETER_FILE_NAME"

          v_STATIC_FILENAME_PART=`echo $SOURCE_FILE_NAME | sed -e 's/_YYYYMMDD_01.dat//g'`
          v_RUNTM_FILENAME_PART_WITHDT=`echo $SOURCE_FILE_NAME_RUNTM | sed -e 's/.dat//g'`
          v_TARGET_FILENAME_RUNTM=$BATCH_ID'_'$FILE_ID'_'$v_RUNTM_FILENAME_PART_WITHDT
          v_audit_filename=$BATCH_ID'_pan_audit.txt'
          v_status_filename=$BATCH_ID'_STATUS.txt'

#echo 	sed -i -e "s/~$BASE_FILE_NAME~/$v_TARGET_FILENAME_RUNTM/g" $RUNTIME_PARAMETER_FILE

          sed -i -e "s/~$BASE_FILE_NAME~/$v_TARGET_FILENAME_RUNTM/g" $RUNTIME_PARAMETER_FILE
          sed -i -e "s/~audit_table~/$v_audit_filename/g" $RUNTIME_PARAMETER_FILE
          sed -i -e "s/~status_file~/$v_status_filename/g" $RUNTIME_PARAMETER_FILE

          

    done

  else
  
    f_gen_log "Static File not found"

fi

f_gen_log "End of replace param for Audit and Target"

