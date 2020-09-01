#!/bin/bash -x
for fil in /opt/swag/deployment/*.jar
do
    echo "LINKING $fil into LIB"
    ln -s $fil /opt/swag/lib/swag.jar
done
