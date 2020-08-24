[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string[]] $CopyThese = @(
        'AutoMapper',
        'Microsoft.AspNetCore.Http.Abstractions',
        'Microsoft.Extensions.Logging',
        'Microsoft.Extensions.Options',
        'Polly',
        'System.Text.Json'
    )
)

$assetsJson = "$PSScriptRoot\..\..\..\obj\project.assets.json"
$json = Get-Content -Path $assetsJson -Raw | ConvertFrom-Json -Depth 100
$packageRoot = $json.project.restore.packagesPath

Function Get-PackagePath() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Management.Automation.PSPropertyInfo] $InputObject,

        [Parameter(Mandatory=$false, Position = 1)]
        [string] $NugetFolder = $packageRoot
    )
    Process {
        $relativePath = $InputObject.Value.compile.psobject.Properties.Match("lib/*").Name
        Join-Path -Path $NugetFolder -ChildPath $InputObject.Name -AdditionalChildPath $relativePath
    }
}

$targets = $json.targets.psobject.Properties.Match(".NETCoreApp*").Value
foreach ($nuget in $CopyThese) {
    if (-not (Test-Path -Path "$PSScriptRoot\$nuget.dll")) {
        $path = $targets.psobject.Properties.Match("$nuget*") | Get-PackagePath
        Copy-Item -Path $path -Destination "$PSScriptRoot"
    }
}

Import-Module "$PSScriptRoot\Microsoft.Extensions.Logging.dll"
Import-Module "$PSScriptRoot\Plex.Api.dll" -ea 1


$httpClient = New-Object 'Plex.Api.Api.PlexRequestsHttpClient'
$loggerFac = New-Object 'Microsoft.Extensions.Logging.LoggerFactory'
$logger = New-Object 'Microsoft.Extensions.Logging.Logger[Plex.Api.Api.ApiService]'($loggerFac)
$apiService = New-Object 'Plex.Api.Api.ApiService'($httpClient, $logger)
$cliOpts = New-Object 'Plex.Api.ClientOptions' -Property @{
    Product = 'API_Testing'
    DeviceName = 'API_Testing'
    ClientId = "MyClientId"
    Platform = "Web"
    Version = "V1"
}
$client = New-Object 'Plex.Api.PlexClient'($cliOpts, $apiService)