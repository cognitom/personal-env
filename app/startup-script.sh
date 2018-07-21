#!/bin/sh

INITIALIZED_FLAG=".startup_script_initialized"

main()
{
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
  docker volume create portainer_data
  docker run -d -p 80:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    --restart=unless-stopped \
    portainer/portainer
}

# Update on each startup except the first time
update()
{
}

main
