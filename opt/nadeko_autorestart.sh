#!/bin/bash
info() {
    printf '%s\n' "$@"
}

if hash dotnet 2>/dev/null ; then
	info "Dotnet installed."
else
	info "Dotnet is not installed. Please install dotnet."
	exit 1
fi

info '' "Setting Nadeko Credentials"
mv -n /opt/NadekoBot/src/NadekoBot/credentials.json /root/nadeko/credentials.json > /dev/null 2>&1
rm /opt/NadekoBot/src/NadekoBot/credentials.json > /dev/null 2>&1
ln -s /root/nadeko/credentials.json /opt/NadekoBot/src/NadekoBot/credentials.json > /dev/null 2>&1

patchfile="/root/nadeko/patch/patch.sh"
mkdir -p $(dirname $patchfile)
if [ -s "$patchfile" ] && [ -x "$patchfile" ]; then
	info '' "Patching Nadeko Data Folder"
	bash "/root/nadeko/patch/patch.sh"
else
	info '' "Patch file does not exist"
fi

info '' "Starting Redis-Server"
/usr/bin/redis-server --daemonize yes

info '' "Running NadekoBot with auto restart" "Please wait"
cd /opt/NadekoBot/src/NadekoBot
while :; do dotnet run -c Release --no-build; sleep 5s; done
info "Done"

exit 0
