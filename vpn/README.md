# VPN

## Setup

Login to GCP, and open Google Cloud Shell. Run the command below: 

```bash
$ curl https://raw.githubusercontent.com/cognitom/personal-env/master/vpn/create.sh | bash -s YOUR_VPN_IPSEC_PSK YOUR_VPN_USER YOUR_VPN_PASSWORD
```

## Restart the container

Access to the VM via "SSH Terminal" on Codeanywhere. Then check the docker status:

```bash
$ docker ps -a
```

Restert the container:

```bash
$ docker restart vpn
```
