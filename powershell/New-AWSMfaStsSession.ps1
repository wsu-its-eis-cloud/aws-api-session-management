param(
    [Alias("p")]
    [string] $profileName = "",
	
	[Alias("s")]
    [string] $sessionName = "awsDefaultSession",
	
	[Alias("d")]
    [int] $duration = 14400,

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
    Write-Output ("`t sessionName")
    Write-Output ("`t     The name of the global variable to store the MFA validated AWS session.")
    Write-Output ("`t     Default: {0}" -f $sessionName)
    Write-Output ("`t     Alias: s")
    Write-Output ("`t     Example: .\{0}.ps1 -sessionName {1}" -f $MyInvocation.MyCommand.Name, $sessionName)
    Write-Output ("`t     Example: .\{0}.ps1 -s {1}" -f $MyInvocation.MyCommand.Name, $sessionName)

    return $false
}

# navigate to library root
cd $PSScriptRoot

# load necessary modules
.\import-required-modules.ps1

# Select a credential from the user credential store
$result = .\Select-AWSCredential.ps1 -profileName $profileName -noSet
Invoke-Expression -Command $result

# Prompt for ARN and OTP
$serial = Read-Host "`t Enter MFA ARN"
$otp = Read-Host "`t Enter OTP"

# Generate the session
$session = Get-STSSessionToken -SerialNumber $serial -DurationInSeconds $duration -TokenCode $otp

# Build and execute an expression to store the session into the specified global variable
$expression = ("`$global:{0} = `$session" -f $sessionName)
Invoke-Expression -Command $expression

#True for success
return $true