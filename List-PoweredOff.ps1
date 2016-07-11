# List Powered OFF VM's in cluster (last 24h) and save in csv

$Cluster = Read-Host -Prompt 'Input your cluster name: '
$ExportFilePath = $Cluster + "_list_poweredoff.csv"
$Report = @()
$VMs = Get-Cluster $Cluster | get-vm | Where-object {$_.powerstate -eq "poweredoff"}

Get-VIEvent -Start (Get-Date).AddDays(-1) -Entity $VMs -MaxSamples ([int]::MaxValue) | where {$_ -is [VMware.Vim.VmPoweredOffEvent]} | Group-Object -Property {$_.Vm.Name} | %{
	$lastPO = $_.Group | Sort-Object -Property CreatedTime -Descending | Select -First 1
	$vm = Get-VIObjectByVIView -MORef $lastPO.VM.VM
	$report += New-Object PSObject -Property @{
		VMName = $vm.Name
		Powerstate = $vm.Powerstate
		PowerOFF = $lastPO.CreatedTime
	}
}

$Report = $Report | Sort-Object VMName

if ($Report) {
	$report | Export-Csv $ExportFilePath -NoTypeInformation}
else{
	"No PoweredOff events found"
}
