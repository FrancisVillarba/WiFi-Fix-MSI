Name: wifi-fixes-msi
Version: 1.0
Release: 1
Summary: systemd script that fixes sleep wake issues for Intel BE1750 Class WiFi cards
License: MIT
Distribution: user
Group: user
Packager: user

%description
A simple package that contains a systemd script that runs before sleep and after wake in order to fix issues with iwlwifi driver crash looping when resuming from sleep on Intel BE1750 Class WiFi Cards.

This was created and tested specificlaly with the MSI Stealth 16 AI A1VGG Notebook.

%prep
# We only have a single file, so nothing here

%files
/usr/lib/systemd/system-sleep/iwlwifi

%changelog

* Mon Mar 10 2025 Francis Villarba <hello@francisvillarba.com> 1.0-1

- Initial Release
