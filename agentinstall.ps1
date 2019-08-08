param(
[Parameter(Mandatory)]
$account,
[Parameter(Mandatory)]
$PAT,
[Parameter(Mandatory)]
$PoolNamePrefix,
[Parameter(Mandatory)]
$ComputerName,
$count = 1
)

# Setup NVD
New-Item C:\tools -ItemType Directory

Set-Location C:\tools
$dcversion = "dependency-check-5.1.0-release"
$dczip = "$dcversion.zip"

## Get zip
wget https://dl.bintray.com/jeremy-long/owasp/$dczip -OutFile $dczip

Expand-Archive -Path ./$dczip

$dcpath = "C:\tools\$dcversion\dependency-check\bin"

$path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
[System.Environment]::SetEnvironmentVariable("Path", $path + ";$dcpath", "Machine")

Set-Location $dcpath

## update
.\dependency-check.bat --updateonly

## set acl
$user = "NT AUTHORITY\NETWORK SERVICE"
$cachepath = "C:\tools\$dcversion\dependency-check\data\cache"
$acl = Get-Acl $cachepath

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user,"FullControl","Allow")

$acl.SetAccessRule($AccessRule)

$acl | Set-Acl $cachepath

Get-ChildItem $cachepath -recurse -Force |% {
    $ACLFile = Get-Acl $_.fullname
    $ACLFile.SetAccessRule($AccessRule)
    $ACLfile | Set-Acl -Path $_.fullname
}

# Setup vsts agent
$data = Invoke-RestMethod -Uri https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | Select Name

$agentVersion = $data.Name.replace('v','')

$zip = "vsts-agent-win-x64-$agentVersion.zip"

New-Item C:\a -ItemType Directory

Set-Location C:\a

wget "https://vstsagentpackage.azureedge.net/agent/$agentVersion/$zip" -OutFile ./$zip


# Loop for Agents pool
for ($i = 1; $i -le $count; $i++) {
    Set-Location C:\a
    $agentDir = "A$i"
    $agentName = "$ComputerName-A$i"
    
    Expand-Archive -Path ./$zip -DestinationPath ./$agentDir
    
    cd $agentDir
        
    .\config.cmd --unattended --url https://dev.azure.com/$account --auth PAT --token $PAT --pool "$PoolNamePrefix Agents" --agent "$agentName" --runAsService
}


# Loop for Windows 2019 pool
for ($i = 1; $i -le $count; $i++) {
    Set-Location C:\a
    $agentDir = "B$i"
    $agentName = "$ComputerName-B$i"
    
    Expand-Archive -Path ./$zip -DestinationPath ./$agentDir
    
    cd $agentDir
        
    .\config.cmd --unattended --url https://dev.azure.com/$account --auth PAT --token $PAT --pool "$PoolNamePrefix Windows 2019" --agent "$agentName" --runAsService
}
