#!/bin/bash
# build-rpm.sh ################################################################
# Used to build the RPM package using distrobox and rpmbuild
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

# ! NOTE !
# We will assume you are using Bazzite for this and have run tools/init-rpm.sh

set -e

echo "Building wifi-fixes-msi RPM package..."

# Build the RPM package
distrobox enter RPMBuilder -- rpmbuild -bb ./rpm/wifi-fixes-msi.spec

echo ""
echo "Build complete! Generated package location:"
echo "  ~/rpmbuild/RPMS/noarch/wifi-fixes-msi-*.rpm"
echo ""
echo "To install on rpm-ostree systems:"
echo "  rpm-ostree install ~/rpmbuild/RPMS/noarch/wifi-fixes-msi-*.rpm"
echo "  systemctl reboot"
