#!/bin/bash
APIPORT=$(fluxbench-cli getbenchmarks | jq -r '.ipaddress | split(":") | .[1]')
UIPORT=$((APIPORT - 1))
UIWEBPAGE="http://127.0.0.1:${UIPORT}"
APIWEBPAGE="http://127.0.0.1:${APIPORT}"

func_timestamp () {
    date +"%Y-%m-%d %T"
}
func_httpcode () {
	HTTPCODE=$(curl --max-time 5 --silent --write-out %{response_code} --output "/dev/null" "$WEBPAGE")
    }
func_upnpstatus () {
    UPNPSTATUS=$(node puppeteer_upnp.js $UIWEBPAGE/benchmark/fluxnode/getbenchmarks | grep -c "UPNP")
}

func_httpcode
if [ $HTTPCODE -eq 200 ]; then
    #echo "$(func_timestamp) #1 HTTP STATUS -> OK"
    func_upnpstatus
    if [ "$UPNPSTATUS" -eq 0 ]; then
        echo "$(func_timestamp) #1 HTTP STATUS $HTTPCODE -> OK AND UPNP STATUS -> OK"
        exit 0
    else
        echo "$(func_timestamp) #1 HTTP STATUS $HTTPCODE -> OK AND UPNP STATUS -> KO ; restarting"
        sudo reboot now
        exit 0
    fi
else
    echo "#1 HTTP STATUS $HTTPCODE -> KO : pause for 10 minutes"
    sleep 10m
    func_httpcode
    if [ $HTTPCODE -eq 200 ]; then
        echo "$(func_timestamp) #2 HTTP STATUS $HTTPCODE -> OK"
        exit 0
    else
        echo "$(func_timestamp) #2 HTTP STATUS $HTTPCODE -> KO ; restarting"
        sudo reboot now
        exit 0
    fi
fi

#todo: check the ui page with curl to http://127.0.0.1:${UIPORT} to get HTTPCODE. Then replace func_upnpstatus with curl to http://127.0.0.1:${APIPORT}/daemon/getbenchmarks, actual output : {"status":"success","data":"{\n  \"ipaddress\": \"86.66.168.9:16157\",\n  \"architecture\": \"amd64\",\n  \"armboard\": \"\",\n  \"status\": \"CUMULUS\",\n  \"time\": 1770312885,\n  \"cores\": 4,\n  \"ram\": 7.8,\n  \"ssd\": 222.99,\n  \"hdd\": 0,\n  \"ddwrite\": 432.37,\n  \"totalstorage\": 222.99,\n  \"disksinfo\": [\n    {\n      \"disk\": \"sda\",\n      \"size\": 222.99,\n      \"writespeed\": 432.37\n    }\n  ],\n  \"eps\": 391.36,\n  \"eps_singlethread\": 95.79000000000001,\n  \"eps_multithread\": 375.52,\n  \"ping\": 12.046,\n  \"download_speed\": 883.1046783125,\n  \"upload_speed\": 202.0023305,\n  \"bench_version\": \"1.0.20\",\n  \"speed_version\": \"1.2.0\",\n  \"systemsecure\": false,\n  \"error\": \"\"\n}\n"}. A working status = \"status\": \"CUMULUS\"