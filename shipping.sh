#!/bin/bash

source ./common.sh
app_name=shipping

check_root

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD

app_setup
maven_setup
systemd_setup

dnf install mysql -y  &>>$LOG_FILE
VALIDATE $? "Install MySQL"

mysql -h mysql.daws84s.site -u root -p$MYSQL_ROOT_PASSWORD -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql -h mysql.hanuops.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql
    mysql -h mysql.hanuops.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql
    mysql -h mysql.hanuops.shop -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql
    VALIDATE $? "Loading data into MySQL"
else
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"
fi

systemctl restart shipping  &>>$LOG_FILE
VALIDATE $? "retarting shipping"
print_time