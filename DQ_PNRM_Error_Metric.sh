##########################################################################################################
# File Name                  Developer                       Create On                                   #
# DQ_PNRM_Error_Metric.sh          Cognizant DQ Developent Team           07-Jun-2018     #
# Version History:                                                                                       #
# 1.1 - 07-JUN-18 - Initial version                                                                      #
##########################################################################################################



. /work/DQ/DQdatafiles/PANORAMA/Param/env_file_PNRM.parm

date=`date +%Y%m%d`
checker_timestamp=`date +%Y%m%d'_'%H%M%S`
logfile='DQ_PNRM_Error_Metric_'$checker_timestamp'.log'
logdirnfile=$logdir/$logfile

f_gen_log()
{
PNRM_logtm=`date`
echo "$PNRM_logtm ----- $1" >> $logdirnfile
}

dt=$(date +%Y%m%d%H%M%S)

f_gen_log "Error Metric generation started...."
##############################################Total Feed Count Check####################################################################


date=`date +%Y%m%d`
WF_NAME='wf_DQ_PNRM_Error_Metric'
RUNTIME_PARAM_FILE='wf_DQ_PNRM_Error_Metric_Runtime_'$date'.xml'
PARAMETER_FILE_PATH='/work/DQ/DQdatafiles/PANORAMA/Param/'
PARAMETER_FILE_NAME='wf_DQ_PNRM_Error_Metric_BASE_PARAM.xml'
RUNTIME_PARAMETER_FILE=$parm_file_path/wf_DQ_PNRM_Error_Metric_Runtime_$date.xml 


f_gen_log "Runtime Pararmeter File : $RUNTIME_PARAMETER_FILE"
f_gen_log "Copying original parameter file to create a runtime parameter file"

      cp $PARAMETER_FILE_PATH$PARAMETER_FILE_NAME $RUNTIME_PARAMETER_FILE


sh /work/DQ/DQdatafiles/PANORAMA/Script/DQ_PNRM_WF_Invoke.sh $WF_NAME $RUNTIME_PARAM_FILE true

#############################################################################################################

cd $error_file_path

zip consolidated_error_metrics.zip Error_Metric_1.csv Error_Metric_2.csv Error_Metric_3.csv Error_Metric_4.csv Error_Metric_5.csv Error_Metric_6.csv Error_Metric1_dtls.csv Error_Metric3_dtls.csv
echo -e "Please Find Attached the Consolidated Error Metrics......" | mailx -s "DQ Panorama Error Metric Notification $var_ENV " -a consolidated_error_metrics.zip $ALL_Vldtn_success_mailid_list
f_gen_log "Error Metric generation mail sent...."

