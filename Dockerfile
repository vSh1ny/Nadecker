# Original Dockerfile by willysunny
# https://github.com/willysunny/Nadecker
# Ubuntu base image from phusion
# https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:latest

ENV VERSION=1.9
ENV NADEKOBOT_GIT_REMOTE=git://github.com/Kwoth/NadekoBot.git
ENV NADEKOBOT_GIT_DEFAULT_BRANCH=1.9

WORKDIR /opt

COPY opt ./

SHELL ["/bin/bash", "-c"]

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl

RUN add-apt-repository ppa:jonathonf/ffmpeg-3 && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893

RUN curl -O https://packages.microsoft.com/config/ubuntu/$(lsb_release -sr)/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  rm -f packages-microsoft-prod.deb

RUN apt-get update && apt-get install -y software-properties-common apt-transport-https curl git dotnet-sdk-2.1.4 redis-server libopus0 opus-tools libopus-dev libsodium-dev ffmpeg rsync python python3-pip tzdata && \
	rm -rf /var/lib/apt/lists/*

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
	root=/opt; \
	\
	cd "$root"; \
	\
	info '' "Downloading NadekoBot ${branch}. Please wait…" ''; \
	\
	if [[ -n ${VERSION} ]]; then \
		branch=${VERSION}; \
	elif [[ -n ${NADEKOBOT_DEFAULT_BRANCH} ]]; then \
		branch=${NADEKOBOT_DEFAULT_BRANCH}; \
	else \
		branch='1.9'; \
	fi; \
	if [[ $(git ls-remote ${NADEKOBOT_GIT_REMOTE} ${branch} -q) ]]; then \
		git clone ${NADEKOBOT_GIT_REMOTE} -b ${branch} -q --depth 1 --recursive; \
		info '' "NadekoBot ${branch} downloaded." '' "Downloading Nadeko dependencies…" ''; \
	else \
		info '' "Incorrect git repository. Check settings." '' \
		exit 1; \
	fi; \
	\
	cd $root/NadekoBot; \
	dotnet restore; \
	info '' "Download done." '' "Building NadekoBot ${branch}…" ''; \
	dotnet build --configuration Release; \
	info '' "Building NadekoBot ${branch} done." "Installation Complete."

VOLUME ["/root/nadeko"]

CMD ["/bin/bash","/opt/nadeko_autorestart.sh"]
