#!/bin/bash
# build-deb.sh ################################################################
# Used to build the DEB package using Docker and dpkg-buildpackage
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

# ! NOTE !
# Assumes Docker is installed and you have run tools/init-deb.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Making sure we have the build image available in docker"
bash "$SCRIPT_DIR/init-deb.sh"
echo " "

echo "Building wifi-fixes-msi DEB package..."

# Run the build in a Docker container
docker run --rm \
  -v "$PROJECT_DIR:/build" \
  -w /build \
  debian:bookworm \
  bash -c "
    set -e

    # Install build dependencies
    echo 'Installing build dependencies...'
    apt-get update -qq
    apt-get install -y -qq build-essential debhelper devscripts dpkg-dev fakeroot lintian

    # Build the package
    echo 'Building DEB package...'
    dpkg-buildpackage -us -uc -b

    echo 'Build complete!'
  "

echo ""
echo "Build complete! Generated package location:"
echo "  $PROJECT_DIR/../wifi-fixes-msi_*.deb"
echo ""
echo "To install on Debian/Ubuntu systems:"
echo "  sudo dpkg -i ../wifi-fixes-msi_*.deb"
echo ""
