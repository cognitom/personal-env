#!/bin/sh

ZONE=librize.org
ZONENAME=librize-org
USERNAME=cognitom
GITHUB_REPO="${USERNAME}/setup-ipsec-vpn"

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
  
  # VPN
  # sha2-truncbug modification is needed for Android 7
  VPN_USER="${USERNAME}"
  OUTPUT="/home/${VPN_USER}/vpn.log"
  CONTENTS_ROOT="https://raw.githubusercontent.com/${GITHUB_REPO}/master"
  curl ${CONTENTS_ROOT}/vpnsetup.sh | \
    sed 's/sha2-truncbug=yes/sha2-truncbug=no/' | \
    sh > "${OUTPUT}"
  chown cognitom:cognitom "${OUTPUT}"
}

# Update on each startup except the first time
update()
{
  apt-get update
  apt-get upgrade
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
