#!/bin/sh

USERNAME="cognitom"

DNS_ZONE_NAME=$(gcloud compute project-info describe --format "value(dnsZoneName)")
ZONE=$(gcloud dns record-sets list --zone ${DNS_ZONE_NAME} --limit 1 --format "value(name)")

INITIALIZED_FLAG=".startup_script_initialized"

main()
{
  tell_my_ip_address_to_dns
  if test -e $INITIALIZED_FLAG
  then
    # Startup Scripts
    update
  else
    # Only first time
    setup
    touch $INITIALIZED_FLAG
  fi
}

# Installation and settings
setup()
{
  # Foundamental tools
  apt-get update
  apt-get install -y build-essential
  apt-get install -y chromium-browser
  apt-get install -y libgconf-2-4 # needed for chrome
  apt-get install -y openvpn
  apt-get install -y unzip
  apt-get install -y mosh

  # Kryptonite CLI for key management
  curl https://krypt.co/kr | sh

  # Node
  curl -sL https://deb.nodesource.com/setup_8.x | bash
  apt-get install -y nodejs
  
  # MongoDB 3.6
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" \
    | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
  apt-get update
  apt-get install -y mongodb-org

  # Tools via NPM
  npm i -g npm-check-updates

  # Bash
  printf "\\n\\n# Simplify my prompt.\\nPS1_DEFAULT=\$PS1\\nPS1='\$ '" >> "/home/${USERNAME}/.bashrc"

  # Git
  sudo -i -u "${USERNAME}" git config --global user.name "Tsutomu Kawamura"
  sudo -i -u "${USERNAME}" git config --global user.email "cognitom@gmail.com"
}

# Update on each startup except the first time
update()
{
  apt-get update
  apt-get upgrade
  kr upgrade
}

tell_my_ip_address_to_dns()
{
  # Get the hostname of the instance
  HOSTNAME=$(hostname)

  # Get the ip address which is used last time
  LAST_PUBLIC_ADDRESS=$(host "public.${HOSTNAME}.${ZONE}" | sed -rn 's@^.* has address @@p')
  LAST_PRIVATE_ADDRESS=$(host "${HOSTNAME}.${ZONE}" | sed -rn 's@^.* has address @@p')

  # Get the current public ip address via Metadata API
  METADATA_SERVER="http://metadata.google.internal/computeMetadata/v1"
  QUERY="instance/network-interfaces/0/access-configs/0/external-ip"
  PUBLIC_ADDRESS=$(curl "${METADATA_SERVER}/${QUERY}" -H "Metadata-Flavor: Google")
  
  # Get the current local ip address
  PRIVATE_ADDRESS=$(hostname -i)

  # Update Cloud DNS
  TEMP=$(mktemp -u)
  gcloud dns record-sets transaction start -z "${DNS_ZONE_NAME}" --transaction-file="${TEMP}"
  if test "$LAST_PUBLIC_ADDRESS" != ""
  then
    gcloud dns record-sets transaction remove -z "${DNS_ZONE_NAME}" --transaction-file="${TEMP}" \
      --name "public.${HOSTNAME}.${ZONE}" --ttl 300 --type A "$LAST_PUBLIC_ADDRESS"
  fi
  gcloud dns record-sets transaction add -z "${DNS_ZONE_NAME}" --transaction-file="${TEMP}" \
    --name "public.${HOSTNAME}.${ZONE}" --ttl 300 --type A "$PUBLIC_ADDRESS"
  
  if test "$LAST_PRIVATE_ADDRESS" != ""
  then
    gcloud dns record-sets transaction remove -z "${DNS_ZONE_NAME}" --transaction-file="${TEMP}" \
      --name "${HOSTNAME}.${ZONE}" --ttl 300 --type A "$LAST_PRIVATE_ADDRESS"
  fi
  gcloud dns record-sets transaction add -z "${DNS_ZONE_NAME}" --transaction-file="${TEMP}" \
    --name "${HOSTNAME}.${ZONE}" --ttl 300 --type A "$PRIVATE_ADDRESS"
  gcloud dns record-sets transaction execute -z "${DNS_ZONE_NAME}" --transaction-file="${TEMP}"
}

main
