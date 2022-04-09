# PDQ Inventory location
$pdqDeployPath = 'C:\Program Files (x86)\Admin Arsenal\PDQ Deploy\PDQDeploy.exe'
$pdqInventoryPath = 'C:\Program Files (x86)\Admin Arsenal\PDQ Inventory\PDQInventory.exe'

# PDQ custom variables to reference
$duoHealthPdqVariable = 'AppVerDuoHealth'
$duoWinLogonPdqVariable = 'AppVerDuoWinLogon'

# Point to file repository of where the files will be checked/downloaded
$softwareRepo = "\\server\PDQ-Deploy\Cisco\Duo"

# Perform file hash check of software repository to be compared later
$softwareRepoChecksum = Get-FileHash "$softwareRepo\*" | Select-Object Hash -ExpandProperty Hash

# One-time scraping from site. Future variables will be built off this data
$content = Invoke-WebRequest 'https://duo.com/docs/checksums'

# Subtracting from the web scrape to grab, as variables, the download URL and checksum
$duoHealth = $content.links | Where-Object {($_.href -like "*DuoDeviceHealth*.msi*") -and ($_.href -notlike "*beta*")}
$duoHealthInnerText = $duoHealth.innerText
$duoHealthChecksum = $duoHealthInnerText.Substring(0,64)
$duoHealthChecksum = $duoHealthChecksum.ToUpper()
$downloadUrlDuoHealth = $duoHealth.href

# Compare file hash of items in software repository to hash from Cisco site. Downloads if an equal value isn't found
If (Compare-Object -ReferenceObject $duoHealthChecksum -DifferenceObject $softwareRepoChecksum -ExcludeDifferent -IncludeEqual) {
    Write-Output "$downloadUrlDuoHealth already exists in $softwareRepo - skipping" 
    } else {
        # Cleaning up string to get, as variables, the filename and version
        $duoHealthFilename = $duoHealthInnerText.substring(66)
        $duoHealthFilename = $duoHealthFilename.Replace("Download","")
        $duoHealthVersion = $duoHealthFilename.Replace("DuoDeviceHealth-","")
        $duoHealthVersion = $duoHealthVersion.Replace(".msi","")
        
        # Download software to respository
        Write-Output "Downloading $downloadUrlDuoHealth to $softwareRepo\$duoHealthFilename"
        Invoke-WebRequest -Uri $downloadUrlDuoHealth -OutFile "$softwareRepo\$duoHealthFilename"
        
        If(Test-Path -Path "$softwareRepo\$duoHealthFilename") {
            Write-Output "$duoHealthFilename downloaded to $softwareRepo"
            Start-Process -NoNewWindow $pdqDeployPath -ArgumentList "UpdateCustomVariable $duoHealthPdqVariable $duoHealthVersion"
            Start-Process -NoNewWindow $pdqInventoryPath -ArgumentList "UpdateCustomVariable $duoHealthPdqVariable $duoHealthVersion"
        } else {
            Write-Output "Unable to download $duoHealthFilename to $softwareRepo"
        }
}

# Subtracting from the web scrape to grab, as variables, the download URL and checksum
$duoWinLogon = $Content.links | Where-Object {($_.href -like "*duo-win-login*") -and ($_.href -notlike "*beta*")}
$duoWinLogonInnerText = $duoWinLogon.innerText
$duoWinLogonChecksum = $duoWinLogonInnerText.Substring(0,64)
$duoWinLogonChecksum = $duoWinLogonChecksum.ToUpper()
$downloadUrlDuoWinLogon = $duoWinLogon.href

# Compare file hash of items in software repository to hash from Cisco site. Downloads if an equal value isn't found
If (Compare-Object -ReferenceObject $duoWinLogonChecksum -DifferenceObject  $softwareRepoChecksum -ExcludeDifferent -IncludeEqual) {
    Write-Output "$downloadUrlDuoWinLogon already exists in $softwareRepo - skipping" } else {
    
        # Cleaning up string to get, as variables, the filename and version
        $duoWinLogonFilename = $duoWinLogonInnerText.substring(66)
        $duoWinLogonFilename = $duoWinLogonFilename.Replace("Download","")
        $duoWinLogonVersion = $duoWinLogonFilename.Replace("duo-win-login-","")
        $duoWinLogonVersion = $duoWinLogonVersion.Replace(".exe","")
        
        # Download software to respository
        Write-Output "Downloading $downloadUrlDuoWinLogon to $softwareRepo\$duoWinLogonFilename"
        Invoke-WebRequest -Uri $downloadUrlDuoWinLogon -OutFile "$softwareRepo\$duoWinLogonFilename"
        If(Test-Path -Path "$softwareRepo\$duoWinLogonFilename") {
            Write-Output "$duoWinLogonFilename downloaded to $softwareRepo"
            Start-Process -NoNewWindow $pdqDeployPath -ArgumentList "UpdateCustomVariable $duoWinLogonPdqVariable $duoWinLogonVersion"
            Start-Process -NoNewWindow $pdqDeployPath -ArgumentList "UpdateCustomVariable $duoWinLogonPdqVariable $duoWinLogonVersion"
        } else {
            Write-Output "Unable to download $duoWinLogonFilename to $softwareRepo"
        }
}
