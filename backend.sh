 #!/bin/bash

 USERID=$(id -u)
 TIMESTAMP=$(date +%F-%H-%M-%S)
 SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
 LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log
 R="\e[31m"
 G="\e[32m"
 Y="\e[33m"
 N="\e[0m"

 echo "please enter the DB password:"
 read -s mysql_root_password

 VALIDATE(){
 if [ $1 -ne 0 ]
 then 
    echo "$2....$R  failure  $N"
    exit 1
 else
    echo "$2....$G success $N"
 if   
   }

 if [ $USERID -ne 0 ]
 then 
   echo "please try to run the script using root access"
   exit 1
 else
 echo "you are a super user"
 fi 

 dnf module disable nodejs -y &>>LOGFILE
 VALIDATE $? "disabling default nodejs"

 dnf module enable nodejs:20 -y &>>LOGFILE
 VALIDATE $? "enabling nodejs:20 version"

 dnf install nodejs -y &>>LOGFILE
 VALIDATE $? "installing nodejs"

 id expense &>>LOGFILE
 if [ $? -ne 0 ]
 then 
   useradd expense &>>LOGFILE
   VALIDATE $? "creating a new user"
  else
    echo -e "expense user already created $Y .. SKIPPING.. $N"
  fi

  mkdir -p /app &>>LOGFILE
  VALIDATE $? "creating app directory"

 curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
 VALIDATE $? "downloading the backend code"

 cd /app 
 rm -rf /app/*
 unzip /tmp/backend.zip &>>LOGFILE
 VALIDATE $? "extracting backend code"

 npm install &>>LOGFILE
 VALIDATE $? "installing the nodejs dependencies"

 cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>LOGFILE
 VALIDATE $? "copied backend service"

 sytemctl daemon-reload &>>LOGFILE
 VALIDATE $? "daemon reload"
 systemctl start backend &>>LOGFILE
 VALIDATE $? "starting backend"
 systemctl enable backend &>>LOGFILE
 VALIDATE $? "enabling backend"

 dnf install mysql -y &>>LOGFILE
 VALIDATE $? "installing mysql client"

 mysql -h db.devopsdaws78.cloud -uroot -p{mysql_root_password} < /app/schema/backend.sql &>>LOGFILE
 VALIDATE $? "loading schema"

 systemctl restart backend &>>LOGFILE
 VALIDATE $? "restarting backend"




