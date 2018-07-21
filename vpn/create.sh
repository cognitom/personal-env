#!/bin/bash

# Settings
PROJECT_NAME="personal-env"
INSTANCE_NAME="vpn"

# Arguments
VPN_IPSEC_PSK="$1"
VPN_USER="$2"
VPN_PASSWORD="$3"

# Get Service Account information
SERVICE_ACCOUNT=$(\
  gcloud iam --project "${PROJECT_NAME}" \
    service-accounts list \
    --limit 1 \
    --format "value(email)")
    
STARTUP_SCRIPT=$(echo -e "#! /bin/bash\nmodprobe af_key")

# Create a instance
gcloud beta compute --project "${PROJECT_NAME}" \
  instances create-with-container "${INSTANCE_NAME}" \
  --zone "asia-northeast1-a" \
  --machine-type "f1-micro" \
  --subnet "default" \
  --address "35.200.42.215" \
  --network-tier "PREMIUM" \
  --metadata startup-script="${STARTUP_SCRIPT}" \
  --can-ip-forward \
  --maintenance-policy "MIGRATE" \
  --service-account "${SERVICE_ACCOUNT}" \
  --tags "vpn" \
  --image-family "cos-stable" \
  --image-project "cos-cloud" \
  --boot-disk-size "10" \
  --boot-disk-type "pd-standard" \
  --boot-disk-device-name "${INSTANCE_NAME}" \
  --container-image "docker.io/hwdsl2/ipsec-vpn-server" \
  --container-restart-policy "always" \
  --container-privileged \
  --container-env VPN_IPSEC_PSK="${VPN_IPSEC_PSK}",VPN_USER="${VPN_USER}",VPN_PASSWORD="${VPN_PASSWORD}" \
  --container-mount-host-path mount-path="/lib/modules",host-path="/lib/modules",mode="ro"
