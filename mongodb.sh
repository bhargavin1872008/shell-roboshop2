#!/bin/bash

source ./common.sh

app_name=mongodb
# check the user has root priveleges or not
check_root

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org -y 
VALIDATE $? "installing mongodb"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "editing Mongodb conf file for remote connection"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarting mongodb"

print_time

