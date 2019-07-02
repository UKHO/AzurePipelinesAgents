param(
[Parameter(Mandatory)]
$account,
[Parameter(Mandatory)]
$PAT,
[Parameter(Mandatory)]
$pool,
[Parameter(Mandatory)]
$ComputerName,
$count = 1
)

$data = Invoke-RestMethod -Uri https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | Select Name

$agentVersion = $data.Name.replace('v','')

$zip = "vsts-agent-win-x64-$agentVersion.zip"

New-Item C:\a -ItemType Directory

Set-Location C:\a

wget "https://vstsagentpackage.azureedge.net/agent/$agentVersion/$zip" -OutFile ./$zip


for ($i = 1; $i -le $count; $i++) {
    $agentDir = "A$i"
    $agentName = "$ComputerName-A$i"
    
    Expand-Archive -Path ./$zip -DestinationPath ./$agentDir
    
    cd $agentDir
        
    .\config.cmd --unattended --url https://dev.azure.com/$account --auth PAT --token $PAT --pool "$pool" --agent $agentName --runAsService
    
    Set-Location C:\a
}