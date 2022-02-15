# DownloadLatestCiscoDuo

DownloadLatestCiscoDuo is a PowerShell script, PDQ Deploy package, and PDQ Inventory collection for checking and downloading the latest version of 'Cisco Duo Health' and 'Cisco Duo Authentication Logon for Windows'. As of this writing, Duo software is not serviced in the PDQ Deploy catalog, so this repo will serve to automate the entire update process for this software. By using the PowerShell script + package + collection, you gain the following benefits:

1. Using PowerShell, perform routine checks of the Cisco Duo downloads page for new versions, then download if a newer version is detected
2. After downloading a newer version, automatically update custom variables for PDQ Deploy and PDQ Inventory
3. Packages and collections will use the custom variables, essentially keeping the packages and collections always up-to-date
