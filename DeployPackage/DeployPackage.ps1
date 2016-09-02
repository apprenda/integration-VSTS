#ACS_Application_Deployment
# 
# Description:
#   This script is intended to help deploy applications as part of an automated build & deploy process.
# It will deploy a new app or version it and push the new version to published
# 
#
# Note:
#   Before running this script you will want to make sure acs is in your $env:Path and that your cloud is registered

param (
    [string]$appName= $(throw 'Usage: ACS_Application_Deployment.ps1 appName appAlias verAlias archive username password envUrl'),
    [string]$appAlias= $(throw 'Usage: ACS_Application_Deployment.ps1 appName appAlias verAlias archive username password envUrl'),  
    [string]$verAlias= $(throw 'Usage: ACS_Application_Deployment.ps1 appName appAlias verAlias archive username password envUrl'),  
	[string]$archive= $(throw 'Usage: ACS_Application_Deployment.ps1 appName appAlias verAlias archive username password envUrl'),
	[string]$username= $(throw 'Usage: ACS_Application_Deployment.ps1 appName appAlias verAlias archive username password envUrl'),
	[string]$password= $(throw 'Usage: ACS_Application_Deployment.ps1 appName appAlias verAlias archive username password envUrl'),
	[string]$envUrl = $(throw 'Usage: ACS_Application_Deployment.ps1 appName appAlias verAlias archive username password envUrl')
)

##############################################################
# F U N C T I O N S
##############################################################
function ApplicationExists($alias)
{    
    
    $acsResponse = acs GetStatistics -aa $alias
    if ($?) 
    {
        Write-Host "Application found"
        return 1
    }
    else
    {
        Write-Host "Application not found"
        return 0
    }
}

function CreateApplication($appAlias, $verAlias, $appName, $archive)
{
    Write-Host "Creating Application..."
    Write-Host "appAlias: $appAlias" 
    Write-Host "verAlias: $verAlias"
    Write-Host "appName: $appName"
    Write-Host "archive: $archive"

    acs NewApplication -aa $appAlias -an $appName -s Published -pkg $archive
    
    Write-Host "Application created"
}

function VersionApplication($appAlias, $verAlias, $archive)
{
    Write-Host "Creating new version..."
    acs NewVersion -aa $appAlias -va $verAlias -s Published -Package $archive
    Write-Host "New version created"
}


##############################################################
# M A I N
##############################################################


acs RegisterCloud -url $envUrl -alias environment
acs ConnectCloud -CloudAlias environment -user $username -password $password 

if (ApplicationExists($appAlias))
{
    VersionApplication $appAlias $verAlias $archive
}
else
{
    CreateApplication $appAlias $verAlias $appName $archive
}

acs DisconnectCloud -y
