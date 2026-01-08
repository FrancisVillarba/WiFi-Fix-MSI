#!/bin/bash
# sync-versions.sh ############################################################
# Synchronies version numbers across CHANGELOG.md, rpm/wifi-fixes-msi.spec, 
# and debian/control files
# Ensures version information stays consistent across all distributions
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CHANGELOG_MD="$PROJECT_DIR/CHANGELOG.md"
RPM_SPEC="$PROJECT_DIR/rpm/wifi-fixes-msi.spec"
DEBIAN_CONTROL="$PROJECT_DIR/debian/control"

echo "Synchronising versions across CHANGELOG.md, RPM spec, and Debian control..."

# Extract the latest version from CHANGELOG.md
# Format: ## [2.1-1] - YYYY-MM-DD
extract_latest_version() {
    local changelog="$1"
    grep -m 1 '## \[' "$changelog" | sed -E 's/.*\[([0-9\.-]+)\].*/\1/'
}

# Split version string (e.g., "2.1-1") into version and release
parse_version_and_release() {
    local full_version="$1"
    local version="${full_version%-*}"  # Remove -release part
    local release="${full_version##*-}" # Remove version part
    echo "$version" "$release"
}

# Update RPM spec with version and release
update_rpm_version() {
    local spec_file="$1"
    local version="$2"
    local release="$3"
    
    sed -i "s/^Version:.*$/Version:          $version/" "$spec_file"
    sed -i "s/^Release:.*$/Release:          $release/" "$spec_file"
    echo "✓ Updated RPM spec: Version=$version, Release=$release"
}

# Update Debian control with version (stored in debian/changelog for DEB format)
# Note: debian/control doesn't store version - it's in debian/changelog
# However, we verify consistency with changelog
verify_debian_version() {
    local debian_changelog="$1"
    local expected_version="$2"
    
    local debian_version=$(head -1 "$debian_changelog" | sed -E 's/.*\(([0-9\.-]+)\).*/\1/')
    
    if [[ "$debian_version" == "$expected_version" ]]; then
        echo "✓ Verified Debian changelog: Version=$debian_version"
    else
        echo "⚠ Warning: Debian changelog version ($debian_version) differs from expected ($expected_version)"
        echo "   Run generate-changelogs.sh to regenerate debian/changelog from CHANGELOG.md"
    fi
}

# Main execution
if [[ ! -f "$CHANGELOG_MD" ]]; then
    echo "Error: CHANGELOG.md not found at $CHANGELOG_MD"
    exit 1
fi

if [[ ! -f "$RPM_SPEC" ]]; then
    echo "Error: RPM spec not found at $RPM_SPEC"
    exit 1
fi

if [[ ! -f "$DEBIAN_CONTROL" ]]; then
    echo "Error: Debian control not found at $DEBIAN_CONTROL"
    exit 1
fi

# Extract latest version from CHANGELOG.md (source of truth)
LATEST_VERSION=$(extract_latest_version "$CHANGELOG_MD")

if [[ -z "$LATEST_VERSION" ]]; then
    echo "Error: Could not extract version from CHANGELOG.md"
    exit 1
fi

echo "Latest version from CHANGELOG.md: $LATEST_VERSION"

# Parse version into components
read -r VERSION RELEASE < <(parse_version_and_release "$LATEST_VERSION")

# Update RPM spec
update_rpm_version "$RPM_SPEC" "$VERSION" "$RELEASE"

# Verify Debian changelog
verify_debian_version "$PROJECT_DIR/debian/changelog" "$LATEST_VERSION"

echo ""
echo "✓ Version synchronisation complete"
echo "  CHANGELOG.md: $LATEST_VERSION"
echo "  RPM spec:     Version=$VERSION, Release=$RELEASE"
echo "  Debian:       $LATEST_VERSION"
