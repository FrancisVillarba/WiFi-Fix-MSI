#!/bin/bash
# sync-all.sh #################################################################
# Master synchronisation script that runs all sync scripts in correct order
# Ensures all distribution-specific files stay synchronise with source files
#
# Author: Francis Villarba <hello@francisvillarba.com>
###############################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "  WiFi-Fix-MSI: Sync All"
echo "=========================================="
echo ""

# Run sync scripts in order
echo "Step 1/3: Synchronising versions..."
bash "$SCRIPT_DIR/sync-versions.sh"
echo ""

echo "Step 2/3: Synchronising licenses..."
bash "$SCRIPT_DIR/sync-licenses.sh"
echo ""

echo "Step 3/3: Synchronising changelogs..."
bash "$SCRIPT_DIR/sync-changelogs.sh"
echo ""

echo "=========================================="
echo "✓ All synchronisation complete!"
echo "=========================================="
