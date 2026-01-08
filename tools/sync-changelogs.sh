#!/bin/bash
# sync-changelogs.sh ##########################################################
# Generates debian/changelog and rpm/%changelog from CHANGELOG.md
# Ensures all changelogs stay synchronised
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CHANGELOG_MD="$PROJECT_DIR/CHANGELOG.md"
DEBIAN_CHANGELOG="$PROJECT_DIR/debian/changelog"
RPM_SPEC="$PROJECT_DIR/rpm/wifi-fixes-msi.spec"

echo "Setting Directory to $PROJECT_DIR"
echo " "

echo "Generating changelogs from CHANGELOG.md..."

# Parse CHANGELOG.md and generate debian/changelog
parse_and_generate_debian_changelog() {
    local input_file="$1"
    local output_file="$2"
    local temp_file="$output_file.tmp"
    
    > "$temp_file"
    
    # Track state
    local in_version_section=false
    local current_version=""
    local current_date=""
    local current_changes=()
    
    while IFS= read -r line; do
        # Match version header: ## [2.1-1] - 2026-01-05
        if [[ $line =~ ^##\ \[([^\]]+)\]\ -\ ([^ ]+) ]]; then
            # If we have a previous version, write it out
            if [[ -n "$current_version" ]]; then
                write_debian_entry "$temp_file" "$current_version" "$current_date" "${current_changes[@]}"
            fi
            
            current_version="${BASH_REMATCH[1]}"
            current_date="${BASH_REMATCH[2]}"
            current_changes=()
            in_version_section=true
            continue
        fi
        
        # Match section headers (Added, Changed, etc.)
        if [[ $line =~ ^###\ (Added|Changed|Removed|Deprecated|Fixed|Security) ]]; then
            in_version_section=true
            continue
        fi
        
        # Match bullet points under sections
        if [[ $in_version_section && $line =~ ^-\ (.+)$ ]]; then
            current_changes+=("${BASH_REMATCH[1]}")
            continue
        fi
        
        # Empty line or end of file handling
        if [[ -z "$line" ]]; then
            continue
        fi
    done < "$input_file"
    
    # Write the last version
    if [[ -n "$current_version" ]]; then
        write_debian_entry "$temp_file" "$current_version" "$current_date" "${current_changes[@]}"
    fi
    
    mv "$temp_file" "$output_file"
    echo "✓ Generated $output_file"
}

# Helper function to write a single Debian changelog entry
write_debian_entry() {
    local output_file="$1"
    local version="$2"
    local date="$3"
    shift 3
    local -a changes=("$@")
    
    # Convert date from YYYY-MM-DD to RFC 5322 format
    local rfc_date=$(date -d "$date" -R 2>/dev/null || echo "Thu, 01 Jan 1970 12:00:00 +0000")
    
    {
        echo "wifi-fixes-msi ($version) UNRELEASED; urgency=low"
        echo ""
        
        # Write each change with proper indentation (2 spaces + bullet)
        for change in "${changes[@]}"; do
            echo "  * $change"
        done
        
        echo ""
        echo " -- Francis Villarba <hello@francisvillarba.com>  $rfc_date"
        echo ""
    } >> "$output_file"
}

parse_and_generate_debian_changelog "$CHANGELOG_MD" "$DEBIAN_CHANGELOG"

# Parse CHANGELOG.md and generate rpm/%changelog
parse_and_generate_rpm_changelog() {
    local input_file="$1"
    local spec_file="$2"
    local temp_spec="$spec_file.tmp"
    
    # Read the spec file and split at %changelog
    sed -n '1,/%changelog/p' "$spec_file" > "$temp_spec"
    
    # Track state for parsing CHANGELOG.md
    local current_version=""
    local current_date=""
    local current_changes=()
    
    while IFS= read -r line; do
        # Match version header: ## [2.1-1] - 2026-01-05
        if [[ $line =~ ^##\ \[([^\]]+)\]\ -\ ([^ ]+) ]]; then
            # If we have a previous version, write it out
            if [[ -n "$current_version" ]]; then
                write_rpm_entry "$temp_spec" "$current_version" "$current_date" "${current_changes[@]}"
            fi
            
            current_version="${BASH_REMATCH[1]}"
            current_date="${BASH_REMATCH[2]}"
            current_changes=()
            continue
        fi
        
        # Match section headers (Added, Changed, etc.)
        if [[ $line =~ ^###\ (Added|Changed|Removed|Deprecated|Fixed|Security) ]]; then
            continue
        fi
        
        # Match bullet points under sections
        if [[ $line =~ ^-\ (.+)$ ]]; then
            current_changes+=("${BASH_REMATCH[1]}")
            continue
        fi
        
    done < "$input_file"
    
    # Write the last version
    if [[ -n "$current_version" ]]; then
        write_rpm_entry "$temp_spec" "$current_version" "$current_date" "${current_changes[@]}"
    fi
    
    mv "$temp_spec" "$spec_file"
    echo "✓ Generated rpm/%changelog in $spec_file"
}

# Helper function to write a single RPM changelog entry
write_rpm_entry() {
    local spec_file="$1"
    local version="$2"
    local date="$3"
    shift 3
    local -a changes=("$@")
    
    # Convert date from YYYY-MM-DD to RPM format (Day Mon DD YYYY)
    local rpm_date=$(date -d "$date" '+%a %b %d %Y')
    
    # Extract version and release (e.g., "2.1-1" -> "2.1" and "1")
    local ver_only="${version%-*}"
    local rel_only="${version##*-}"
    
    {
        echo ""
        echo "* $rpm_date Francis Villarba <hello@francisvillarba.com> $version"
        echo ""
        
        # Write each change with proper RPM format (- bullet)
        for change in "${changes[@]}"; do
            echo "- $change"
        done
    } >> "$spec_file"
}

parse_and_generate_rpm_changelog "$CHANGELOG_MD" "$RPM_SPEC"

echo ""
