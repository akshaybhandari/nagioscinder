#!/usr/bin/env bash
# Origninal from https://github.com/jonschipp/nagios-plugins
# Modified by Akshay Bhandari

# Nagios plugin to check memory consumption
# Excludes Swap and Caches so only the real memory consumption is considered

# Nagios Exit Codes
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

# set default values for the thresholds
WARN=90
CRIT=95

usage()
{
cat <<EOF

Check memory consumption excluding swap and cache to determine real usage.

     Options:
        -c         Critical threshold as percentage (0-100) (default: 95)
        -w         Warning threshold as percentage (0-100) (default: 90)
	-h	   Print help (this Message) and exit

Usage: $0 -w 90 -c 95
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

MEM_TOTAL=`free | fgrep "Mem:" | awk '{ print $2 }'`;
MEM_USED=`free | fgrep "/+ buffers/cache" | awk '{ print $3 }'`;

PERCENTAGE=$(($MEM_USED*100/$MEM_TOTAL))
RESULT=$(echo "${PERCENTAGE}% ($((($MEM_USED)/1024)) of $((MEM_TOTAL/1024)) MB) used")

if [ $PERCENTAGE -gt $CRIT ]; then
        echo "CRITICAL: $RESULT"
        exit $CRITICAL;
elif [ $PERCENTAGE -gt $WARN ]; then
        echo "WARNING: $RESULT"
        exit $WARNING;
else
        echo "OK: $RESULT"
        exit $OK;
fi

