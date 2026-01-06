Name:             wifi-fixes-msi
Version:          2.1
Release:          1
Summary:          systemd script that fixes sleep wake issues for Intel BE1750 Class WiFi cards

License:          MIT
Distribution:     user
Group:            user
Packager:         user

BuildRequires:    bash
Requires:         bash

BuildArch:        noarch

%description
A simple package that contains a systemd script that runs before sleep and after wake in order to fix issues with iwlwifi driver crash looping when resuming from sleep on Intel BE1750 Class WiFi Cards.

Also contains changes to configuration for better performance and reliability, at the cost of battery life.

This was created and tested specifically with the MSI Stealth 16 AI A1VGG Notebook on Bazzite 42+

%prep
# Nothing to prep for!

%install
rm -rf $RPM_BUILD_ROOT

# Create necessary directories in buildroot
mkdir -p %{buildroot}/usr/lib/systemd/system-sleep
mkdir -p %{buildroot}/etc/modprobe.d

# Copy files from BUILDROOT to the package buildroot
cp %{_sourcedir}/BUILDROOT/usr/lib/systemd/system-sleep/iwlwifi %{buildroot}/usr/lib/systemd/system-sleep/
cp %{_sourcedir}/BUILDROOT/etc/modprobe.d/iwlwifi.conf %{buildroot}/etc/modprobe.d/
cp %{_sourcedir}/BUILDROOT/etc/modprobe.d/iwlmld.conf %{buildroot}/etc/modprobe.d/

# Copy LICENSE file for packaging
cp %{_sourcedir}/LICENSE .

# Set proper permissions
chmod 755 %{buildroot}/usr/lib/systemd/system-sleep/iwlwifi
chmod 644 %{buildroot}/etc/modprobe.d/iwlwifi.conf
chmod 644 %{buildroot}/etc/modprobe.d/iwlmld.conf

%files
%license LICENSE
/usr/lib/systemd/system-sleep/iwlwifi
/etc/modprobe.d/iwlmld.conf
/etc/modprobe.d/iwlwifi.conf

%changelog

* Tue Jan 06 2026 Francis Villarba <hello@francisvillarba.com> 2.1-1

- Added Debian/Ubuntu packaging support
- Created debian/* packaging files (control, rules, changelog, copyright)
- Added changelog generation script for synchronisation
- Reorganised project structure with rpm/ and debian/ directories
- Renamed build scripts for clarity (build-rpm.sh, init-rpm.sh)

* Thu Sep 25 2025 Francis Villarba <hello@francisvillarba.com> 2.0-1

- Migration to iwlmld as per Kernel 6.6+ (and bazzite 42+)
- Set modprobe configurations for Wi-Fi
- Overhauled the entire build spec for RPMBuild

* Thu Sep 25 2025 Francis Villarba <hello@francisvillarba.com> 1.0-2

- Repository maintenance release only, no changes to the package otherwise.

* Mon Mar 10 2025 Francis Villarba <hello@francisvillarba.com> 1.0-1

- Initial Release
