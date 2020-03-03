FROM ubuntu:bionic AS Ubuntu_Wine_Bionic

ENV BRANCH "public" && \
	INSTANCE_NAME "default" && \
	TZ "America/New_York"

RUN export DEBIAN_FRONTEND noninteractive && \
    dpkg --add-architecture i386 && \
    apt-get update 
	
RUN apt-get install -y net-tools \ 
	wget \ 
	curl \
	gnupg2 \	
	tzdata \
	xz-utils \
	software-properties-common \
	xvfb && \
	printf "\n2\n"|apt-get install -y steamcmd	
	
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 76F1A20FF987672F && \
RUN curl -s https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
	apt update

RUN apt-get install -y wine-staging=4.10~bionic \
	wine-staging-i386=4.10~bionic \
	wine-staging-amd64=4.10~bionic \
	winetricks && \
    rm -rf /var/lib/apt/lists/*

FROM Ubuntu_Wine_Bionic AS Ubuntu_Wine_Steamcmd

RUN useradd -m steamuser

USER steamuser
WORKDIR /home/steamuser

RUN /usr/games/steamcmd +quit

FROM Ubuntu_Wine_Steamcmd AS Ubuntu_Wine_Steamcmd_Empyrion

RUN mkdir -p '/home/steamuser/Empyrion - Dedicated Server/steamapps'

# Run app validate several times workaround steam app install bug
RUN /usr/games/steamcmd +login anonymous +app_update 530870 validate  +quit || \
   /usr/games/steamcmd +login anonymous +app_update 530870 validate  +quit ; exit 0

RUN mkdir -p ~/.steam/sdk32 && ln -s ~/.steam/steamcmd/linux32/steamclient.so ~/.steam/sdk32/steamclient.so && \
	ln -s ~/.steam/SteamApps ~/.steam/steamapps

# Make a volume
# contains configs and world saves
VOLUME [ "/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/Saves",	\
	"/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/Logs", \
	"/home/steamuser/.steam/steamapps/common/Empyrion - Dedicated Server/Content/Mods" ]

ADD files/*.sh ~/

EXPOSE 26900 \
	30000-30004 \
	30000-30004/udp 