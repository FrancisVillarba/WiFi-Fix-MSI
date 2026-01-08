#!/bin/bash
# init-rpm.sh #################################################################
# Used to initialise the project and system dependencies to build etc.
# 
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

# ! NOTE !
# We will assume you are using Bazzite for this

set -e

echo "Setting up distrobox with relevant packages for building RPMs..."

# 1. Create the distrobox
distrobox create --image ghcr.io/ublue-os/fedora-toolbox:latest --name RPMBuilder --init --additional-packages "gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools"

# 2. Setup RPMRoot
distrobox enter RPMBuilder -- rpmdev-setuptree
