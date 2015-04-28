#!/usr/bin/env bash
# Author: Akshay Bhandari

# Nagios plugin to check memory consumption
# Excludes Swap and Caches so only the real memory consumption is considered
# Requirements: bc, lvm2

# Nagios Exit Codes
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

# set default values for the thresholds
WARN=20
CRIT=10

usage()
{
cat <<EOF

Check for cinder volume consumption to determine real usage.

     Options:
        -c         Critical threshold as percentage (0-100) (default: 95)
        -w         Warning threshold as percentage (0-100) (default: 90)
        -h         Print help (this Message) and exit

Usage: $0 -w 20 -c 10
EOF
}

while getopts "c:w:h" ARG;
do
        case $ARG in
                w) WARN=$OPTARG
                   ;;
                c) CRIT=$OPTARG
                   ;;
                h) usage
                   exit
                   ;;
        esac
done

function getMultiplier() 
{
UNIT=$1
if [ "$UNIT" == "t" ]
then
        MULTIPLIER=1048576
elif [ "$UNIT" == "g" ]
then
        MULTIPLIER=1024
elif [ "$UNIT" == "m" ]
then
        MULTIPLIER=1
else
        exit $UNKNOWN;
fi
echo $MULTIPLIER
}

TOTAL_SIZE=`vgs --all | grep -i "cinder" | awk '{print $6}'`
TOTAL_SIZE_LEN=$((${#TOTAL_SIZE}-1))
TOTAL_SIZE_UNIT=${TOTAL_SIZE:$TOTAL_SIZE_LEN:1}
MULTIPLIER=`getMultiplier $TOTAL_SIZE_UNIT`
if [ $? -ne 0 ]
then 
        echo "UNKNOWN: Volume group status unknown"
	exit $UNKNOWN;
fi
TOTAL_SIZE=${TOTAL_SIZE::-1}
TOTAL_SIZE=$(bc <<< "$TOTAL_SIZE*$MULTIPLIER")

FREE_SIZE=`vgs --all | grep -i "cinder" | awk '{print $7}'`
FREE_SIZE_LEN=$((${#FREE_SIZE}-1))
FREE_SIZE_UNIT=${FREE_SIZE:$FREE_SIZE_LEN:1}
MULTIPLIER=`getMultiplier $FREE_SIZE_UNIT`
if [ $? -ne 0 ]
then
	echo "UNKNOWN: Volume group status unknown"
        exit $UNKNOWN;
fi
FREE_SIZE=${FREE_SIZE::-1}
FREE_SIZE=$(bc <<< "$FREE_SIZE*$MULTIPLIER")

PERCENTAGE=$(bc <<< "$FREE_SIZE*100/$TOTAL_SIZE")
RESULT=$(echo "${PERCENTAGE}% of disk is free")


if [ $(bc <<< "$PERCENTAGE < $CRIT") -eq 1 ]; then
        echo "CRITICAL: $RESULT"
        exit $CRITICAL;
elif [ $(bc <<< "$PERCENTAGE < $WARN") -eq 1 ]; then
        echo "WARNING: $RESULT"
        exit $WARNING;
else
        echo "OK: $RESULT"
        exit $OK;
fi

