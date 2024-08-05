#!/bin/bash

source ./comman.sh

check_root


dnf module disable nodejs -y &>>$LOGFILE
VALIDATA $? "module disable server"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATA $? "module enable node"

dnf install nodejs -y &>>$LOGFILE
VALIDATA $? "install nodejs."


id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATA $? "creating expense user"
else
    echo -e "Expense user already created...$Y SKPPING $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATA $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATA $? "Download backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATA $? "Extracted backend code"

npm install &>>$LOGFILE
VALIDATA $? "Installing npm dependings"
 
cp /home/ec2-user/DAWS-78S-expense-shell/backend.service  /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATA $? "copied bankend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATA $? "Daemon Reload"

systemctl start backend &>>$LOGFILE
VALIDATA $? "Starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATA $? "Enable backend"

dnf install mysql -y &>>$LOGFILE
VALIDATA $? "Installing mysql client"

mysql -h db.daws78s.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATA $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATA $? "Resrarting Backend"


