#!/bin/sh

# Settings
ZONE=localhost.zone
ZONENAME=localhost-zone

# Get the hostname of the instance
HOSTNAME=$(hostname)

# Get the ip address which is used last time
LAST_ADDRESS=$(host "${HOSTNAME}.${ZONE}." | sed -rn 's@^.* has address @@p')

# Get the current ip address via Metadata API
API_ROOT="http://metadata.google.internal/computeMetadata/v1"
COMMAND="instance/network-interfaces/0/access-configs/0/external-ip"
CURRENT_ADDRESS=$(curl "${API_ROOT}/${COMMAND}" -H "Metadata-Flavor: Google")

# Update Cloud DNS
$TEMP=$(mktemp)
gcloud dns record-sets transaction start -z "${ZONENAME}" --transaction-file="${TEMP}"
gcloud dns record-sets transaction remove -z "${ZONENAME}" --transaction-file="${TEMP}" \
  --name "${HOSTNAME}.${ZONE}." --ttl 300 --type A "$LAST_ADDRESS"
gcloud dns record-sets transaction add -z "${ZONENAME}" --transaction-file="${TEMP}" \
  --name "${HOSTNAME}.${ZONE}." --ttl 300 --type A "$CURRENT_ADDRESS"
gcloud dns record-sets transaction execute -z "${ZONENAME}" --transaction-file="${TEMP}"
