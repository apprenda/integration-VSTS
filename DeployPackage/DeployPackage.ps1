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
    [string]$ApplicationName,
    [string]$ApplicationAlias,  
    [string]$VersionAlias,
	[string]$VersionName,
	[string]$ArchivePath,
	[string]$Username,
	[string]$Password,
	[string]$CloudUrl,
	[string]$newVersionStage = "Published"
	[string]$additionalParams
)

##############################################################
# F U N C T I O N S
##############################################################
function ApplicationExists($Alias)
{    
	Write-Host "Checking application exists..."
	$Response = .\Apprenda\acs.exe GetStatistics -appAlias "$Alias"

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

function CreateApplication($ApplicationAlias, $ApplicationName, $ArchivePath, $stage)
{
    Write-Host "Creating Application..."
    Write-Host "Application Alias: $ApplicationAlias" 
    Write-Host "Application Name: $ApplicationName"
    Write-Host "Archive Location: $ArchivePath"

	.\Apprenda\acs.exe NewApplication -appAlias "$ApplicationAlias" -appName "$ApplicationName" -stage "$stage" -package "$ArchivePath"

    Write-Host "Application created"
}

function VersionApplication($ApplicationAlias, $VersionAlias, $VersionName, $ArchivePath, $stage)
{
    Write-Host "Creating new version..."
	.\Apprenda\acs.exe NewVersion -appAlias "$ApplicationAlias" -versionAlias "$VersionAlias" -versionName "$VersionName" -stage "$stage" -Package "$ArchivePath"

    Write-Host "New version created"
}


##############################################################
# M A I N
##############################################################


Write-Host "Registering Cloud [$CloudUrl]..."
.\Apprenda\acs.exe RegisterCloud -url "$CloudUrl" -alias "environment"

Write-Host "Connecting to Cloud [$CloudUrl]..."
.\Apprenda\acs.exe ConnectCloud -CloudAlias "environment" -user "$Username" -password "$Password"

if (ApplicationExists($ApplicationAlias))
{
    VersionApplication $ApplicationAlias $VersionAlias $VersionName $ArchivePath $newVersionStage
}
else
{
    CreateApplication $ApplicationAlias $ApplicationName $ArchivePath $newVersionStage
}

Write-Host "Disconnecting from Cloud..."
.\Apprenda\acs.exe DisconnectCloud -y

