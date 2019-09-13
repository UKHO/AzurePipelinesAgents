param (
    [Parameter(Mandatory)]
    $VmSize,
    $ResourceGroupNamePattern
)

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

Write-Output("---start---")
foreach ($ResourceGroup in $ResourceGroups)
{    
    $ResourceGroupName = $ResourceGroup.ResourceGroupName
    Write-Output ("Showing resources in resource group " + $ResourceGroupName)
    $Resources = Get-AzureRmVM -ResourceGroupName $ResourceGroupName 
    Write-Output ("---")
    ForEach ($vm in $Resources)
    {
        $vmName = $vm.Name
        $vm
        Write-Output("----Running: $vmName----")
        $vm.HardwareProfile.vmSize = $VmSize
        Update-AzureRmVM -ResourceGroupName $ResourceGroupName -VM $vm
        Write-Output("----Complete $vmName is now $vmSize----")
    }
    Write-Output ("---")
} 
Write-Output("---end---")
