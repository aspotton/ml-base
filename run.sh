#!/bin/bash

# Setup local user to be the same - avoid permission issues
if [ -n "$USER" -a -n "$UID" -a -n "$GID" ]; then
	groupadd -g $GID $USER
	useradd -g $GID -G sudo -M -N $USER -d /code
else
	USER="root"
fi

ARGS="$@"
if [ -n "$ARGS" ]; then
	su $USER -c "/bin/bash -l -i -c '$@'"
else
	su $USER -c "/bin/bash -l -i"
fi
