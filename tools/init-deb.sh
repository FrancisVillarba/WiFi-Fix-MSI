#!/bin/bash
# init-deb.sh #################################################################
# Used to initialise Docker image for building DEB packages
#
# ! NOTE !
# Assumes Docker (or equivalent) is installed!
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

set -e

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is required but not installed. Please install Docker to proceed."
    exit 1
fi

# Pull the Debian bookworm image
echo "Pulling Debian Docker image for building DEB packages..."

# Pull the Debian bookworm image
docker pull debian:bookworm

echo ""
echo "Docker image 'debian:bookworm' ready!"
echo "You can now run tools/build-deb.sh to build the package."
echo ""
