#!/bin/sh -x
# Set Check Point profile for library settings!
#Author : Korkut Ozcan (08.12.2016)
#http://korkutozcan.com
#
./etc/profile.d/CP.sh
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/opt/CPsuite-R77/fw1/
#Environment & variables
#
FILENAME="`uname -n`"_"`/bin/date +%m-%d-%Y_%H%M`"
MAIL_LOG=/var/tmp/maillog.txt
FTP_SERVER="X.X.X.X"
FTP_USER="user"
FTP_PASS="Password"
FTP_LOCAL_DIR=/var/tmp/upgrade_export/
FTP_REMOTE_DIR=/path_to/
SENDMAIL=$FWDIR/bin/sendmail
SMTP_SERVER="x.x.x.x"
MAIL_SENDER="xxxx@xxxxx.com"
MAIL1="xxxxx@xxxx.com"
#
#
### update system clock
###/usr/sbin/ntpdate 4.2.2.2
#
### create /var/tmp/upgrade_export
touch {$MAIL_LOG}
mkdir /var/tmp/upgrade_export > ${MAIL_LOG}
### Enter /var/tmp directory
#
cd /var/tmp/upgrade_export
#
### Remove the temp directory if exists
rm -rf /var/tmp/upgrade_export/* >> ${MAIL_LOG} 
#
### Create upgrade_export directory
echo "*********${HOSTNAME} Start the backup gateway process************" >> ${MAIL_LOG}
mkdir /var/tmp/upgrade_export/$FILENAME >> ${MAIL_LOG}
#
### Enter temporary upgrade export directory
cd /var/tmp/upgrade_export/$FILENAME >> ${MAIL_LOG}
#
#Gui client verification
if [ -f $FWDIR/tmp/manage.lock ]
then
BackupError Started:Gui_Client_Connected >> ${MAIL_LOG}
fi
#
### Gather system important information
#
echo " "
echo " "
echo "***Gather system important information***" >> ${MAIL_LOG}
echo " "
echo " "
/bin/set_host >> info.txt
/bin/echo ------------- >> info.txt
/bin/save_ifconfig >> info.txt
/bin/echo ------------- >> info.txt
/bin/netstat -rnv >> info.txt
/bin/echo ------------- >> info.txt
/bin/cat /etc/hosts >> info.txt
/bin/echo ------------- >> info.txt
/bin/cat /etc/sysconfig/netconf.C >> info.txt
/bin/clish -c "show configuration" > ${HOSTNAME}_show_configuration.txt
#
### Start the upgrade_export process
#echo Y | /opt/CPsuite-R77/fw1/bin/upgrade_tools/upgrade_export $FILENAME >> ${MAIL_LOG}
echo "$(date +%H:%M) ---- ${HOSTNAME} Start the upgrade_export process -----"  >> ${MAIL_LOG}
#${SENDMAIL} -t ${SMTP_SERVER} -s "${HOSTNAME} Upgrade_Export Backup" -f ${MAIL_SENDER} ${MAIL1} < ${MAIL_LOG}
${FWDIR}/bin/upgrade_tools/upgrade_export -n ${FILENAME} >> ${MAIL_LOG}
#
### pack up files and zip them up
cd /var/tmp/upgrade_export
tar -cf $FILENAME.tar $FILENAME
gzip $FILENAME.tar
#
echo "---------------------------" >> ${MAIL_LOG}
#
#FTP files to backup server
ftp -n $FTP_SERVER <<EOF >> ${MAIL_LOG}
user ${FTP_USER} ${FTP_PASS} 
binary 
cd ${FTP_REMOTE_DIR}
lcd ${FTP_LOCAL_DIR}
put ${FILENAME}.tar.gz 
bye
EOC
#
#
#Remove temporary directory
rm -vrf $FILENAME >> ${MAIL_LOG}
#
echo "$(date +%H:%M) ---- ${HOSTNAME} Finished the upgrade_export process -----"  >> ${MAIL_LOG}
${SENDMAIL} -t ${SMTP_SERVER} -s "${HOSTNAME} Upgrade_Export Backup" -f ${MAIL_SENDER} ${MAIL1} < ${MAIL_LOG}
#
### Remove mail log temporary directory
rm -rf $MAIL_LOG}
#
### At this point what you may want is to transfer this $FILENAME.tar.gz file
### to a safe external system with Secure Copy Protocol or scp.
### Make sure to use the "admin" account when you get this file from the SCP
### server.
### Enjoy !!!!!!
### copy this file to a scp server
###/usr/bin/scp $FILENAME.tar.gz root@192.168.1.1:/var/backups/.
### Finish
