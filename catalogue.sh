#!/bin/bash

app_name=catalogue
source ./common.sh


check_root

app_setup

nodejs_setup

systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing nodejs"

STATUS=$(mongosh --host mongodb.hanuops.shop --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then 
    mongosh --host mongodb.hanuops.shop </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi

print_time