#!/bin/bash 
#Created by Leslie Amegbor 
#Date Created 

: '

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
echo "Running System Update and and upgrades"

$(sudo apt update -y && sudo apt upgrade -y > /dev/null )
echo "System upgrade and update completed at $(date +%H:%M.%S)"  | tee -a



#set hostname 
sudo  hostnamectl set-hostname jenkins
echo " Hostname has been changed to Jenkins." | tee -a "$log_file" || errormsg "Unable to change Hostname"
sudo su - ubuntu
'


# Function to handle errors
errormsg() {
    if [[ $?!= 0 ]] ; then
        echo "ERROR: Please check ERROR_LOG_FILE.log for more information"
    fi
}

# Define log files
readonly LOG_FILE="$(dirname "${BASH_SOURCE[0]}")/jenkinslog.log"
readonly ERROR_LOG_FILE="$(dirname "${BASH_SOURCE[0]}")/jenkins_errorlogs.log"

# Running updates and upgrades with error handling
{
    sudo apt update -y && sudo apt upgrade -y
} >> /dev/null 2>>"$ERROR_LOG_FILE"
errormsg
{ 
echo -e"\n Update and Upgrades completed  successfully!" 
echo "-----------------------------------------------------------"
} >> "$LOG_FILE"


sudo apt install fontconfig openjdk-17-jre -y >> /dev/null 2>>"$ERROR_LOG_FILE"

java -version >> $LOG_FILE

#set hostname
{ 
sudo  hostnamectl set-hostname jenkins
sudo su - ubuntu

echo -e "\n Hostname was changed to jenkins \n"
echo "-----------------------------------------------------------"

} >> $LOG_FILE 2>> "$ERROR_LOG_FILE"


#intallation of jenkins 
{
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc\
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]\
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee\
    /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

}  >> /dev/null 2>>"$ERROR_LOG_FILE"

errormsg

{
echo "-----------------------------------------------------------"
echo -e "           Jenkins has been installed                   " 
echo "-----------------------------------------------------------"
} >> "$LOG_FILE"


# Start and Enable Jenkins services 
sudo systemctl enable jenkins
sudo systemctl start jenkins


# Verify Status of Jenkins
echo -e "\n Verfitying Jenkins is up and runing\n " >> "$LOG_FILE"
sudo systemctl status jenkins >>  "$LOG_FILE"


echo "Jenkins has been succufully Installed"
echo "To Access: <your ip address:8080>"
echo "For Password: check  /var/lib/jenkins/secrets/initialAdminPassword"


