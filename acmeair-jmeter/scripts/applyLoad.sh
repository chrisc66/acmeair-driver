#! /bin/bash
cd $JMETER_HOME

if [ $# -gt 0 ]
  then
    sed -i 's/localhost/'$1'/g' hosts.csv
fi

echo jmeter -n -t AcmeAir-microservices.jmx -DusePureIDs=true -j /outpu    t/acmeair.stats.0 -JHOST=$JHOST -JPORT=$JPORT -JTHREAD=$JTHREAD -JUSER=    $JUSER -JDURATION=$JDURATION -JRAMP=0 -JDELAY=0

exec jmeter -n -t AcmeAir-microservices.jmx -DusePureIDs=true -j /output/acmeair.stats.0 -JHOST=$JHOST -JPORT=$JPORT -JTHREAD=$JTHREAD -JUSER=$JUSER -JDURATION=$JDURATION -JRAMP=0 -JDELAY=0

