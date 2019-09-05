##########################################################################################################
# File Name                       Developer                                             Create On        #
# DQ_PNRM_Wrapper_RowValdtn.sh    Cognizant DQ Developent Team                          01-Jun-2017      #
# Version History:                                                                                       #
# 1.1 - 01-Jun-17 - Initial version                                                                      #
##########################################################################################################

. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

cd $meta_file_path

### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_Wrapper_RowValdtn_'$checker_timestamp'.log'
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
f_gen_log "Execution of Individual DQ Validation workflows will now be invoked.."
f_gen_log "****************************** SECTION 1 OF THE SCRIPT STARTED ***********************************"
######################################################################################################################################
f_gen_log "Check the number of parent,child and grand child tables........"
echo "Check the number of parent,child and grand child tables......."

v_PARENT_FILE_CNT=0
v_CHILD_FILE_CNT=0
v_GRANDCHILD_FILE_CNT=0

INPUT_FILE=$v_source_file_runtime
IFS=','
while read SOURCE_SYSTEM_NAME BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME WORK_FLOW_NAME_ERR PARAMETER_FILE_NAME_ERR PARENT_FILE_NAME GRANDPARENT_FILE_NAME LEVEL DUMMY
do
#echo "$LEVEL"
    if [ "$LEVEL" = "1" ];then
    v_PARENT_FILE_CNT=`expr $v_PARENT_FILE_CNT + 1`
#echo "$v_PARENT_FILE_CNT"
fi
    if [ "$LEVEL" = "2" ];then
    v_CHILD_FILE_CNT=`expr $v_CHILD_FILE_CNT + 1`
#echo "$v_CHILD_FILE_CNT"
fi
    if  [ "$LEVEL" = "3" ];then
    v_GRANDCHILD_FILE_CNT=`expr $v_GRANDCHILD_FILE_CNT + 1`
#echo "$v_GRANDCHILD_FILE_CNT"
    fi
done < $INPUT_FILE


echo "v_PARENT_FILE_CNT : $v_PARENT_FILE_CNT"
echo "v_CHILD_FILE_CNT : $v_CHILD_FILE_CNT"
echo "v_GRANDCHILD_FILE_CNT : $v_GRANDCHILD_FILE_CNT"
############################## PARENT workflows #############################
f_gen_log "Execution of Individual DQ Validation PARENT workflows will now be invoked.."

  INPUT_FILE=$v_source_file_runtime
  IFS=','
#echo 1.4
  while read SOURCE_SYSTEM_NAME BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME WORK_FLOW_NAME_ERR PARAMETER_FILE_NAME_ERR PARENT_FILE_NAME GRANDPARENT_FILE_NAME LEVEL DUMMY

  do
#echo 2

if [ "$LEVEL" = "1" ]
then
    f_gen_log "#Parameters#"
    f_gen_log  "SOURCE_SYSTEM_NAME: $SOURCE_SYSTEM_NAME"
    f_gen_log  "BATCH_ID: $BATCH_ID"
    f_gen_log  "FILE_ID: $FILE_ID"
    f_gen_log  "SOURCE_FILE_NAME_RUNTM: $SOURCE_FILE_NAME_RUNTM"
    f_gen_log  "CONTROL_FILE_NAME_RUNTM: $CONTROL_FILE_NAME_RUNTM"
    f_gen_log  "BASE_FILE_NAME: $BASE_FILE_NAME"
    f_gen_log  "SOURCE_FILE_NAME: $SOURCE_FILE_NAME"
    f_gen_log  "CONTROL_FILE_NAME: $CONTROL_FILE_NAME"
    f_gen_log  "APPLICATION_NAME: $APPLICATION_NAME"
    f_gen_log  "WORK_FLOW_NAME: $WORK_FLOW_NAME"
    f_gen_log  "PARAMETER_FILE_NAME: $PARAMETER_FILE_NAME"
    f_gen_log  "WORK_FLOW_NAME_ERR: $WORK_FLOW_NAME_ERR"
    f_gen_log  "PARAMETER_FILE_NAME_ERR: $PARAMETER_FILE_NAME_ERR"
    f_gen_log  "PARENT_FILE_NAME: $PARENT_FILE_NAME"
    f_gen_log  "GRANDPARENT_FILE_NAME: $GRANDPARENT_FILE_NAME"
    f_gen_log  "LEVEL: $LEVEL"

#echo 3	
#   v_DQ_PNRM_RUNTIME_filewise_source_file_runtm=`sed "s/.txt/.csv/g" <<< "DQ_PNRM_RUNTIME_$SOURCE_FILE_NAME_RUNTM"`
    v_STATIC_FILENAME_PART=`echo $SOURCE_FILE_NAME | sed -e 's/_YYYYMMDD_01.dat//g'`
    v_STATIC_FILENAME_PART_WITHDT=`echo $SOURCE_FILE_NAME_RUNTM | sed -e 's/.dat//g'`
    #v_TARGET_FILENAME_RUNTM=$v_STATIC_FILENAME_PART_WITHDT'_'$BATCH_ID'_'$FILE_ID'.dat'
    v_TARGET_FILENAME_RUNTM=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT'.dat'
    v_DATE=${v_STATIC_FILENAME_PART_WITHDT: -11}
    v_PARENT_FILENAME=`echo $PARENT_FILE_NAME | sed -e "s/YYYYMMDD_01/$v_DATE/g"`
    v_GRANDPARENT_FILENAME=`echo $GRANDPARENT_FILE_NAME | sed -e "s/YYYYMMDD_01/$v_DATE/g"`
	
	echo "$v_PARENT_FILENAME $v_GRANDPARENT_FILENAME"
echo $v_STATIC_FILENAME_PART_WITHDT

    v_DQ_PNRM_RUNTIME_filewise_source_file_runtm="DQ_PNRM_RUNTIME_$v_STATIC_FILENAME_PART_WITHDT.csv"
    f_gen_log  "Here is the file: $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
    f_gen_log  "Creating Runtime Source File Metadata Information in file $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
    echo "$SOURCE_SYSTEM_NAME,$BATCH_ID,$FILE_ID,$SOURCE_FILE_NAME_RUNTM,$CONTROL_FILE_NAME_RUNTM,$BASE_FILE_NAME,$SOURCE_FILE_NAME,$CONTROL_FILE_NAME,$APPLICATION_NAME,$WORK_FLOW_NAME,$PARAMETER_FILE_NAME,$WORK_FLOW_NAME_ERR,$PARAMETER_FILE_NAME_ERR,$DUMMY" > "$v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
#echo 4  
    f_gen_log  "Updating Param file"

    BASE_PARAM_FILE_NAME="$BASE_FILE_NAME"'_BASE_PARAM.xml'

#echo $BASE_PARAM_FILE_NAME

    f_gen_log "cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME"

    cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME

    f_gen_log  "Base Param File Name $BASE_PARAM_FILE_NAME"
    f_gen_log "sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM"
echo "sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM"

    sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $parm_file_path'/'$PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM v_PARENT_FILENAME v_GRANDPARENT_FILENAME $LEVEL
    f_gen_log  "Calling Workflow"

echo "sh DQ_PNRM_WF_Invoke.sh $WORK_FLOW_NAME $PARAMETER_FILE_NAME" 
    sh $script_file_path/DQ_PNRM_WF_Invoke.sh $WORK_FLOW_NAME $PARAMETER_FILE_NAME

    f_gen_log "Archiving Param file $PARAMETER_FILE_NAME file to $archive_file_path"
#    mv $parm_file_path/$PARAMETER_FILE_NAME $archive_file_path/$PARAMETER_FILE_NAME
fi
 
  done < $INPUT_FILE

#sleep 1m
######################################################################################################################################
# Check if all PARENT Level1 DQ validation workflows completed or not 
######################################################################################################################################
var_cnt=60
var_i=1

f_gen_log()
{
log_time=`date`
echo -e "$log_time ----- $1" >> $logdirnfile
}

f_gen_log "Verification Processing started to check if Parent DQ Validation workflow run is complete or not.."
while [ $var_i -le $var_cnt ] 
do



  ##LineCount of .done file
  LC_dotDone=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done | awk 'BEGIN {FS = ","}; {if ( $4==1 ) sum=sum+1} END {print sum}'`

  if [ $v_PARENT_FILE_CNT = $LC_dotDone ]
  then
    f_gen_log "Number of entries in Runtime file=$v_PARENT_FILE_CNT is now equals number of files processed=$LC_dotDone as per .done file"
    
    var_i=$var_cnt
  fi
  sleep 1m
  f_gen_log "var_i := $var_i, Workflows are still running."
  var_i=`expr $var_i + 1`
  if [ $var_i -gt $var_cnt ] 
  then
    f_gen_log "var_i := $var_i, Workflow Run is complete"  
  fi
done

############################## CHILD workflows #############################
  
 f_gen_log "Execution of Individual DQ Validation CHILD workflows will now be invoked.."

  INPUT_FILE=$v_source_file_runtime
  IFS=','
#echo 1.4
  while read SOURCE_SYSTEM_NAME BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME WORK_FLOW_NAME_ERR PARAMETER_FILE_NAME_ERR PARENT_FILE_NAME GRANDPARENT_FILE_NAME LEVEL DUMMY

  do
#echo 2

if [ "$LEVEL" = "2" ]
then
    f_gen_log "#Parameters#"
    f_gen_log  "SOURCE_SYSTEM_NAME: $SOURCE_SYSTEM_NAME"
    f_gen_log  "BATCH_ID: $BATCH_ID"
    f_gen_log  "FILE_ID: $FILE_ID"
    f_gen_log  "SOURCE_FILE_NAME_RUNTM: $SOURCE_FILE_NAME_RUNTM"
    f_gen_log  "CONTROL_FILE_NAME_RUNTM: $CONTROL_FILE_NAME_RUNTM"
    f_gen_log  "BASE_FILE_NAME: $BASE_FILE_NAME"
    f_gen_log  "SOURCE_FILE_NAME: $SOURCE_FILE_NAME"
    f_gen_log  "CONTROL_FILE_NAME: $CONTROL_FILE_NAME"
    f_gen_log  "APPLICATION_NAME: $APPLICATION_NAME"
    f_gen_log  "WORK_FLOW_NAME: $WORK_FLOW_NAME"
    f_gen_log  "PARAMETER_FILE_NAME: $PARAMETER_FILE_NAME"
    f_gen_log  "WORK_FLOW_NAME_ERR: $WORK_FLOW_NAME_ERR"
    f_gen_log  "PARAMETER_FILE_NAME_ERR: $PARAMETER_FILE_NAME_ERR"
    f_gen_log  "PARENT_FILE_NAME: $PARENT_FILE_NAME"
    f_gen_log  "GRANDPARENT_FILE_NAME: $GRANDPARENT_FILE_NAME"
    f_gen_log  "LEVEL: $LEVEL"	
#echo 3	
#   v_DQ_PNRM_RUNTIME_filewise_source_file_runtm=`sed "s/.txt/.csv/g" <<< "DQ_PNRM_RUNTIME_$SOURCE_FILE_NAME_RUNTM"`
    v_STATIC_FILENAME_PART=`echo $SOURCE_FILE_NAME | sed -e 's/_YYYYMMDD_01.dat//g'`
    v_STATIC_FILENAME_PART_WITHDT=`echo $SOURCE_FILE_NAME_RUNTM | sed -e 's/.dat//g'`
    #v_TARGET_FILENAME_RUNTM=$v_STATIC_FILENAME_PART_WITHDT'_'$BATCH_ID'_'$FILE_ID'.dat'
    v_TARGET_FILENAME_RUNTM=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT'.dat'
    v_DATE=${v_STATIC_FILENAME_PART_WITHDT: -11}
    v_PARENT_FILENAME=`echo $PARENT_FILE_NAME | sed -e "s/YYYYMMDD_01/$v_DATE/g"`
    v_GRANDPARENT_FILENAME=`echo $GRANDPARENT_FILE_NAME | sed -e "s/YYYYMMDD_01/$v_DATE/g"`
	
echo $v_STATIC_FILENAME_PART_WITHDT

    v_DQ_PNRM_RUNTIME_filewise_source_file_runtm="DQ_PNRM_RUNTIME_$v_STATIC_FILENAME_PART_WITHDT.csv"
    f_gen_log  "Here is the file: $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
    f_gen_log  "Creating Runtime Source File Metadata Information in file $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
    echo "$SOURCE_SYSTEM_NAME,$BATCH_ID,$FILE_ID,$SOURCE_FILE_NAME_RUNTM,$CONTROL_FILE_NAME_RUNTM,$BASE_FILE_NAME,$SOURCE_FILE_NAME,$CONTROL_FILE_NAME,$APPLICATION_NAME,$WORK_FLOW_NAME,$PARAMETER_FILE_NAME,$WORK_FLOW_NAME_ERR,$PARAMETER_FILE_NAME_ERR,$DUMMY" > "$v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
#echo 4  
    f_gen_log  "Updating Param file"

    BASE_PARAM_FILE_NAME="$BASE_FILE_NAME"'_BASE_PARAM.xml'

#echo $BASE_PARAM_FILE_NAME

    f_gen_log "cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME"

    cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME

    f_gen_log  "Base Param File Name $BASE_PARAM_FILE_NAME"
    f_gen_log "sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM"
echo "sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM"

    sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $parm_file_path'/'$PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM  $v_PARENT_FILENAME v_GRANDPARENT_FILENAME $LEVEL
    f_gen_log  "Calling Workflow"

echo "sh DQ_PNRM_WF_Invoke.sh $WORK_FLOW_NAME $PARAMETER_FILE_NAME" 
    sh $script_file_path/DQ_PNRM_WF_Invoke.sh $WORK_FLOW_NAME $PARAMETER_FILE_NAME

    f_gen_log "Archiving Param file $PARAMETER_FILE_NAME file to $archive_file_path"
#    mv $parm_file_path/$PARAMETER_FILE_NAME $archive_file_path/$PARAMETER_FILE_NAME
fi
 
  done < $INPUT_FILE
 # sleep 1m
######################################################################################################################################
# Check if all CHILD Level2 DQ validation workflows completed or not
######################################################################################################################################
var_cnt=60
var_i=1

f_gen_log()
{
log_time=`date`
echo -e "$log_time ----- $1" >> $logdirnfile
}

f_gen_log "Verification Processing started to check if Child DQ Validation workflow run is complete or not.."
while [ $var_i -le $var_cnt ] 
do

  
  ##LineCount of .done file
  LC_dotDone=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done | awk 'BEGIN {FS = ","}; {if ( $4==2 ) sum=sum+1} END {print sum}'`

  if [ $v_CHILD_FILE_CNT = $LC_dotDone ];
  then
    f_gen_log "Number of entries in Runtime file=$v_CHILD_FILE_CNT is now equals number of files processed=$LC_dotDone as per .done file"
    
    var_i=$var_cnt
  fi
  sleep 1m
  f_gen_log "var_i := $var_i, Workflows are still running."
  var_i=`expr $var_i + 1`
  if [ $var_i -gt $var_cnt ] 
  then
    f_gen_log "var_i := $var_i, Workflow Run is complete"  
  fi
done

############################## GRAND CHILD workflows #############################
  
 f_gen_log "Execution of Individual DQ Validation GRAND CHILD workflows will now be invoked.."

  INPUT_FILE=$v_source_file_runtime
  IFS=','
#echo 1.4
  while read SOURCE_SYSTEM_NAME BATCH_ID FILE_ID SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM BASE_FILE_NAME SOURCE_FILE_NAME CONTROL_FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME WORK_FLOW_NAME_ERR PARAMETER_FILE_NAME_ERR PARENT_FILE_NAME GRANDPARENT_FILE_NAME LEVEL DUMMY

  do
#echo 2

if [ "$LEVEL" = "3" ]
then
    f_gen_log "#Parameters#"
    f_gen_log  "SOURCE_SYSTEM_NAME: $SOURCE_SYSTEM_NAME"
    f_gen_log  "BATCH_ID: $BATCH_ID"
    f_gen_log  "FILE_ID: $FILE_ID"
    f_gen_log  "SOURCE_FILE_NAME_RUNTM: $SOURCE_FILE_NAME_RUNTM"
    f_gen_log  "CONTROL_FILE_NAME_RUNTM: $CONTROL_FILE_NAME_RUNTM"
    f_gen_log  "BASE_FILE_NAME: $BASE_FILE_NAME"
    f_gen_log  "SOURCE_FILE_NAME: $SOURCE_FILE_NAME"
    f_gen_log  "CONTROL_FILE_NAME: $CONTROL_FILE_NAME"
    f_gen_log  "APPLICATION_NAME: $APPLICATION_NAME"
    f_gen_log  "WORK_FLOW_NAME: $WORK_FLOW_NAME"
    f_gen_log  "PARAMETER_FILE_NAME: $PARAMETER_FILE_NAME"
    f_gen_log  "WORK_FLOW_NAME_ERR: $WORK_FLOW_NAME_ERR"
    f_gen_log  "PARAMETER_FILE_NAME_ERR: $PARAMETER_FILE_NAME_ERR"
    f_gen_log  "PARENT_FILE_NAME: $PARENT_FILE_NAME"
    f_gen_log  "GRANDPARENT_FILE_NAME: $GRANDPARENT_FILE_NAME"
    f_gen_log  "LEVEL: $LEVEL"
#echo 3	
#   v_DQ_PNRM_RUNTIME_filewise_source_file_runtm=`sed "s/.txt/.csv/g" <<< "DQ_PNRM_RUNTIME_$SOURCE_FILE_NAME_RUNTM"`
    v_STATIC_FILENAME_PART=`echo $SOURCE_FILE_NAME | sed -e 's/_YYYYMMDD_01.dat//g'`
    v_STATIC_FILENAME_PART_WITHDT=`echo $SOURCE_FILE_NAME_RUNTM | sed -e 's/.dat//g'`
    #v_TARGET_FILENAME_RUNTM=$v_STATIC_FILENAME_PART_WITHDT'_'$BATCH_ID'_'$FILE_ID'.dat'
    v_TARGET_FILENAME_RUNTM=$BATCH_ID'_'$FILE_ID'_'$v_STATIC_FILENAME_PART_WITHDT'.dat'
    v_DATE=${v_STATIC_FILENAME_PART_WITHDT: -11}
    v_PARENT_FILENAME=`echo $PARENT_FILE_NAME | sed -e "s/YYYYMMDD_01/$v_DATE/g"`
    v_GRANDPARENT_FILENAME=`echo $GRANDPARENT_FILE_NAME | sed -e "s/YYYYMMDD_01/$v_DATE/g"`
echo $v_STATIC_FILENAME_PART_WITHDT

    v_DQ_PNRM_RUNTIME_filewise_source_file_runtm="DQ_PNRM_RUNTIME_$v_STATIC_FILENAME_PART_WITHDT.csv"
    f_gen_log  "Here is the file: $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
    f_gen_log  "Creating Runtime Source File Metadata Information in file $v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
    echo "$SOURCE_SYSTEM_NAME,$BATCH_ID,$FILE_ID,$SOURCE_FILE_NAME_RUNTM,$CONTROL_FILE_NAME_RUNTM,$BASE_FILE_NAME,$SOURCE_FILE_NAME,$CONTROL_FILE_NAME,$APPLICATION_NAME,$WORK_FLOW_NAME,$PARAMETER_FILE_NAME,$WORK_FLOW_NAME_ERR,$PARAMETER_FILE_NAME_ERR,$DUMMY" > "$v_DQ_PNRM_RUNTIME_filewise_source_file_runtm"
#echo 4  
    f_gen_log  "Updating Param file"

    BASE_PARAM_FILE_NAME="$BASE_FILE_NAME"'_BASE_PARAM.xml'

#echo $BASE_PARAM_FILE_NAME

    f_gen_log "cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME"

    cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME

    f_gen_log  "Base Param File Name $BASE_PARAM_FILE_NAME"
    f_gen_log "sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM"
echo "sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM"

    sh $script_file_path/DQ_PNRM_ReplaceParam_DQVldtn.sh 'Dummy' $parm_file_path'/'$PARAMETER_FILE_NAME $SOURCE_FILE_NAME_RUNTM $v_STATIC_FILENAME_PART_WITHDT $v_TARGET_FILENAME_RUNTM $v_PARENT_FILENAME $v_GRANDPARENT_FILENAME $LEVEL
 
    f_gen_log  "Calling Workflow"

echo "sh DQ_PNRM_WF_Invoke.sh $WORK_FLOW_NAME $PARAMETER_FILE_NAME" 
    sh $script_file_path/DQ_PNRM_WF_Invoke.sh $WORK_FLOW_NAME $PARAMETER_FILE_NAME

    f_gen_log "Archiving Param file $PARAMETER_FILE_NAME file to $archive_file_path"
#    mv $parm_file_path/$PARAMETER_FILE_NAME $archive_file_path/$PARAMETER_FILE_NAME
fi
  
  done < $INPUT_FILE
# sleep 1m
######################################################################################################################################
# Check if all CHILD Level3 DQ validation workflows completed or not
######################################################################################################################################
var_cnt=60
var_i=1

f_gen_log()
{
log_time=`date`
echo -e "$log_time ----- $1" >> $logdirnfile
}

f_gen_log "Verification Processing started to check if Grand Child DQ Validation workflow run is complete or not.."
while [ $var_i -le $var_cnt ] 
do

  
  ##LineCount of .done file
  LC_dotDone=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done | awk 'BEGIN {FS = ","}; {if ( $4==3 ) sum=sum+1} END {print sum}'`

  if [ $v_GRANDCHILD_FILE_CNT = $LC_dotDone ];
  then
    f_gen_log "Number of entries in Runtime file=$v_GRANDCHILD_FILE_CNT is now equals number of files processed=$LC_dotDone as per .done file"
    
    var_i=$var_cnt
  fi
  sleep 1m
  f_gen_log "var_i := $var_i, Workflows are still running."
  var_i=`expr $var_i + 1`
  if [ $var_i -gt $var_cnt ] 
  then
    f_gen_log "var_i := $var_i, Workflow Run is complete"  
  fi
done

#  f_gen_log "Archiving $v_source_file_runtime to $archive_file_path"
#  mv $v_source_file_runtime $archive_file_path/$v_source_file_runtime

######################################################################################################################################
f_gen_log "Invokation of all Individual DQ Validation workflows are complete now.."
f_gen_log "****************************** SECTION 1 OF THE SCRIPT COMPLETED ***********************************"
######################################################################################################################################


######################################################################################################################################
# Check if all the DQ validation workflows completed or not
######################################################################################################################################
var_cnt=60
var_i=1

f_gen_log()
{
log_time=`date`
echo -e "$log_time ----- $1" >> $logdirnfile
}

f_gen_log "Verification Processing started to check if DQ Validation workflow run is complete or not.."
while [ $var_i -le $var_cnt ] 
do

  ##LineCount of Runtime file
  LC_RunTime=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.csv|grep -c ^`

  ##LineCount of .done file
  LC_dotDone=`cat $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done|grep -c ^`

  if [ $LC_RunTime = $LC_dotDone ]
  then
    f_gen_log "Number of entries in Runtime file=$LC_RunTime is now equals number of files processed=$LC_dotDone as per .done file"
    ############################################### Move and Archive files here #####################################################

    #cp $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done $etltrig_file_path'PNRM_DQ_Vldtn.done'
    #chmod 777 $etltrig_file_path*.*     

    ####################################################### End of Archiving ########################################################
    var_i=$var_cnt
  fi
  sleep 1m
  f_gen_log "var_i := $var_i, Workflows are still running."
  var_i=`expr $var_i + 1`
  if [ $var_i -gt $var_cnt ] 
  then
    f_gen_log "var_i := $var_i, Workflow Run is complete"  
  fi
done


################################## Making entry for final Audit file    ##################################
cd $target_file_path
echo `cat Panorama_Audit_Table_Holding_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingDates_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingComponentMeasures_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingComponents_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingFinTran_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingInsUndrwrt_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingInvVehFinTran_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingInvVeh_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingLoanMeasures_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingLoans_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingMeasure_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingProducer_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingRoleRegistration_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
echo `cat Panorama_Audit_Table_HoldingRestrictions_DQ_Interim_Local.csv >> Panorama_Audit_Table_DQ_Interim_Local.csv`
################################ End of Making entry for final Audit file  ###############################

chmod 777 $target_file_path/Panorama_Audit_Table_DQ_Interim_Local.csv
cp Panorama_Audit_Table_DQ_Interim_Local.csv 'Panorama_Audit_Table_DQ_Interim_Local_BKP.csv'

###########Batch id extraction from .done file#################################################################################################
cd $meta_file_path
var_src_filenm=`cut -d',' -f3 DQ_PANORAMA_Source_File_Metadata_RunTime.done`
echo $var_src_filenm|cut -d '_' -f1|head -1 > BatchID_consolidated.txt 
chmod 777 BatchID_consolidated.txt 
######################################################################################################################################
f_gen_log "Invoke of Financial Transaction Error workflow .."
######################################################################################################################################



sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_Financial_Error.sh




######################################################################################################################################
f_gen_log "Invoke of PushToBigdata Audit table workflow .."
######################################################################################################################################




date=`date +%Y%m%d`

cp /work/DQ/DQdatafiles/PANORAMA/Param/wf_DQ_PNRM_PushToBigdata_Param_Audit.xml /work/DQ/DQdatafiles/PANORAMA/Param/wf_DQ_PNRM_PushToBigdata_Param_Audit_Runtime_$date.xml

v_audit_filename=`cat /work/DQ/DQdatafiles/PANORAMA/BDTrigger/*.done`

sed -i -e "s/~audit_table~/$v_audit_filename/g" /work/DQ/DQdatafiles/PANORAMA/Param/wf_DQ_PNRM_PushToBigdata_Param_Audit_Runtime_$date.xml

# sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn DMN_GRID_DQ_DEV -sn DIS_SVC_DQ_DEV -un GPMBatch -pd metlife123 -a app_panorama -wf wf_DQ_PNRM_PushToBigdata_Audit -w false -pf /work/DQ/DQdatafiles/PANORAMA/Param/wf_DQ_PNRM_PushToBigdata_Audit_Param.xml
sh $script_file_path/DQ_PNRM_WF_Invoke.sh wf_DQ_PNRM_PushToBigdata_Audit wf_DQ_PNRM_PushToBigdata_Param_Audit_Runtime_$date.xml

#sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_Audit_Check.sh

#f_gen_log "All Validation Workflows have been executed....."
#echo -e "All Validation Workflows have been executed.....\nDate_Timestamp : $checker_timestamp \n\n" | mailx -s "$var_subject_ALL_Vldtn_success $var_ENV" $ALL_Vldtn_success_mailid_list


#Complete_done=$BATCH_ID'_PANORAMA_DQ_COMPLETE.done'

#cp $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done $etltrig_file_path/etl_panorama.done
#cd $meta_file_path
#v_batch_id=`cat BatchID_consolidated.txt`
#Complete_done=$v_batch_id'_PANORAMA_DQ_COMPLETE.done'

#cp $meta_file_path/DQ_PANORAMA_Source_File_Metadata_RunTime.done $etltrig_file_path/$Complete_done
#chmod 777 $etltrig_file_path*.*   



else
  f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
echo 99
fi


f_gen_log  "End of Script"
