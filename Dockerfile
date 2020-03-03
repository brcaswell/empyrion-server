FROM ubuntu:bionic AS Ubuntu_Wine_Bionic

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

RUN ln -s ~/.steam/SteamApps ~/.steam/steamapps && \
	mkdir -p '~/Empyrion - Dedicated Server'

ADD files/*.sh ~/


VOLUME ["/home/steamcmd/Empyrion - Dedicate Server"]

EXPOSE 30000-30004 \
	30000-30004/udp 

ENV BRANCH "public" && \
	FORCE_APP_UPDATE 1 && \
	INSTANCE_NAME "default" && \
	TZ "America/New_York"

ENTRYPOINT ["~/start.sh"]