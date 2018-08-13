# Original Dockerfile by willysunny
# https://github.com/willysunny/Nadecker
# Ubuntu base image from phusion
# https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:latest

ARG VERSION
ENV VERSION ${VERSION:-1.9}
ARG NADEKOBOT_GIT_REMOTE
ENV NADEKOBOT_GIT_REMOTE ${NADEKOBOT_GIT_REMOTE:-git://github.com/Kwoth/NadekoBot.git}

WORKDIR /opt

COPY opt ./

SHELL ["/bin/bash", "-c"]

RUN curl -sL https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl

RUN add-apt-repository ppa:jonathonf/ffmpeg-3 && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893

RUN curl -sO https://packages.microsoft.com/config/ubuntu/$(lsb_release -sr)/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  rm -f packages-microsoft-prod.deb

  RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    dotnet-sdk-2.1 \
    ffmpeg \
    git \
    libopus-dev \
    libopus0 \
    libsodium-dev \
    opus-tools \
    python \
    python3-pip \
    redis-server \
    rsync \
    software-properties-common \
    tzdata \
  	&& rm -rf /var/lib/apt/lists/*

RUN info() { printf '%s\n' "$@"; }; \
	\
	info '' "NadekoBot Installer started."; \
	\
	if hash git 1>/dev/null 2>&1; then \
	    info '' "Git Installed."; \
	else \
	    info '' "Git is not installed. Please install Git."; \
	    exit 1; \
	fi; \
	\
	if hash dotnet 1>/dev/null 2>&1; then \
	    info '' "Dotnet installed."; \
	else \
	    info '' "Dotnet is not installed. Please install dotnet."; \
	    exit 1; \
	fi; \
	\
	if [[ -n ${VERSION} ]]; then \
		branch=${VERSION}; \
	else \
		branch='1.9'; \
	fi; \
	\
	root=/opt; \
	\
	cd "$root"; \
	\
	info '' "Downloading NadekoBot ${branch}. Please wait…" ''; \
	\
	if [[ $(git ls-remote ${NADEKOBOT_GIT_REMOTE} ${branch} -q) ]]; then \
		git clone ${NADEKOBOT_GIT_REMOTE} -b ${branch} -q --depth 1 --recursive; \
		info '' "NadekoBot ${branch} downloaded."; \
	else \
		info '' "Incorrect git repository. Check settings." '' \
		exit 1; \
	fi; \
	\
	cd $root/NadekoBot; \
	info '' "Downloading NadekoBot dependencies…" '' \
	dotnet restore; \
	info '' "Download done." '' "Building NadekoBot ${branch}…" ''; \
	dotnet build --configuration Release; \
	info '' "Building NadekoBot ${branch} done." "Installation Complete."

VOLUME ["/root/nadeko"]

CMD ["/bin/bash","/opt/nadeko_autorestart.sh"]
