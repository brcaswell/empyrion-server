FROM local-base/empyrion-server:latest AS Empyrion_Installed


# Run app validate several times workaround steam app install bug
RUN /usr/games/steamcmd +login anonymous +app_update 530870 validate +quit || \
   /usr/games/steamcmd +login anonymous +app_update 530870 validate +quit

ENV FORCE_APP_UPDATE=0

#ADD ../start.sh /home/steamuser/start2.sh
#ENTRYPOINT ["/home/steamuser/start2.sh"]