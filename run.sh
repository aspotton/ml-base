#!/bin/bash

# Setup local user to be the same - avoid permission issues
if [ -n "$USER" -a -n "$UID" -a -n "$GID" ]; then
	groupadd -g $GID $USER
	useradd -g $GID -G sudo -M -N $USER -d /code
else
	USER="root"
fi

$@
