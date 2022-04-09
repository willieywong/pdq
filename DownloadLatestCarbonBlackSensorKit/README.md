# DownloadLatestCarbonBlackSensorKit

DownloadLatestCarbonBlackSensorKit is a PowerShell script, PDQ Deploy package, and PDQ Inventory collection for checking and downloading the latest version of 'Carbon Black Sensor Kit' into your repository, which can then be automatically deployed to computers that have outdated versions. As of this writing, Carbon Black is not serviced in the PDQ Deploy catalog, so this Github repo will serve to automate the entire update process for this product.

## How it works

The PowerShell script works by scraping information from https://docs.vmware.com/en/VMware-Carbon-Black-Cloud/rn_rss.xml, which is an RSS feed for news related to Carbon Black. It then looks for the first headline that mentions release notes for Carbon Black and grabs the version number.

A comparison is then made against the files in your PDQ repository. If there is a file that contains the version number, it is assumed that the repository already has the latest version, and the script stops.

But if there isn't a match, the script will download the file into your PDQ repository (this part requires setting up an API key).

The script will also update custom variables in PDQ Deploy and PDQ Inventory to match the version that was downloaded.

When the script is placed into its own PDQ Deploy package, it can be run on a PDQ Deploy schedule of your choosing. This will fulfill the auto-updating aspect that's similar to what's offered in the package library.

Because the script also updates custom variables for the products, it is possible for PDQ Inventory to identify computers that either don't have the software or have the softawre but outdated. This collection can then be targeted into a PDQ Deploy schedule that will deploy the latest software.

When used altogether, you will have the latest version of 'Carbon Black Sensor Kit' in your repository and as well as having the latest verions installed on your clients, effortlessly.

## Prerequisites

1. Client running PDQ Deploy, PDQ Inventory, and at least PowerShell 5
2. Account with permissions to download files into the PDQ repository
3. Create custom variables @(AppVerCarbonBlackSensorKit) in both PDQ Deploy and PDQ Inventory
4. Update your existing PDQ Deploy packages for 'Carbon Black Sensor Kit' to use the custom variables in the install path

## Limitations

The automation is highly dependent on the formatting in Carbon Black's RSS page to stay consistent. It assumes that the first mentioning of 'VMware Carbon Black Cloud Windows Sensor x.x.x.xxx' is the latest version.
