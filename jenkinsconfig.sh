#!/bin/bash 
#Created by Leslie Amegbor 
#Date Created 

#created an error messeage function 
errormsg(){
    echo "Error: $1 "| tree -a "error_file"
    exit 1 
}

log_file= /var/log/jenkins_logs.log
error_file= /var/log/jenkins_errorlogs.log

if [ ! -f "$log_file" ] ; then
sudo touch /var/log/jenkins_logsfile.log 
else 
errormsg "Log file cannot be created."
fi 

if [! -f "$error_file"] ; then
sudo touch /var/log/jenkins_errorlogs.log 
else 
errormsg "Log file cannot be created."
fi 

#update and upgrade the system 
echo "Running System Up"


#set hostname 
sudo  hostnamectl set-hostname jenkins
echo " Hostname has been changed to Jenkins." | tee -a "$log_file" || errormsg "Unable to change Hostname"
sudo su - ubuntu
