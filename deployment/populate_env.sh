#!/bin/bash

## Clear filedata
FILEDATA=""

## Make sure a filename is given for startup in the script
if [ ! -f $1 ] 
then
    echo "$1 doesn't exist or can't be read from"
    exit -1
fi

## New filename without the word template extention
FILENAME=${1/.template/}

## Replace ENV variables in the parsed data file 
for VAR_NAMES in `env`
do
   VAR_NAME=`echo $VAR_NAMES | awk -F "=" ' { print $1 }'`
   VAR_SEARCH="\${$VAR_NAME}"
   VAR_REPLACE=`eval echo \\$$VAR_NAME`
   if [ ! -z "$VAR_REPLACE" ]; then
        if [ ! -z "$FILEDATA" ]; then
            FILEDATA=`sed -e 's*'"$VAR_SEARCH"'*'"$VAR_REPLACE"'*g' $FILENAME`
        else     
            FILEDATA=`sed -e 's*'"$VAR_SEARCH"'*'"$VAR_REPLACE"'*g' $1`
        fi
   fi
   if [ ! -z "$FILEDATA" ]; then
        echo "$FILEDATA" > $FILENAME
   fi
done
