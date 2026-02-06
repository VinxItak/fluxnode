#!/bin/bash
APIPORT=$(fluxbench-cli getbenchmarks | jq -r '.ipaddress | split(":") | .[1]')
UIPORT=$((APIPORT - 1))
UIWEBPAGE="http://127.0.0.1:${UIPORT}"
APIWEBPAGE="http://127.0.0.1:${APIPORT}"

func_timestamp () {
    date +"%Y-%m-%d %T"
}
func_httpcode () {
	HTTPCODE=$(curl --max-time 5 --silent --write-out %{response_code} --output "/dev/null" "$UIWEBPAGE")
    }
func_benchmarkstatus () {
    BENCHMARKSTATUS=$(curl --max-time 5 --silent "$APIWEBPAGE/daemon/getbenchmarks" | jq -r '.data | fromjson | .status')
}

func_httpcode
if [ $HTTPCODE -eq 200 ]; then
    #echo "$(func_timestamp) #1 HTTP STATUS -> OK"
    func_benchmarkstatus
    if [ "$BENCHMARKSTATUS" = "CUMULUS" ] || [ "$BENCHMARKSTATUS" = "NIMBUS" ] || [ "$BENCHMARKSTATUS" = "STRATUS" ]; then
        echo "$(func_timestamp) #1 HTTP STATUS $HTTPCODE -> OK AND BENCHMARK STATUS -> $BENCHMARKSTATUS"
        exit 0
    else
        echo "$(func_timestamp) #1 HTTP STATUS $HTTPCODE -> OK BUT BENCHMARK STATUS -> $BENCHMARKSTATUS ; restarting"
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