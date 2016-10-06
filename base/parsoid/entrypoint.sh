#!/bin/bash
LOCALSETTINGS_FILE=/usr/lib/parsoid/src/api/localsettings.js

set -e

if [ ! -h settings.js ]; then
	echo >&2 "Copying original 'settings.js' into data volume, creating symbolic link."

	if [ ! -e /data/settings.js ]; then
		mv settings.js /data/settings.js
	fi

	ln -s "/data/settings.js" settings.js
fi

if [ ! -h "$LOCALSETTINGS_FILE" ]; then
	echo >&2 "Copying original 'localsettings.js' into data volume, creating symbolic link."

	if [ ! -e "/data/localsettings.js" ]; then
		mv "$LOCALSETTINGS_FILE" /data/localsettings.js
	fi

	ln -s "/data/localsettings.js" "$LOCALSETTINGS_FILE"
fi

exec "$@"

