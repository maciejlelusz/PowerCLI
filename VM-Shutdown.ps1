# Shutdown VM's from csv

$filename = Read-Host -Prompt 'Input file name with list of VMs to start: '
$names = Import-Csv $filename

foreach ($line in $names) {
	Shutdown-VMGuest -VM (Get-VM -Name $($line.VMName)) -Confirm:$false
	sleep 5
} 