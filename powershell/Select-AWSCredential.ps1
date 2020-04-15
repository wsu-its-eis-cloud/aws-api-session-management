param(
    [Alias("p")]
    [string] $profileName = "",

    [Alias("n")]
    [switch] $noSet = $false,

    [Alias("h")]
    [switch] $help = $false
)

if ($help) {
    Write-Output ("`t Select a credential from the current users AWS credential store.")
    Write-Output ("`t Prerequisites: Powershell, included setup.ps1")
    Write-Output ("`t ")
    Write-Output ("`t Parameters:")
    Write-Output ("`t ")
    Write-Output ("`t profileName")
    Write-Output ("`t     The name of the profile to select, if known.  If left blank, user will be prompted.")
    Write-Output ("`t     Default: {0}" -f $profileName)
    Write-Output ("`t     Alias: s")
    Write-Output ("`t     Example: .\{0}.ps1 -profileName {1}" -f $MyInvocation.MyCommand.Name, $profileName)
    Write-Output ("`t     Example: .\{0}.ps1 -p {1}" -f $MyInvocation.MyCommand.Name, $profileName)
    Write-Output ("`t ")
    Write-Output ("`t noSet")
    Write-Output ("`t     By default this script will automatically invoke Set-AWSCredential to make the selected profile active for the session. Setting the noSet flag suppresses this, and has the function return an invokable command instead.")
    Write-Output ("`t     Default: {0}" -f $noSet)
    Write-Output ("`t     Alias: n")
    Write-Output ("`t     Example: .\{0}.ps1 -noSet" -f $MyInvocation.MyCommand.Name)
    Write-Output ("`t     Example: .\{0}.ps1 -n" -f $MyInvocation.MyCommand.Name)

    return $false
}

# navigate to library root
cd $PSScriptRoot

# load necessary modules
.\import-required-modules.ps1

#Retrieve stored credentials
$storedCredentials = Get-AWSCredential -ListProfileDetail

# Prompt for name if not specified
if ($profileName -eq "") {
	if($storedCredentials.Count -lt 1) {
		Write-Output "No stored credentials in user credentials file."
		return $false;
	}
	
	$selection = -1;
	do {
		Write-Host ("`t ")
		Write-Host ("`t Available Credentials")
		for ($i=0; $i -lt $storedCredentials.Count; $i++) {
			Write-Host ("`t [{0}] - {1}" -f $i, $storedCredentials[$i].ProfileName)
		}
		
		Write-Host ("`t ")
		$selection = Read-Host "`t Enter a valid selection []"
	}
	while($selection -lt 0 -or $selection -gt $storedCredentials.Count - 1)
	
	$profileName = $storedCredentials[$selection].ProfileName
} else {
	$result = Get-AWSCredential -ListProfileDetail | Where-Object  {$_.ProfileName -eq $profileName}
	
	if(!$result) {
		Write-Output "No stored credentials in user credentials file match passed profile name."
		return $false;
	}
}

# If no set is specified, return the expression the calling scope needs to set the session
if ($noSet) {
    return ("Set-AWSCredential -ProfileName {0}" -f $profileName)
}

Set-AWSCredential -ProfileName $profileName
return $true