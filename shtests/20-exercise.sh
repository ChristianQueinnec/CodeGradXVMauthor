#! /bin/bash -e
# Authenticate then submit an exercise and a job towards this exercise

AGENT=./codegradxvmauthor.js
HOSTNAME=vmauthor.codegradx.org
HOSTIP=192.168.122.205

[ -d tmp ] && rm -rf tmp
mkdir -p tmp

# Get credentials for student
CREDENTIALS=tmp/fw4ex-author0.json
wget -O $CREDENTIALS http://$HOSTIP/fw4exjson/0

# Check credentials. Credentials are only valid a few hours so refresh
# credentials for the rest of this script:
$AGENT --ip=$HOSTIP --credentials=$CREDENTIALS --update-credentials || true

# Submit an exercise
EXOTGZ=spec/org.example.fw4ex.grading.check.tgz
$AGENT --ip=$HOSTIP \
    --credentials=$CREDENTIALS \
    --type=exercise \
    --xmldir=tmp \
    --stuff=$EXOTGZ --follow

# Check that the exercise is deployed
[ -f tmp/2-exerciseAuthorReport.xml ] && \
grep ' safecookie=' < tmp/2-exerciseAuthorReport.xml

# Check that the marking reports of the pseudo jobs are present in XML and HTML
[ -f tmp/5-jobStudentReport.xml ] && \
[ -f tmp/8-jobStudentReport.html ]

# Send an answer towards this new exercise. Use --counter not to overwrite
# the previous reports in tmp/
$AGENT --ip=$HOSTIP \
    --credentials=$CREDENTIALS \
    --type=job \
    --xmldir=tmp \
    --counter=100 \
    --stuff=spec/oefgc/1.tgz --follow \
    --exercise="file:tmp/2-exerciseAuthorReport.xml" 

# Check the obtained mark:
[ -f tmp/102-jobStudentReport.xml ] && \
grep -q ' mark="10" totalMark="100"' < tmp/102-jobStudentReport.xml && \
echo OK

# end of 20-exercise.sh
