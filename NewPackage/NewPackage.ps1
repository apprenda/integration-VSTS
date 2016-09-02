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

$cmd = @"
& "$PSScriptRoot\..\Apprenda\acs.exe" NewPackage -Sln "$SolutionPath" -O "$OutputPath" -Config "$Configuration"
"@

if($Build)
{
    $cmd += " -b"
}

if(-not [System.String]::IsNullOrEmpty($PrivateUI))
{
    
    $cmd += " -I $PrivateUI"
}

if(-not [System.String]::IsNullOrEmpty($PublicUI))
{
    $cmd += " -Pi $PublicUI"
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

if(-not [System.String]::IsNullOrEmpty($WcfService))
{
    $cmd += " -S $WcfService"
}

if(-not [System.String]::IsNullOrEmpty($WindowsService))
{
    $cmd += " -WS $WindowsService"
}


iex $cmd