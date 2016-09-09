#! /bin/bash -e
# Authenticate then submit a job.

AGENT=./codegradxvmauthor.js
HOSTNAME=vmauthor.codegradx.org
HOSTIP=192.168.122.205

[ -d tmp ] && rm -rf tmp
mkdir -p tmp

# Get credentials for student
CREDENTIALS=tmp/fw4ex-student1.json
wget -O $CREDENTIALS http://$HOSTIP/fw4exjson/1

# Check credentials. Credentials are only valid a few hours so refresh
# credentials for the rest of this script:
$AGENT --ip=$HOSTIP --credentials=$CREDENTIALS --update-credentials || true

# Fetch some URLs naming available exercises:
EXERCISES=tmp/fw4ex-example.json
wget -O $EXERCISES http://$HOSTIP/e/path/example

# Extract the URL of the 1st exercise:
EXOURL=$(sed -rne 's/^ *"safecookie": "(.*)", *$/\1/p' < $EXERCISES | head -n1)

# Send an answer to this exercise (a C problem)
$AGENT --ip=$HOSTIP \
    --credentials=$CREDENTIALS \
    --type=job \
    --xmldir=tmp \
    --stuff=spec/min.c --follow \
    --exercise="$EXOURL" 

# Check that the marking report is present and the job got a 100% mark:
[ -f tmp/2-jobStudentReport.xml ] && \
grep -q ' mark="1" totalMark="1"' < tmp/2-jobStudentReport.xml && \
echo OK

# end of 10-job.sh
