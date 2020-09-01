#!/bin/bash

while read -r line
do
    variable=`echo $line | awk -F "=" '{ print $1 }'`
    variable_value=`eval echo \\$$variable`
    if [ -z "$variable_value" ]; then
        export $line
    fi
done < /usr/local/tomcat/conf/${ENV}.env

/usr/local/tomcat/populate_env.sh /usr/local/tomcat/conf/context.xml.template

exec catalina.sh run
