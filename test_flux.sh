TIMESTAMP=$(date +"%Y-%m-%d %T")
PORT=$(hostname | awk '{print substr($0,length($0))}')
WEBPAGE="http://127.0.0.1:161${PORT}6"
HTTPCODE=$(curl --max-time 5 --silent --write-out %{response_code} --output "$STDOUTFILE" "$WEBPAGE")

if test $HTTPCODE -eq 200; then
    echo "$TIMESTAMP #1 HTTP STATUS CODE $HTTPCODE -> OK"
    exit 0
else
    sleep 10m
    if test $HTTPCODE -eq 200; then
        echo "$TIMESTAMP #2 HTTP STATUS CODE $HTTPCODE -> OK"
        exit 0
    else
        echo "$TIMESTAMP Site is down, restarting"
        sudo reboot now
        exit 0
    fi
fi
