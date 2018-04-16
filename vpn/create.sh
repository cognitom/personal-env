#!/bin/sh

# Settings
PROJECT_NAME="personal-env"
GITHUB_REPO="cognitom/personal-env"


# Arguments
INSTANCE_NAME="$1"

if test "$INSTANCE_NAME" = ""
then
  echo "[Error] Instance name required." 1>&2
  exit 1
fi

# Download startup script
TEMP=$(mktemp -u)
CONTENTS_ROOT="https://raw.githubusercontent.com/${GITHUB_REPO}/master"
curl ${CONTENTS_ROOT}/vpn/startup-script.sh > "${TEMP}"

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
  --machine-type "g1-small" \
  --subnet "default" \
  --can-ip-forward \
  --maintenance-policy "MIGRATE" \
  --service-account "${SERVICE_ACCOUNT}" \
  --scopes "https://www.googleapis.com/auth/cloud-platform" \
  --min-cpu-platform "Automatic" \
  --image "ubuntu-1604-xenial-v20180405" \
  --image-project "ubuntu-os-cloud" \
  --boot-disk-size "10" \
  --boot-disk-type "pd-standard" \
  --boot-disk-device-name "${INSTANCE_NAME}" \
  --metadata-from-file startup-script="${TEMP}"
  
rm "${TEMP}"