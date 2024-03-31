#!/bin/bash 
#Created by Leslie Amegbor 
#Date Created March 31, 2024

# Function to handle errors

errormsg() {
    if [[ $? != 0 ]] ; then
        echo "ERROR: Please check ERROR_LOG_FILE.log for more information"
        exit
    fi
}

# Define log files
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="$SCRIPT_DIR/jenkinslog.log"
readonly ERROR_LOG_FILE="$SCRIPT_DIR/jenkins_errorlogs.log"

# Running updates and upgrades with error handling
{
    sudo apt update -y && sudo apt upgrade -y
} >> /dev/null 2>>"$ERROR_LOG_FILE"

errormsg

{ 
echo -e "\n Update and Upgrades completed  successfully!" 
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


