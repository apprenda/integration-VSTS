param(
    [Parameter(Mandatory = $true)]
    [string]
    $SolutionPath,
    [Parameter(Mandatory = $true)]
    [string]
    $OutputPath,
    [Parameter(Mandatory = $false)]
    [bool]
    $Build = $false,
    [Parameter(Mandatory = $false)]
    [string]
    $Configuration = "Release",
    [Parameter(Mandatory = $false)]
    [string]
    $PrivateUI,
    [Parameter(Mandatory = $false)]
    [string]
    $PublicUI,
    [Parameter(Mandatory = $false)]
    [string]
    $PrivateRoot,
    [Parameter(Mandatory = $false)]
    [string]
    $PublicRoot,
    [Parameter(Mandatory = $false)]
    [string]
    $WcfService,
    [Parameter(Mandatory = $false)]
    [string]
    $WindowsService
)

$PrivateUIs = $PrivateUI -split ","
$PublicUIs = $PublicUI -split ","
$WcfServices = $WcfService -split ","
$WindowsServices = $WindowsService -split ","

$cmd = @"
& "$PSScriptRoot\..\Apprenda\acs.exe" NewPackage -Sln "$SolutionPath" -O "$OutputPath" -Config "$Configuration"
"@

if($Build)
{
    $cmd += " -b"
}

if($PrivateUIs.Length -gt 0)
{
    
    $cmd += " -I $([System.String]::Join(",", $PrivateUIs))"
}

if($PublicUIs.Length -gt 0)
{
    $cmd += " -Pi $([System.String]::Join(",", $PublicUIs))"
}

if(-not [System.String]::IsNullOrEmpty($PrivateRoot))
{
    $cmd += @"
 -PrivateRoot "$PrivateRoot"
"@
}

if(-not [System.String]::IsNullOrEmpty($PublicRoot))
{
    $cmd += @"
 -PublicRoot "$PublicRoot"
"@
}

if($WcfServices.Length -gt 0)
{
    $cmd += " -S $([System.String]::Join(",", $WcfServices))"
}

if($WindowsServices.Length -gt 0)
{
    $cmd += " -WS $([System.String]::Join(",", $WindowsServices))"
}

iex $cmd