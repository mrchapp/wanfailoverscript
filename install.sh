#!/bin/sh

BINARY=wfs
CONFIG=wfs.conf
INITSCRIPT=init.d/wfs

BINARY_TARGET=/usr/bin
INITSCRIPT_TARGET=/etc/init.d
CONFIG_TARGET=/etc

if [ "$1" == "remove" ]
then
    if [ -e /etc/debian_version ]
    then
        update-rc.d -f wfs remove
    elif [ -e /etc/redhat-release ]
    then
        chkconfig --del wfs
    fi

    rm $BINARY_TARGET/$BINARY
    rm $CONFIG_TARGET/$CONFIG
    rm $INITSCRIPT_TARGET/`basename $INITSCRIPT`
    exit
fi

cp $BINARY $BINARY_TARGET
cp $INITSCRIPT $INITSCRIPT_TARGET

if [ -e $CONFIG_TARGET/$CONFIG ]
then
    echo
    echo "-------------------------------------------------------------------"
    echo "Existing configuration found. Creating $CONFIG_TARGET/$CONFIG.new."
    echo "Update your existing configuration file with the new one or WFS may"
    echo "not operate properly due to changes. Press enter to continue."
    echo "-------------------------------------------------------------------"
    read
    cp $CONFIG $CONFIG_TARGET/$CONFIG.new
else
    cp $CONFIG $CONFIG_TARGET/$CONFIG
fi

if [ -e /etc/debian_version ]
then
    update-rc.d wfs defaults 99 10
elif [ -e /etc/redhat-release ]
then
    chkconfig --levels 2345 wfs on
fi



