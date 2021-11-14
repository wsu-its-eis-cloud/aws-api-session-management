# Check for necessary module
if (Get-Module -ListAvailable -Name AWS.Tools.Common) {
    Import-Module AWS.Tools.Common
} 
else {
    Write-Host "Module Import-Module AWS.Tools.Common has not been installed.  Please run this libraries setup script."
    return;
}

if (Get-Module -ListAvailable -Name AWS.Tools.SecurityToken) {
    Import-Module AWS.Tools.SecurityToken
} 
else {
    Write-Host "Module Import-Module AWS.Tools.SecurityToken has not been installed.  Please run this libraries setup script."
    return;
}