#! /bin/bash
# Authenticate then send a batch

AGENT=./codegradxvmauthor.js
HOSTNAME=vmauthor.codegradx.org
HOSTIP=192.168.122.205

[ -d tmp ] && rm -rf tmp
mkdir -p tmp

# Get credentials for author
CREDENTIALS=tmp/fw4ex-author0.json
wget -O $CREDENTIALS http://$HOSTIP/fw4exjson/0

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
    --type=batch \
    --xmldir=tmp \
    --stuff=spec/oefgc.tgz --follow \
    --exercise="$EXOURL" \
    --offset=30 --timeout=10 --counter=400

[ -f tmp/*-multiJobStudentReport.xml ] && \
grep -q " finishedjobs='9' totaljobs='9'" < tmp/*-multiJobStudentReport.xml &&\
echo OK

# end of 30-batch.sh
