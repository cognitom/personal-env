#!/bin/bash

# Variables


# Installation

## Foundamental tools
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y unzip

## Kryptonite CLI for key management
# at this point, instlation will fail on Windows...
# curl https://krypt.co/kr | sh

## GCP - see https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk


# Settings

## Bash
printf "\n\n# Simplify my prompt.\nPS1_DEFAULT=\$PS1\nPS1='\$ '" >> ~/.bashrc
printf "\n\n# Start from home directory\ncd ~" >> ~/.profile
