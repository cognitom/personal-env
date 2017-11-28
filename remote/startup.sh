#!/bin/sh

ZONE=localhost.zone
ZONENAME=localhost-zone
USERNAME=cognitom

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

setup()
{
  # Foundamental tools
  apt-get update
  apt-get install -y build-essential

  # Kryptonite CLI for key management
  curl https://krypt.co/kr | sh

  # Node
  curl -sL https://deb.nodesource.com/setup_8.x | bash
  apt-get install -y nodejs

  # Tools via NPM
  npm i -g npm-check-updates

  # Bash
  printf "\\n\\n# Simplify my prompt.\\nPS1_DEFAULT=\$PS1\\nPS1='\$ '" >> "/home/${USERNAME}/.bashrc"

  # Git
  git config --global user.name "Tsutomu Kawamura"
  git config --global user.email "cognitom@gmail.com"
}

update()
{
  apt-get update
  kr upgrade
}

tell_my_ip_address_to_dns()
{
  # Get the hostname of the instance
  HOSTNAME=$(hostname)

  # Get the ip address which is used last time
  LAST_ADDRESS=$(host "${HOSTNAME}.${ZONE}." | sed -rn 's@^.* has address @@p')

  # Get the current ip address via Metadata API
  METADATA_SERVER="http://metadata.google.internal/computeMetadata/v1"
  QUERY="instance/network-interfaces/0/access-configs/0/external-ip"
  CURRENT_ADDRESS=$(curl "${METADATA_SERVER}/${QUERY}" -H "Metadata-Flavor: Google")

  # Update Cloud DNS
  TEMP=$(mktemp -u)
  gcloud dns record-sets transaction start -z "${ZONENAME}" --transaction-file="${TEMP}"
  gcloud dns record-sets transaction remove -z "${ZONENAME}" --transaction-file="${TEMP}" \
    --name "${HOSTNAME}.${ZONE}." --ttl 300 --type A "$LAST_ADDRESS"
  gcloud dns record-sets transaction add -z "${ZONENAME}" --transaction-file="${TEMP}" \
    --name "${HOSTNAME}.${ZONE}." --ttl 300 --type A "$CURRENT_ADDRESS"
  gcloud dns record-sets transaction execute -z "${ZONENAME}" --transaction-file="${TEMP}"
}

main
