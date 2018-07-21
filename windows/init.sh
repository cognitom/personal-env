#!/bin/bash

# Variables


# Installation

## Foundamental tools
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y unzip
sudo apt-get install -y mosh

## Kryptonite CLI for key management
curl https://krypt.co/kr | sh


# Settings

## Bash
printf "\n\n# Simplify my prompt.\nPS1_DEFAULT=\$PS1\nPS1='\$ '" >> ~/.bashrc
printf "\n\n# Start from home directory\ncd ~" >> ~/.profile
