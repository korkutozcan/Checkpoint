#/bin/sh
# Script written by Korkut Ozcan
#
# http://korkutozcan.com 
# Customer Logs copy script
#
# Collects required files for successful migration *away* from Provider-1

. /etc/profile.d/CP.sh
location=$name/log

mdsstat 

echo "Please specify the name of the customer (no spaces)"
read name
location=$name/log
echo "Please enter the IP address of the CMA you wish to export" 
read customer
echo " "
echo "Thank you"
echo " "
echo "You have specified to use the following CMA:"
mdsstat |grep $customer |awk '{print $3}'
echo " "
echo "Is this correct (yes or no)"
read ans1
        if [ $ans1 = yes ] 
        then
        echo " "
        echo "Collecting the required files..."
        mdsenv $customer
        mkdir /var/tmp/$name
        mkdir /var/tmp/$name/log
        cd $FWDIR/log
        cp -v [0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]* /var/tmp/$location/
        cd /var/tmp/
        echo "Collection complete"
        echo " "
        echo " "
        echo "Done"
        echo " "
        echo "Your files are located at /var/tmp/$location"
        echo "Goodbye"

        else
        echo "exiting"
        fi
