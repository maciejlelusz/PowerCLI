# List Powered ON VM's in cluster and save in csv

$Cluster = Read-Host -Prompt 'Input your cluster name: '
$ExportFilePath = $Cluster + "_list_poweredon.csv"
$Report = @()

Get-Cluster $Cluster | get-vm | Where-object {$_.powerstate -eq "PoweredOn"} | %{
	$report += New-Object PSObject -Property @{
		VMName = $_.Name
		Powerstate = $_.Powerstate
	}
}

$Report = $Report | Sort-Object VMName

if ($Report) {
	$report | Export-Csv $ExportFilePath -NoTypeInformation}
else{
	"No PoweredOn VM's found"
}
