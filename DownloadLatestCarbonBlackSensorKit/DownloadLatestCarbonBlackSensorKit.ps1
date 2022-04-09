# Path to PDQ executables
$PdqInventoryPath = 'C:\Program Files (x86)\Admin Arsenal\PDQ Inventory\PDQInventory.exe'
$PdqDeployPath = 'C:\Program Files (x86)\Admin Arsenal\PDQ Deploy\PDQDeploy.exe'

# PDQ variables to update
$PdqInventoryVariable = 'AppVerCarbonBlackSensorKit'
$PdqDeployVariable = 'AppVerCarbonBlackSensorKit'

# Point to file repositories of where the files will be checked/downloaded
$softwareRepo = "\\<SERVER>\PDQ-Deploy\Carbon Black\Sensor Kit\Windows"

# One-time pull request from site. Future variables will be built off this data
$content = Invoke-WebRequest -Uri "https://docs.vmware.com/en/VMware-Carbon-Black-Cloud/rn_rss.xml" -UseBasicParsing

# Grab first mention of Carbon Black Windows sensor from RSS feed, then subtract string to version number
$CBVersion = $content.Content
$CBVersion = $CBVersion.Substring($CBVersion.IndexOf('VMware Carbon Black Cloud Windows Sensor'))
$CBVersion = $CBVersion.Substring(0,$CBVersion.IndexOf(' Release Notes'))
$CBVersion = $CBVersion.Replace("VMware Carbon Black Cloud Windows Sensor ","")

# Create filenames with current version
$CBFilenamex64 = "installer_vista_win7_win8-64-$CBVersion.msi"
$CBFilenamex86 = "installer_vista_win7_win8-32-$CBVersion.msi"

# Variables needed to download from Carbon Black with API call
$api_key = "<api_key>"
$api_id = "<api_id>"
$org_id = "<org_id>"
$headers = @{"X-Auth-Token" = "$api_key/$api_id" }

If(!(Test-Path -Path "$softwareRepox64\$CBFilenamex64")) {
    Invoke-WebRequest -Uri "https://defense-prod05.conferdeploy.net/appservices/v5/orgs/$org_id/kits/$CBFilenamex64" -headers $headers -OutFile "$softwareRepo\x64\$CBFilenamex64"
    Copy-Item -Path "$softwareRepo\x64\$CBFilenamex64" -Destination "$softwareRepo\x64\$CBFilenamex64Latest" # Used for group policy deployment
    Start-Process -NoNewWindow $PdqInventoryPath -ArgumentList "UpdateCustomVariable $PdqInventoryVariable $CBVersion"
    Start-Process -NoNewWindow $PdqDeployPath -ArgumentList "UpdateCustomVariable $PdqDeployVariable $CBVersion" 
}

If(!(Test-Path -Path "$softwareRepox86\$CBFilenamex86")) {
    Invoke-WebRequest -Uri "https://defense-prod05.conferdeploy.net/appservices/v5/orgs/$org_id/kits/$CBFilenamex86" -headers $headers -OutFile "$softwareRepo\x86\$CBFilenamex86"
    Copy-Item -Path "$softwareRepo\x86\$CBFilenamex86" -Destination "$softwareRepo\x86\$CBFilenamex86Latest" # Used for group policy deployment
    Start-Process -NoNewWindow $PdqInventoryPath -ArgumentList "UpdateCustomVariable $PdqInventoryVariable $CBVersion"
    Start-Process -NoNewWindow $PdqDeployPath -ArgumentList "UpdateCustomVariable $PdqDeployVariable $CBVersion" 
}
