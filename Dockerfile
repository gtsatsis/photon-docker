FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -yqq --install-recommends apt-utils software-properties-common xvfb \
    && apt-get install -yqq --install-recommends wget curl gnupg2 \
    && curl -O https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' \
    && apt-get update && apt-get install -yqq --install-recommends wine-devel winetricks winbind \
    && useradd -m wine

ENV HOME="/home/wine"
USER wine

ENV WINEPREFIX=/home/wine/.wine WINEARCH=win64

RUN wine wineboot --init \
  && winetricks --unattended dotnet48 \
  && winetricks win10


COPY --chown=wine:wine ./photon-server /home/wine/photon
COPY --chown=wine:wine ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /home/wine/photon/deploy/bin_Win64
CMD /entrypoint.sh
