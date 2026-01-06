# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1-1] - 2026-01-06

### Added

- Added Debian/Ubuntu packaging support
- Created debian/* packaging files (control, rules, changelog, copyright)
- Added changelog generation script for synchronisation

### Changed

- Reorganised project structure with rpm/ and debian/ directories
- Renamed build scripts for clarity (build-rpm.sh, init-rpm.sh)

## [2.0-1] - 2025-09-25

### Added

- WiFi configuration settings via modprobe.d for stability and
  performance, at the cost of battery life.
  - iwlwifi.conf: Disables power saving, enables firmware restart, enables 11ac/11ax/11be.
  - iwlmld.conf: Sets power scheme to performance mode.
- tools/init.sh script to initialize development environment with distrobox.
- tools/build.sh script for automated RPM building using distrobox.

### Changed

- All references to iwlmvm changed to iwlmld to match Kernel 6.6+ driver changes
  - [More Info](https://www.kernelconfig.io/config_iwlmld)
- Repository structure: BUILDROOT reorganised from versioned subdirectories to a
flat structure.
- RPM spec file updated to copy files from simplified BUILDROOT structure and
refactored to be more reliable and repeatable.
- Build process streamlined with automated tools/build.sh script.
- Package version incremented to 2.0 to reflect breaking changes.

## [1.0-2] - 2025-09-25

### Added

- CHANGELOG.md for a more human friendly history of changes.
- VSCode specific extension recommendations and settings.
- .markdownlint.json to ensure we match the "Keep a changelog" schema.

### Changed

- README.md formatting to be in-line with conventions & specifications for markdown.
- SOURCES.md for the same reasons as above, in addition to adding
additional sources of information for the rest of the changes.
- Various spelling mistakes fixed.

## [1.0-1] - 2025-03-10

### Added

- Initial Release.

[2.0-1]: https://github.com/FrancisVillarba/wifi-fix-msi/releases/tag/v2.0-1
[1.0-2]: https://github.com/FrancisVillarba/wifi-fix-msi/releases/tag/v1.0-2
[1.0-1]: https://github.com/FrancisVillarba/wifi-fix-msi/releases/tag/v1.0-1
