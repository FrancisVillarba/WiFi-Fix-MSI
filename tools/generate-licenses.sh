#!/bin/bash
# generate-licenses.sh ########################################################
# Synchronies LICENSE file across rpm/wifi-fixes-msi.spec and debian/copyright
# Ensures license information stays synchronised across distributions
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LICENSE_FILE="$PROJECT_DIR/LICENSE"
DEBIAN_COPYRIGHT="$PROJECT_DIR/debian/copyright"
RPM_SPEC="$PROJECT_DIR/rpm/wifi-fixes-msi.spec"

echo "Synchronising LICENSE files..."

# Parse LICENSE file and extract license type and full text
parse_license_type() {
    local license_file="$1"
    # Extract first line which contains the license type (e.g., "MIT License")
    head -1 "$license_file" | sed 's/ License//'
}

parse_license_text() {
    local license_file="$1"
    # Extract the license text (skip title line, skip blank lines at start)
    tail -n +2 "$license_file" | sed '/^[[:space:]]*$/d' | head -1
}

extract_full_license_text() {
    local license_file="$1"
    # Extract full license text starting from the permission grant line
    sed -n '/Permission is hereby granted/,$p' "$license_file"
}

# Update RPM spec file with license type
update_rpm_license() {
    local spec_file="$1"
    local license_type="$2"
    
    # Replace License: line in RPM spec
    sed -i "s/^License:.*$/License:          $license_type/" "$spec_file"
    echo "✓ Updated License in RPM spec: $license_type"
}

# Update Debian copyright file with license text
update_debian_copyright() {
    local copyright_file="$1"
    local license_type="$2"
    local license_text="$3"
    
    local temp_copyright="$copyright_file.tmp"
    
    # Extract header (everything before "License: MIT" section)
    sed -n '1,/^License: /p' "$copyright_file" | head -n -1 > "$temp_copyright"
    
    {
        echo "License: $license_type"
        echo "$license_text" | while IFS= read -r line; do
            if [[ -z "$line" ]]; then
                echo " ."
            else
                echo " $line"
            fi
        done
    } >> "$temp_copyright"
    
    mv "$temp_copyright" "$copyright_file"
    echo "✓ Updated License text in Debian copyright"
}

# Main execution
if [[ ! -f "$LICENSE_FILE" ]]; then
    echo "Error: LICENSE file not found at $LICENSE_FILE"
    exit 1
fi

# Extract license information
LICENSE_TYPE=$(parse_license_type "$LICENSE_FILE")
LICENSE_TEXT=$(extract_full_license_text "$LICENSE_FILE")

# Update both files
update_rpm_license "$RPM_SPEC" "$LICENSE_TYPE"
update_debian_copyright "$DEBIAN_COPYRIGHT" "$LICENSE_TYPE" "$LICENSE_TEXT"

echo ""
echo "✓ License synchronisation complete"
