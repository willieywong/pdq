# DownloadLatestCiscoDuo

DownloadLatestCiscoDuo is a PowerShell script, PDQ Deploy package, and PDQ Inventory collection for checking and downloading the latest version of 'Cisco Duo Health' and 'Cisco Duo Authentication Logon for Windows' into your repository, which can then be automatically deployed to computers that have outdated versions. As of this writing, Duo software is not serviced in the PDQ Deploy catalog, so this Github repo will serve to automate the entire update process for these products.

## How it works

The PowerShell script works by scraping information from https:/duo.com/docs/checksums. It then isolates certain information, namely the download links for 'Cisco Duo Health' and 'Cisco Duo Authentication Logon for Windows', the filenames of the latest versions, and the MD5 checksums next to them.

The checksums are then compared to the checksums of your files in your PDQ repository. If there is a match, that means you already have the same version hosted on the site, and the script stops.

But if there isn't a checksum match on either product, the script will download that installation file into your PDQ repository. 

The script will also update custom variables in PDQ Deploy and PDQ Inventory to match the version that was downloaded.

This script is then placed into a PDQ Deploy package, which can then be run on a PDQ Deploy schedule. This fulfills the auto-updating aspect that's similar to what's offered in the package library.

With the provided PDQ Inventory collection, you can identify computers that either don't have the software or have the softawre but it's outdated. This collection can then be targeted into a PDQ Deploy schedule that deploys the latest software.

When used altogether, you will have the latest version of 'Cisco Duo Health' and 'Cisco Duo Authentication Logon for Windows' in your repository and as well as having the latest verions installed on your clients, effortlessly.

## Prerequisites

1. Client running at least PowerShell 5
2. Account with permissions to download files into the PDQ repository
3. Create custom variables @(AppVerCiscoDuoHealth) and @(AppVerCiscoDuoWinLogon) in both PDQ Deploy and PDQ Inventory (ping me if you figure out how to do this in cmd)
4. Update your existing PDQ Deploy packages for 'Cisco Duo Health' and 'Cisco Duo Authentication Logon for Windows' to use the custom variables in the install path

## Limitations

The automation is highly dependent on the formatting in Duo's checksum page to stay consistent, which should be a given.
