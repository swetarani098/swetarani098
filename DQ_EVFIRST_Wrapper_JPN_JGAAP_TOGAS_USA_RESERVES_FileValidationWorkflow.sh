##########################################################################################################################
# File Name                  Developer                       Create On                                   		 #
# DQ_EVFIRST_WrapperValidationWorkflow_JPN_JGAAP_TOGAS_USA_RESERVES.sh    Cognizant DQ Developent Team   11-Feb-2019	 #
# Version History:                                                                                       		 #
# 1.0 - 11-Feb-2019 - Initial version                                                                    		 #
##########################################################################################################################

. /work/DQ/DQApps/FIRST/Param/env_file_EV.parm




cd $meta_file_path
### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='WrapperValidationWorkflow_JPN_JGAAP_TOGAS_USA_RESERVES_'$checker_timestamp'.log'
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

############################################################################################################
token0=`date +%A`
token0=`echo $token0|cut -c1-|rev`
token0=`echo $token0|cut -c1-3|rev`
token0='DQ'$token0
token2=0
token1=0
while [ $token2 -le 0 ]
	do
		token1=`expr $RANDOM % 2`
		if [ $token1 != '0' ]
			then
				token2=$token1
		fi
		token1=0
	done
		token=`expr $token2 \* 2`
		token3=`expr $token \* 3`
		token=$token$token1
		token=$token$token2
		token=$token$token3
		token=$token0$token
#echo $token
#echo $restrict_file_path$enc_DpassFile

openssl enc -in $restrict_file_path$enc_DpassFile -d -aes-256-cbc  -pass pass:$token > rpass.tmp
dqwfuser=`openssl enc -in $restrict_file_path$enc_UserFile -d -aes-256-cbc  -pass file:rpass.tmp`
dqwfpass=`openssl enc -in $restrict_file_path$enc_PassFile -d -aes-256-cbc  -pass file:rpass.tmp`
#echo $dqwfuser
#echo $dqwfpass

rm -f rpass.tmp
#############################################################################################################

f_gen_log "Source is being processed.."
#echo 1.1

v_source_file_runtime=$meta_file_path'/DQ_EVFIRST_Source_File_Metadata_JPN_JGAAP_TOGAS_USA_RESERVES_RunTime.csv'
#v_src_master_file=DQ_EVFIRST_Source_File_RunTime.txt
#echo $v_source_master_file
export varFileExist='0'
#echo 1.2

#echo $v_source_file_runtime
ifFileExist $v_source_file_runtime
#echo 1.25

echo "var=$varFileExist"
if [ $varFileExist = '1' ]
	then
#echo 1.3
	  f_gen_log "Source Master File $v_source_file_runtime exists in Metafile directory $meta_file_path"
	  INPUT_FILE=$v_source_file_runtime
	  IFS=','
#echo 1.4
	  while read SOURCE_FILE_NAME_RUNTM CONTROL_FILE_NAME_RUNTM EVFRST_CYCLE_CD EVFRST_FILE_ID EVFRST_LOAD_TS EVFRST_DATA_SRC_NM EVFRST_USR_ID SOURCE_SYSTEM PRODUCT_NAME FILE_FORMAT MAINFRAME_FILE_NAME INFORMATICA_FILENAME CONTROL_FILE_NAME FILE_NAME APPLICATION_NAME WORK_FLOW_NAME PARAMETER_FILE_NAME BASE_FILE_NAME COUNTRY REGULATORY_TYPE_CODE BUSINESSDAY_CUTOFF_TIMESTAMP BUSINESSDAY_CUTOFF_DESCRIPTION DUMMY
		do
#echo 2
		    f_gen_log "#Parameters#"
		    f_gen_log  "Cycle Id: $EVFRST_CYCLE_CD"
		    f_gen_log  "File Id: $EVFRST_FILE_ID"
		    f_gen_log  "Source System Name: $EVFRST_DATA_SRC_NM"
		    f_gen_log  "Base Source File Name: $BASE_FILE_NAME"
		    f_gen_log  "Mainframe File Name: $MAINFRAME_FILE_NAME"
		    f_gen_log  "Runtime Source File Name: $SOURCE_FILE_NAME_RUNTM"
		    f_gen_log  "Runtime Control File Name: $CONTROL_FILE_NAME_RUNTM"
		    f_gen_log  "Validation Application Name: $APPLICATION_NAME"
		    f_gen_log  "Validation Workflow Name: $WORK_FLOW_NAME"
		    f_gen_log  "Validation Parameter File Name: $PARAMETER_FILE_NAME"
		    f_gen_log  "Country Name: $COUNTRY"
#echo 3	
#v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm=`sed "s/.txt/.csv/g" <<< "DQ_EVFIRST_RUNTIME_$SOURCE_FILE_NAME_RUNTM"`
 		   v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm="DQ_EVFIRST_RUNTIME_$BASE_FILE_NAME.csv"
 		   f_gen_log  "Here is the file: $v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm"
 		   f_gen_log  "Creating Runtime Source File Metadata Information in file $v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm"
 		   echo "$SOURCE_FILE_NAME_RUNTM,$CONTROL_FILE_NAME_RUNTM,$EVFRST_CYCLE_CD,$EVFRST_FILE_ID,$EVFRST_LOAD_TS,$EVFRST_DATA_SRC_NM,$EVFRST_USR_ID,$SOURCE_SYSTEM,$PRODUCT_NAME,$FILE_FORMAT,$MAINFRAME_FILE_NAME,$INFORMATICA_FILENAME,$CONTROL_FILE_NAME,$FILE_NAME,$APPLICATION_NAME,$WORK_FLOW_NAME,$PARAMETER_FILE_NAME,$BASE_FILE_NAME,$COUNTRY,$REGULATORY_TYPE_CODE,$BUSINESSDAY_CUTOFF_TIMESTAMP,$BUSINESSDAY_CUTOFF_DESCRIPTION,$DUMMY" > "$v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm"
#echo 4  
 		   f_gen_log  "Updating Param file"
 		   BASE_PARAM_FILE_NAME='reserve2_PARAM.XML'

#echo $BASE_PARAM_FILE_NAME

    		   f_gen_log "cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME"
    		   cp $parm_file_path/$BASE_PARAM_FILE_NAME $parm_file_path/$PARAMETER_FILE_NAME

#BASE_FILENAME=`sed "s/.txt//g" <<< "$SOURCE_FILE_NAME_RUNTM"`
#f_gen_log  "Base File Name $BASE_FILENAME"
##Commented on 26-Sep-2017
#echo $COUNTRY
#COUNTRY='fsa'
 	if [ $COUNTRY = 'JPN' ];
 		then
 		   COUNTRY='japan'
 		else
 		   COUNTRY='unknown'
 	fi


###################
    f_gen_log "Creating 0 byte Bad file"
    #touch "$target_file_path/$BASE_FILE_NAME"'_Bad.TXT'
    #chmod 777 "$target_file_path/$BASE_FILE_NAME"'_Bad.TXT'
##BEGIN: added on 19072018 for NORMALIZER requirement
    touch "$target_file_path/"'ERR_'"$FILE_FORMAT"'_'"$EVFRST_CYCLE_CD"'_'"$EVFRST_FILE_ID"'.err'
    chmod 777 "$target_file_path/"'ERR_'"$FILE_FORMAT"'_'"$EVFRST_CYCLE_CD"'_'"$EVFRST_FILE_ID"'.err' 
##END: added on 19072018 for NORMALIZER requirement
###################
   
    f_gen_log  "Base Param File Name $BASE_PARAM_FILE_NAME"
    f_gen_log "sh $script_file_path/DQ_EVFIRST_ReplaceStringInParamFile.sh $PARAMETER_FILE_NAME $FILE_FORMAT $SOURCE_FILE_NAME_RUNTM $BASE_FILE_NAME $COUNTRY $EVFRST_CYCLE_CD $EVFRST_FILE_ID"

    #sh $script_file_path/DQ_EVFIRST_ReplaceStringInParamFile.sh $PARAMETER_FILE_NAME $FILE_FORMAT $SOURCE_FILE_NAME_RUNTM $BASE_FILE_NAME $COUNTRY $CONTROL_FILE_NAME_RUNTM
     sh $script_file_path/DQ_EVFIRST_ReplaceStringInParamFile.sh $PARAMETER_FILE_NAME $FILE_FORMAT $SOURCE_FILE_NAME_RUNTM $BASE_FILE_NAME $COUNTRY $CONTROL_FILE_NAME_RUNTM $EVFRST_CYCLE_CD $EVFRST_FILE_ID

    f_gen_log  "Calling Workflow"

    f_gen_log  "INFA Command: /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn DMN_GRID_DQ_DEV -sn DIS_SVC_DQ_DEV -un $batchid -pd $batchpwd -a $APPLICATION_NAME -wf $WORK_FLOW_NAME -w false -pf $parm_file_path/$PARAMETER_FILE_NAME"

   sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -sdn METNET.NET  -a $APPLICATION_NAME -wf $WORK_FLOW_NAME -w true -pf $parm_file_path/$PARAMETER_FILE_NAME
   # sh /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un GPMBatch -pd metlife123 -a $APPLICATION_NAME -wf $WORK_FLOW_NAME -w true -pf $parm_file_path/$PARAMETER_FILE_NAME

    f_gen_log "Archiving Individual DQ_EVFIRST_RUNTIME_$SOURCE_FILE_NAME_RUNTM file to $archive_file_path"
   #mv "$v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm" $archive_file_path/"$v_DQ_EVFIRST_RUNTIME_filewise_source_file_runtm"

    f_gen_log "Archiving Param file $PARAMETER_FILE_NAME file to $archive_file_path"
   #mv $parm_file_path/$PARAMETER_FILE_NAME $archive_file_path/$PARAMETER_FILE_NAME



  done < $INPUT_FILE

  f_gen_log "Archiving $v_source_file_runtime to $archive_file_path"
 #mv $v_source_file_runtime $archive_file_path/$v_source_file_runtime

else
  #f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
  #echo 99
  #Begin: 18-02-2019
  #Changed else part to exit process with error code 91 in case of any environment failure
  f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
  echo "Source File Base $v_source_file_runtime does not exist in Metafile directory"
  echo "Error Code: 91"
  exit 91
  #End: 18-02-2019
fi

f_gen_log "Calling JPN_JGAAP_TOGAS_USA_RESERVES post processng script in a different thread"
cd $script_file_path
sh DQ_EVFIRST_PostProcessing_JPN_JGAAP_TOGAS_USA_RESERVES.sh


f_gen_log  "End of Script"
