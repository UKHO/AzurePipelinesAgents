param(
    [Parameter(Mandatory)]
    $Numbers,
    $ResourceGroupNamePattern
)

$numberArray = $Numbers.Split(' ')
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

#Get all ARM resources from all resource groups
$ResourceGroups = Get-AzureRmResourceGroup | Where ResourceGroupName -like $ResourceGroupNamePattern

foreach ($ResourceGroup in $ResourceGroups)
{    
    $ResourceGroupName = $ResourceGroup.ResourceGroupName
    Write-Output ("Showing resources in resource group " + $ResourceGroupName)
    $Resources = Get-AzureRmVM -ResourceGroupName $ResourceGroupName 
    
    ForEach ($vm in $Resources)
    {
        $vmName = $vm.Name
        $vmNumber = $vmName.Substring($vmName.length-2)
        Write-Output("$vmName : $vmNumber")
        if($numberArray -contains $vmNumber) {
            Write-Output ($vmName)
            $vm | Stop-AzureRmVM -Force
        }
    }
    Write-Output ("")
} 
