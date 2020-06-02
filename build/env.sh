#!/bin/sh

set -e

if [ ! -f "build/env.sh" ]; then
    echo "$0 must be run from the root of the repository."
    exit 2
fi

# Create fake Go workspace if it doesn't exist yet.
workspace="$PWD/build/_workspace"
root="$PWD"
dpethdir="$workspace/src/github.com/eeefan"
if [ ! -L "$dpethdir/dpeth" ]; then
    mkdir -p "$dpethdir"
    cd "$dpethdir"
    ln -s ../../../../../. dpeth
    cd "$root"
fi

# Set up the environment to use the workspace.
GOPATH="$workspace"
export GOPATH
export GO111MODULE="off"
# Run the command inside the workspace.
cd "$dpethdir/dpeth"
PWD="$dpethdir/dpeth"

# Launch the arguments with the configured environment.
exec "$@"
