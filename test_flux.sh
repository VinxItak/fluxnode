PORT=$(hostname | awk '{print substr($0,length($0))}')
WEBPAGE="http://127.0.0.1:161${PORT}6"

func_timestamp () {
    date +"%Y-%m-%d %T"
}
func_httpcode () {
	HTTPCODE=$(curl --max-time 5 --silent --write-out %{response_code} --output "/dev/null" "$WEBPAGE")
    }
func_upnpstatus () {
    UPNPSTATUS=$(node puppeteer_upnp.js $WEBPAGE/benchmark/fluxnode/getbenchmarks | grep -c "UPNP")
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
