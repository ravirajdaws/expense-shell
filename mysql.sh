#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
     then 
    echo -e "$2 ....$R. failure  $N"
    exit 1
    else
    echo -e "$2 ...$G.. success   $N"
    fi
}

if [ $USERID -ne 0 ]
  then 
  echo "please try to run the script using root access"
  exit 1
  else 
  echo "you are a super user"
fi

  dnf install mysql-server -y &>>LOGFILE
  VALIDATE $? "installing mysql-server"

  systemctl enable mysqld &>>LOGFILE
  VALIDATE $? "enabiling mysql server"

  systemctl start mysqld &>>LOGFILE
  VALIDATE $? "starting mysql server"

  mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
  VALIDATE $? "setting up the root password"