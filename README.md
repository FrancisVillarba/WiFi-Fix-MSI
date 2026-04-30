# WiFi-Fix-MSI

## Summary

systemd script that fixes sleep wake issues for Intel BE1750 Class WiFi cards

## Description

A simple package that contains a systemd script that runs before sleep and after wake in order to fix issues with iwlwifi driver crash looping when resuming from sleep on Intel BE1750 Class WiFi Cards.

This was created and tested specifically with the MSI Stealth 16 AI A1VGG Notebook.

## Environment Information
For details about the system this was built and tested for.

Notebook: MSI Stealth 16 AI
Notebook Model:  A1VGG
OS Image: bazzite-nvidia-open:stable
OS Release: Bazzite 41
OS Base: Fedora Kinoite (Fedora Silverblue)
Wireless: Intel WiFi 7 BE1750 (802.11be) | 0000:2c:00.0
