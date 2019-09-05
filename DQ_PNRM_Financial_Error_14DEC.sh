##########################################################################################################
# File Name                  Developer                       Create On                                   #
# DQ_PNRM_Financial_Error.sh          Cognizant DQ Developent Team          13-APR-2018     #
# Version History:                                                                                       #
# 1.1 - 11-APR-18 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

date=`date +%Y%m%d`
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_Financial_Transaction_Error_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile

dt=$(date +%Y%m%d%H%M%S)

f_gen_log()
{
PNRM_logtm=`date`
echo "$PNRM_logtm ----- $1" >> $logdirnfile
}

f_gen_log "Financial Transaction Error is started.."

cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.csv | grep csctomet_tst_pol_hld_fin_tran |grep ',2,1'> $error_file_path/temp1.txt
cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.csv | grep csctomet_tst_pol_hld_fin_tran |grep ',3,1'> $error_file_path/temp2.txt  
chmod 777 /work/DQ/DQdatafiles/PANORAMA/Error/temp1.txt
chmod 777 /work/DQ/DQdatafiles/PANORAMA/Error/temp2.txt



v_temp_file1=$error_file_path/temp1.txt

var_path1=$parm_file_path/wf_DQ_PNRM_Param_Financial_Error1_$date.xml 
var_path=$parm_file_path/wf_DQ_PNRM_Param_Financial_Error_Runtime_$date.xml 

INPUT_FILE=$v_temp_file1
  IFS=','

  while read SOURCE_SYSTEM_NAME BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME WORK_FLOW_NAME_ERR PARAMETER_FILE_NAME_ERR PARENT_FILE_NAME GRANDPARENT_FILE_NAME LEVEL DUMMY

  do

    v_STATIC_FILENAME_PART=`echo $SOURCE_FILE_NAME | sed -e 's/_YYYYMMDD_01.dat//g'`
    v_STATIC_FILENAME_PART_WITHDT=`echo $SOURCE_FILE_NAME_RUNTM | sed -e 's/.dat//g'`
    v_TARGET_FILENAME_RUNTM=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT'.dat'
     v_BATCH_ID_FILE_ID_ERROR_FILENAME_RUNTM_BASE=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT
      v_interim_file_bkp=$v_STATIC_FILENAME_PART_WITHDT'_interim_error_out.dat'
   
cp $target_file_path/$v_interim_file_bkp $archive_file_path/$v_interim_file_bkp'_'$dt'_bkp'

cp $parm_file_path/wf_DQ_PNRM_Param_Financial_Error.xml $var_path1

sed -i -e "s/~1target_file_name_runtime~/$v_TARGET_FILENAME_RUNTM/g" $var_path1
sed -i -e "s/~2source_file_name_static_part_withdt~/$v_STATIC_FILENAME_PART_WITHDT/g" $var_path1
 
done<$INPUT_FILE 

f_gen_log "Updating parameter file for hld_fin_tran...."

v_temp_file2=$error_file_path/temp2.txt

 
INPUT_FILE1=$v_temp_file2
  IFS=','

  while read SOURCE_SYSTEM_NAME BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME WORK_FLOW_NAME_ERR PARAMETER_FILE_NAME_ERR PARENT_FILE_NAME GRANDPARENT_FILE_NAME LEVEL DUMMY

  do

    v_STATIC_FILENAME_PART=`echo $SOURCE_FILE_NAME | sed -e 's/_YYYYMMDD_01.dat//g'`
    v_STATIC_FILENAME_PART_WITHDT=`echo $SOURCE_FILE_NAME_RUNTM | sed -e 's/.dat//g'`
    v_TARGET_FILENAME_RUNTM=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT'.dat'
     v_BATCH_ID_FILE_ID_ERROR_FILENAME_RUNTM_BASE=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT
     v_interim_file_bkp1=$v_STATIC_FILENAME_PART_WITHDT'_interim_error_out.dat'

cp $target_file_path/$v_interim_file_bkp1 $archive_file_path/$v_interim_file_bkp1'_'$dt'_bkp'


cp $var_path1 $var_path

sed -i -e "s/~3target_file_name_runtime~/$v_TARGET_FILENAME_RUNTM/g" $var_path
sed -i -e "s/~4source_file_name_static_part_withdt~/$v_STATIC_FILENAME_PART_WITHDT/g" $var_path


    
done<$INPUT_FILE1

f_gen_log "Updating parameter file for hld_inv_veh_fin_tran...."

cp $var_path $archive_file_path/'BKP_wf_DQ_PNRM_Param_Financial_Error_Runtime_'$dt'.xml'


sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn DMN_GRID_DQ_DEV -sn DIS_SVC_DQ_DEV -un GPMBatch -pd metlife123 -a app_fintran -wf wf_DQ_PNRM_Financial_Error -w true -pf $parm_file_path/wf_DQ_PNRM_Param_Financial_Error_Runtime_$date.xml 

#sh $script_file_path/DQ_PNRM_WF_Invoke.sh wf_DQ_PNRM_Financial_Error wf_DQ_PNRM_Param_Financial_Error_Runtime_$date.xml 
f_gen_log "Financial Transaction Error is completed.."