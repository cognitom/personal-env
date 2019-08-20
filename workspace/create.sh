#!/bin/sh

# Settings
PROJECT_NAME="personal-env"
GITHUB_REPO="cognitom/personal-env"
INSTANCE_NAME="workspace"

# Arguments
IP_ADDRESS="$1"

# Get Service Account information
SERVICE_ACCOUNT=$(\
  gcloud iam --project "${PROJECT_NAME}" \
    service-accounts list \
    --limit 1 \
    --format "value(email)")

# Create a instance
gcloud beta compute --project "${PROJECT_NAME}" \
  instances create "${INSTANCE_NAME}" \
  --zone "asia-northeast1-a" \
  --machine-type "n1-standard-1" \
  --subnet "default" \
  --address "${IP_ADDRESS}" \
  --can-ip-forward \
  --tags "vpn" \
  --maintenance-policy "MIGRATE" \
  --service-account "${SERVICE_ACCOUNT}" \
  --min-cpu-platform "Automatic" \
  --image-family "cos-stable" \
  --image-project "cos-cloud" \
  --boot-disk-size "100" \
  --boot-disk-type "pd-standard" \
  --boot-disk-device-name "${INSTANCE_NAME}"
