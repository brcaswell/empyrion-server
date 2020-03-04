# Empyrion-Server

Docker Image for Empyrion Dedicated Server

Build to create a containerized version of Empyrion - Dedicate Server, a stand-alone dedicated server for [Empyrion - Galatic Survival](https://store.steampowered.com/app/383120/Empyrion__Galactic_Survival/)

Build by hand (as a Local Image)
```
git clone https://github.com/antimodes201/empyrion-server.git
docker build -t antimodes201/empyrion-server:latest .
```

## This Docker image is up at http://hub.docker.com/u/antimodes201

Docker pull

``` bash
docker pull antimodes201/empyrion-server
```

### Alternative, you can build the container using Docker Compose, which will pull the image

Docker Compose

``` bash
docker-compose up
```

### Some notes  

The Empyrion Dedicate Server steamcmd package was built for windows; as such, this distribution is based on wine.  *This comes with my standard disclaimer that you might run into oddities / strange behaviour because of this.*

You should run the built\pulled docker image of the server once before customizing your server setting.  

Running it will download and create the default config.  Afterwards, shut down the container instance and edit the dedicated config.  The server will use a custom dedicated YAML based on your INSTANCE_NAME.  This is to prevent the config from being wiped between updates.

Docker Run with defaults

``` bash
docker run -it -p 30000-30004:30000-30004/udp -p 30000-30004:30000-30004 -v /app/docker/temp-vol:/home/steamuser/common \
 -e INSTANCE_NAME="t3stn3t" \
 --name empyrion \
 antimodes201/empyrion-server:latest
```

change the volume argument to a directory on your node and maybe use a different name then the one in the example

Currently exposed environmental variables and their default values:

- BRANCH "public"
- INSTANCE_NAME "default"
- FORCE_APP_UPDATE 1
- TZ "America/New_York"

Currently exposed ports

- 30000-30004
- 30000-30004/udp
