# List Powered ON VM's at host and save in csv

$MyHost = Read-Host -Prompt 'Input your host name: '
$ExportFilePath = $MyHost + "_list_poweredon.csv"
$Report = @()

Get-VM | Where-Object {$_.Host.Name -eq $MyHost} | Where-object {$_.powerstate -eq "PoweredOn"} | %{
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
