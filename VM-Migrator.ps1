# Migrate VM's from one host to another (based on csv)

$filename = Read-Host -Prompt 'Input file name with list of VMs to vMotion: '
$MyHost = Read-Host -Prompt 'Input your host name where you want to migrate VMs: '
$names = Import-Csv $filename

foreach ($line in $names) {
	Get-VM -Name $($line.VMName) | Move-VM -Destination $MyHost
} 