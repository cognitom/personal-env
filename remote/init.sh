#!/bin/sh

# Variables
USER_NAME="cognitom"
GIT_USER_NAME="Tsutomu Kawamura"
GIT_USER_EMAIL="cognitom@gmail.com"


# Installation

## Foundamental tools
sudo apt-get update
sudo apt-get install -y build-essential

## Kryptonite CLI for key management
curl https://krypt.co/kr | sh

## Node
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash
sudo apt-get install -y nodejs

## Tools via NPM
sudo npm i -g npm-check-updates


# Settings

## Bash
printf "\n\n# Simplify my prompt.\nPS1_DEFAULT=\$PS1\nPS1='\$ '" >> ~/.bashrc
source ~/.bashrc

## Git
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"


# Startup scripts

## Tell my ip address to CloudDNS at startup
GITHUB_REPO_ROOT=https://raw.githubusercontent.com/cognitom/personal-env/master
curl ${GITHUB_REPO_ROOT}/remote/update-dns.sh > update-dns.sh
curl ${GITHUB_REPO_ROOT}/remote/update-dns.service > update-dns.service
chmod 755 update-dns.sh
chmod 664 update-dns.service
sudo chown root:root update-dns.sh update-dns.service
sudo mv update-dns.sh /usr/local/bin/
sudo mv update-dns.service /etc/systemd/system/
sudo systemctl enable update-dns
