#!/usr/bin/env bash
set -eu

SCRIPT="$(realpath $(dirname "${BASH_SOURCE[0]}"))"
CONF="config.sh"

create_config()
{
	cat > "$SCRIPT/$CONF" << EOF
SERENITY_SOURCE_DIR=${SERENITY_SOURCE_DIR:-}
EOF
}

info()
{
	echo "[?] $@"
}

warn()
{
	echo "[!] $@"
}

load_config()
{
	. "$SCRIPT/$CONF"
}

if [ ! -f "$SCRIPT/$CONF" ]; then
    >&2 info "No configuration found. Setting up defaults"
    create_config
fi

load_config

if [ ! "${SERENITY_SOURCE_DIR}" ]; then
    >&2 warn "Could not find SerenityOS source repository"
    >&2 warn "Set the correct path in 'config.sh' in the root of this repository"
    exit 1
fi

SERENITY_PORT_DIR="$SERENITY_SOURCE_DIR/Ports"
if [ ! -f "$SERENITY_PORT_DIR/.port_include.sh" ]; then
    >&2 warn "Could not find SerenityOS port directory"
    >&2 warn "Verify config.sh is correctly configured"
    exit 1
fi

export SERENITY_PORT_DIRS=("$SCRIPT")

source $SERENITY_PORT_DIR/.port_include.sh

