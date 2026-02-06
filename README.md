# Auto restart on local website failure

Auto restart the node when local homepage is down

# How it works:

1. Get API port from fluxbench-cli and calculate UI port

2. Test the homepage

a. Test if page is up but benchmark failure is present

b. Restart the node if benchmark status is not CUMULUS, NIMBUS, or STRATUS

3. Wait 10m if down and test again

4. Restart if still down

# How to use:

Login to the server with the same user as the node (`home` directory where the flux node is installed) using `ssh`

Download the script

```
wget -N https://github.com/VinxItak/fluxnode/releases/download/v3.0.0/test_flux.sh

```

Copy and paste command below to set the exec permission to the script, create log file and setup crontab ; and install prerequisites

```
# Prerequisites: `fluxbench-cli`, `jq`, and `curl` should be available on the server.
# Install common tools on Debian/Ubuntu if missing:
sudo apt-get update && sudo apt-get install -y jq curl

chmod +x test_flux.sh && mkdir -p crontab_logs && touch crontab_logs/test_flux.log && crontab -l | sed "\$a*/15 * * * * /home/$USER/test_flux.sh >> /home/$USER/crontab_logs/test_flux.log 2>&1" | crontab -

```

the Crontab is set to execute script every 15 minutes

Logs directory `/home/$USER/crontab_logs/test_flux.log`

# Want to thanks me ?

Buy me a coffee (Flux address) : t1X4BcB1zopHePw4Cp8yammCmWXWjSFZ8Kg
