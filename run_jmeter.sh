#! /bin/bash

curl "http://localhost:80/booking/loader/load"
echo "\n"
curl "http://localhost:80/flight/loader/load"
echo "\n"
curl "http://localhost:80/customer/loader/load?numCustomers=10000"
echo "\n"

docker run -it --rm --cpus=1 -v $PWD/jmeter_output:/output --network host -e JHOST=localhost -e JPORT=80 -e JTHREAD=2 -e JDURATION=600 -e JUSER=199 --name jmeter jmeter
