# Original Dockerfile by willysunny
# https://github.com/willysunny/Nadecker
# Ubuntu base image from phusion
# https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:latest

ENV NADEKOBOT_DEFAULT_BRANCH=1.9

WORKDIR /opt/

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg && \
  sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list' && \
  add-apt-repository ppa:jonathonf/ffmpeg-3 && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893

RUN apt-get update && apt-get install -y software-properties-common apt-transport-https curl git dotnet-sdk-2.1.4 redis-server libopus0 opus-tools libopus-dev libsodium-dev ffmpeg rsync python python3-pip tzdata

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl && \
  curl -O https://cdn.rawgit.com/vSh1ny/Nadecker-BashScript/5f859eb4/nadeko_installer.sh && chmod +rx nadeko_installer.sh && \
  curl -O https://cdn.rawgit.com/vSh1ny/Nadecker-BashScript/5f859eb4/nadeko_autorestart.sh && chmod +rx nadeko_autorestart.sh

RUN ./nadeko_installer.sh

VOLUME ["/root/nadeko"]

CMD ["sh","/opt/nadeko_autorestart.sh"]