#!/bin/bash

source ./comman.sh

check_root()


dnf install mysql-server -y &>>$LOGFILE
VALIDATA $? "Installing mysql Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATA $? "enable mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATA $? "start mysql server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATA $? "seeting up root password"

#Below code will be useful for idempotent nature
mysql -h db.daws78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATA $? "Mysql root password setup"
else
    echo -e "Mysql root password is already setup..$Y SkIPPING $N"
fi

