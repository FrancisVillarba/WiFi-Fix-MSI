#!/bin/bash
# bump-version.sh #############################################################
# Bumps version number, adds new section to CHANGELOG.md, and syncs all files
# Automates the version increment process across all distribution files
#
# Usage: 
#   ./bump-version.sh <new-version>
#   ./bump-version.sh 2.2-1
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CHANGELOG_MD="$PROJECT_DIR/CHANGELOG.md"

# Extract current version from CHANGELOG.md
get_current_version() {
    grep -m 1 '## \[' "$CHANGELOG_MD" | sed -E 's/.*\[([0-9\.-]+)\].*/\1/'
}

# Add new version section to CHANGELOG.md
add_changelog_section() {
    local new_version="$1"
    local date=$(date +%Y-%m-%d)
    local temp_file="$CHANGELOG_MD.tmp"
    
    # Read the header (everything before the first version)
    sed -n '1,/^## \[/p' "$CHANGELOG_MD" | head -n -1 > "$temp_file"
    
    # Add new version section
    {
        echo "## [$new_version] - $date"
        echo ""
        echo "### Added"
        echo ""
        echo "### Changed"
        echo ""
        echo "### Fixed"
        echo ""
    } >> "$temp_file"
    
    # Append the rest of the changelog
    sed -n '/^## \[/,$p' "$CHANGELOG_MD" >> "$temp_file"
    
    mv "$temp_file" "$CHANGELOG_MD"
    echo "✓ Added version $new_version to CHANGELOG.md"
}

# Main execution
echo "=========================================="
echo "  WiFi-Fix-MSI: Version Bump"
echo "=========================================="
echo ""

# Get current version
CURRENT_VERSION=$(get_current_version)
echo "Current version: $CURRENT_VERSION"
echo ""

# Get new version from argument or prompt
if [[ -n "$1" ]]; then
    NEW_VERSION="$1"
else
    read -p "Enter new version (e.g., 2.2-1): " NEW_VERSION
fi

# Validate version format
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\-[0-9]+$ ]]; then
    echo "Error: Invalid version format. Expected format: X.Y-Z (e.g., 2.2-1)"
    exit 1
fi

echo ""
echo "Bumping version: $CURRENT_VERSION → $NEW_VERSION"
echo ""

# Add new section to CHANGELOG.md
add_changelog_section "$NEW_VERSION"

echo ""
echo "Running sync-all to propagate changes..."
echo ""

# Run sync-versions to update all distribution files
bash "$SCRIPT_DIR/sync-versions.sh"

echo ""
echo "=========================================="
echo "✓ Version bump complete: $NEW_VERSION"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Edit CHANGELOG.md and fill in the changes"
echo "  2. Run sync-all.sh after editing to ensure everything is up-to-date"
echo "  3. Commit and tag the release"
