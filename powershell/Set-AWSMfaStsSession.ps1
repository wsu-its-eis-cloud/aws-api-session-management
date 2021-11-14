param(	
	[Alias("s")]
    [string] $sessionName = "awsDefaultSession",
	
	[Alias("i")]
    [string] $accessKeyId = "",
	
	[Alias("k")]
    [string] $secretAccessKey = "",
	
	[Alias("t")]
    [string] $sessionToken = "",

    [Alias("f")]
    [switch] $force = $false,
	
    [Alias("h")]
    [switch] $help = $false
)

if ($help) {
    Write-Output ("`t Select a credential from the current users AWS credential store.")
    Write-Output ("`t Prerequisites: Powershell, included setup.ps1")
    Write-Output ("`t ")
    Write-Output ("`t Parameters:")
    Write-Output ("`t ")
    Write-Output ("`t sessionName")
    Write-Output ("`t     The name of the session for storage in the global variable set.")
    Write-Output ("`t     Default: {0}" -f $sessionName)
    Write-Output ("`t     Alias: s")
    Write-Output ("`t     Example: .\{0}.ps1 -sessionName {1}" -f $MyInvocation.MyCommand.Name, $sessionName)
    Write-Output ("`t     Example: .\{0}.ps1 -s {1}" -f $MyInvocation.MyCommand.Name, $sessionName)
    Write-Output ("`t ")
    Write-Output ("`t accessKeyId")
    Write-Output ("`t     The access key id of the authenticated session.")
    Write-Output ("`t     Default: {0}" -f $accessKeyId)
    Write-Output ("`t     Alias: s")
    Write-Output ("`t     Example: .\{0}.ps1 -accessKeyId {1}" -f $MyInvocation.MyCommand.Name, $accessKeyId)
    Write-Output ("`t     Example: .\{0}.ps1 -i {1}" -f $MyInvocation.MyCommand.Name, $accessKeyId)
    Write-Output ("`t ")
    Write-Output ("`t secretAccessKey")
    Write-Output ("`t     The secret access key of the authenticated session.")
    Write-Output ("`t     Default: {0}" -f $secretAccessKey)
    Write-Output ("`t     Alias: s")
    Write-Output ("`t     Example: .\{0}.ps1 -secretAccessKey {1}" -f $MyInvocation.MyCommand.Name, $secretAccessKey)
    Write-Output ("`t     Example: .\{0}.ps1 -k {1}" -f $MyInvocation.MyCommand.Name, $secretAccessKey)
    Write-Output ("`t ")
    Write-Output ("`t sessionToken")
    Write-Output ("`t     The session token of the authenticated session.")
    Write-Output ("`t     Default: {0}" -f $sessionToken)
    Write-Output ("`t     Alias: s")
    Write-Output ("`t     Example: .\{0}.ps1 -sessionToken {1}" -f $MyInvocation.MyCommand.Name, $sessionToken)
    Write-Output ("`t     Example: .\{0}.ps1 -t {1}" -f $MyInvocation.MyCommand.Name, $sessionToken)
    Write-Output ("`t ")
    Write-Output ("`t outputHelper")
    Write-Output ("`t     Switch to output the command to run to build the default local session.")
    Write-Output ("`t     Default: {0}" -f $outputHelper)
    Write-Output ("`t     Alias: o")
    Write-Output ("`t     Example: .\{0}.ps1 -outputHelper {1}" -f $MyInvocation.MyCommand.Name, $outputHelper)
    Write-Output ("`t     Example: .\{0}.ps1 -o {1}" -f $MyInvocation.MyCommand.Name, $outputHelper)

    return $false
}

# navigate to library root
cd $PSScriptRoot

# load necessary modules
.\import-required-modules.ps1

if ($sessionName -eq "") {
	$sessionName = Read-Host "Enter the session name, e.g., awsDefaultSession"
}

if ($accessKeyId -eq "") {
	$accessKeyId = Read-Host "Enter the access key"
}

if ($secretAccessKey -eq "") {
	$secretAccessKey = Read-Host "Enter the secret access key"
}

if ($sessionToken -eq "") {
	$sessionToken = Read-Host "Enter the session token"
}

$session = @{
	'AccessKeyId'    	= $accessKeyId;
    'SecretAccessKey'   = $secretAccessKey;
    'SessionToken' 		= $sessionToken;
}

$expression = ("`$global:{0} = `$session" -f $sessionName)
Invoke-Expression -Command $expression

return $true