# Dockerfile to build a jmeter container able to drive acmeair
# Results appear on /output in the container
# Must specify the hostname for the acmeair application (or localhost will be assumed)

FROM ibmjava:8-jre

ENV JMETER_VERSION 2.13

# Install pre-requisite packages
RUN apt-get update && apt-get install -y --no-install-recommends wget unzip \
       && rm -rf /var/lib/apt/lists/*

# Install jmeter
RUN   mkdir /jmeter \
        && mkdir /output \
        && cd /jmeter/ \
        && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz \
        && tar -xzf apache-jmeter-$JMETER_VERSION.tgz \
        && rm apache-jmeter-$JMETER_VERSION.tgz

# Set jmeter home
ENV JMETER_HOME  /jmeter/apache-jmeter-$JMETER_VERSION

# Add jmeter to the PATH
ENV PATH $JMETER_HOME/bin:$PATH

# Set JVM options
ENV JVM_ARGS "-Xms1g -Xmx1g -Xtune:virtualized"

# We should set summariser.interval=6 in bin/jmeter.properties
RUN echo 'summariser.interval=6' >> $JMETER_HOME/bin/jmeter.properties

# Copy the script to be executed and other needed files
COPY acmeair-jmeter/scripts/AcmeAir-microservices.jmx $JMETER_HOME/AcmeAir-microservices.jmx
COPY acmeair-jmeter/scripts/Airports.csv $JMETER_HOME/Airports.csv
COPY acmeair-jmeter/scripts/Airports2.csv $JMETER_HOME/Airports2.csv
COPY acmeair-jmeter/scripts/hosts.csv $JMETER_HOME/hosts.csv
COPY acmeair-jmeter/scripts/json-simple-1.1.1.jar $JMETER_HOME/lib/ext/
COPY acmeair-jmeter-2.0.0-SNAPSHOT.jar $JMETER_HOME/lib/ext/
COPY acmeair-jmeter/scripts/applyLoad.sh $JMETER_HOME/bin/applyLoad.sh
RUN chmod u+x $JMETER_HOME/bin/applyLoad.sh

# Adjust the host this is going to connect to based on an environment variable
ENV LIBERTYHOST acmeair-acmeair-jitaas

# Environment variables that we want the user to redefine
ENV JPORT 9090
ENV JUSERBOTTOM 0
ENV JUSER 199
ENV JURL acmeair-webapp
ENV JTHREAD 15
ENV JDURATION=60

ENTRYPOINT ["applyLoad.sh"]
