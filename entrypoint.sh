#!/bin/bash
set -e

# Only run if template exists
if [ -f "/etc/fastd/fastd.conf.in" ]
then
	envsubst < /etc/fastd/fastd.conf.in > /etc/fastd/fastd.conf
fi

exec /usr/local/bin/fastd $@
