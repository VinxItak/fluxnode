# Auto restart on local website failure
Auto restart the node when local homepage is down

# How it works:
Get upnp port from hostname (ex : cumulus**2** = port 161**2**6), adapt it for your usage

Test the homepage

Wait 10m if down and test again

Restart if still down


# How to use:
Login to the server with the same user as the node (`home` directory where the flux node is installed) using `ssh`

download the script

```
wget https://github.com/VinxItak/fluxnode/releases/download/v1.0.0/test_flux.sh
```
copy and paste command below to set the exec permission to the script , create log file and setup crontab

```
chmod +x test_flux.sh && mkdir crontab_logs && touch crontab_logs/test_flux.log && crontab -l | sed "\$a*/15 * * * * /home/$USER/test_flux.sh >> /home/$USER/crontab_logs/test_flux.log 2>&1" | crontab -
```
the Crontab is set to execute script every 15 minutes

Logs directory `/home/$USER/crontab_logs/test_flux.log`
