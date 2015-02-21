#!/bin/bash -e
TEMPLATE_FILE=/etc/fluent/fluent.conf.erb

if [ -f $TEMPLATE_FILE ]; then
    erb $TEMPLATE_FILE > /etc/fluent/fluent.conf
fi

exec "$@"
