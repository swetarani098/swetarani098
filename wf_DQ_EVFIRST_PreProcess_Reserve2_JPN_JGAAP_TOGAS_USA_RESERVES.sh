##########################################################################################################
# File Name                                             Developer                              Created On#
# DQ_EVFIRST_WrapperPreProcessor_JPN_JGAAP_TOGAS_USA_RESERVES.sh    Cognizant DQ Developent Team    11-Feb-2019#
# Version History:                                                                                       #
# 1.0 - 11-Feb-2019 - Initial version                                                                    #
##########################################################################################################

. /work/DQ/DQApps/FIRST/Param/env_file_EV.parm



### Script variables
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_EVFIRST_WrapperPreProcessor_JPN_JGAAP_TOGAS_USA_RESERVES'$checker_timestamp'.log'
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


############################################################################################################
#restrict_file_path='/work/DQ/DQApps/FIRST/RESTRICTED/'
#enc_UserFile='dqwfuser.enc'
#enc_PassFile='dqwfpass.enc'
#enc_DpassFile='drpass.enc'

f_gen_log "restrict_file_path = $restrict_file_path"
f_gen_log "enc_UserFile = $enc_UserFile"
f_gen_log "enc_PassFile = $enc_PassFile"
f_gen_log "enc_DpassFile = $enc_DpassFile"

token0=`date +%A`
token0=`echo $token0|cut -c1-|rev`
token0=`echo $token0|cut -c1-3|rev`
token0='DQ'$token0
f_gen_log "token0 = $token0"

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

f_gen_log "Decrypting DpassFile"
openssl enc -in $restrict_file_path$enc_DpassFile -d -aes-256-cbc  -pass pass:$token > $checker_timestamp'_rpass.tmp'

dqwfuser=`openssl enc -in $restrict_file_path$enc_UserFile -d -aes-256-cbc  -pass file:$checker_timestamp'_rpass.tmp'`
dqwfpass=`openssl enc -in $restrict_file_path$enc_PassFile -d -aes-256-cbc  -pass file:$checker_timestamp'_rpass.tmp'`

rm -f $checker_timestamp'_rpass.tmp'
#############################################################################################################
f_gen_log  "Calling Workflow"
  /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un $dqwfuser -pd $dqwfpass -sdn METNET.NET  -a app_preprocess_reserve2 -wf wf_DQ_EVFIRST_PreProcess_crtl_Reserve2 -w true -pf $parm_file_path/wf_DQ_EVFIRST_PreProcess_crtl_Reserve2_JPN_JGAAP_TOGAS_USA_RESERVES.xml
# /opt/PowerCenter/server/bin/infacmd.sh wfs startWorkflow -dn $DMN_GRID -sn $DIS_SVC -un GPMBatch -pd metlife123 -a app_preprocess_reserve2 -wf wf_DQ_EVFIRST_PreProcess_crtl_Reserve2 -w true -pf $parm_file_path/wf_DQ_EVFIRST_PreProcess_crtl_Reserve2_JPN_JGAAP_TOGAS_USA_RESERVES.xml


mv $bdtrig_file_path'/JPN_JGAAP_TOGAS_USA_RESERVES.done' $archive_file_path'/JPN_JGAAP_TOGAS_USA_RESERVES.done_'$checker_timestamp     ## Added on 22-Jun-2018
#############################################################################################################
############################################################################################################
#Begin: 18-02-2019
#Included below part to exit process with error code 81 in case of any environment failure
v_source_file_runtime=$meta_file_path'/DQ_EVFIRST_Source_File_Metadata_JPN_JGAAP_TOGAS_USA_RESERVES_RunTime.csv'

if [ -s $v_source_file_runtime ]
then
  f_gen_log "Source File Base $v_source_file_runtime exists in Metafile directory"
else
  f_gen_log "Source File Base $v_source_file_runtime does not exist in Metafile directory"
  echo "Source File Base $v_source_file_runtime does not exist in Metafile directory"
  echo "Error Code: 81"
  exit 81
fi
#End: 18-02-2019
############################################################################################################

