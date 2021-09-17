# https://blogs.vmware.com/PowerCLI/2021/04/new-release-powercli-12-3.html

#Connect to vCenter. Edit values as appropriate.
$vc = "vcsa-mgmt.int.inleo.pl"
$vc_user = "administrator@inleo.lab"
$vc_password = "XXXXXX"
Connect-VIServer -User $vc_user -Password $vc_password -Server $vc
$Cluster = Get-Cluster  -Name "Workload-Cluster"
$datacenter = Get-Datacenter "Tanzu-Datacenter"
$datastore = Get-Datastore -Name  "vsanDatastore"
$vmhosts = Get-VMHost
$tkgcl = "TKG-Content-Library"
$ntpservers = @("time.vmware.com")
$ManagementVirtualNetwork = get-virtualnetwork "DVPG-Supervisor-Management-Network"
$HAProxyVMName = "tanzu-haproxy-1"
 
#Enable Workload Management with HAProxy and vSphere Networking

Write-Host "Enabling Workload Management"
Get-Cluster $Cluster | Enable-WMCluster `
       -SizeHint Tiny `
       -ManagementVirtualNetwork $ManagementVirtualNetwork `
       -ManagementNetworkMode StaticRange `
       -ManagementNetworkGateway "192.168.1.1" `
       -ManagementNetworkSubnetMask "255.255.255.0" `
       -ManagementNetworkStartIPAddress "192.168.1.230" `
       -ManagementNetworkAddressRangeSize 5 `
       -MasterDnsServerIPAddress @("192.168.1.30") `
       -MasterNtpServer @("time.vmware.com") `
       -ServiceCIDR "10.96.0.0/24" `
       -EphemeralStoragePolicy "tanzu-gold-storage-policy" `
       -ImageStoragePolicy "tanzu-gold-storage-policy" `
       -MasterStoragePolicy "tanzu-gold-storage-policy" `
       -ContentLibrary $tkgcl `
       -HAProxyName $HAProxyVMname `
       -HAProxyAddressRanges "192.168.1.240-192.168.1.245" `
       -HAProxyUsername "wcp" `
       -HAProxyPassword "VMware1!" `
       -HAProxyDataPlaneAddresses "192.168.2.224:5556" `
       -HAProxyServerCertificateChain "-----BEGIN CERTIFICATE-----
MIIDoTCCAomgAwIBAgIJANWKOVSYSbhzMA0GCSqGSIb3DQEBBQUAMG4xCzAJBgNV
BAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRIwEAYDVQQHDAlQYWxvIEFsdG8x
DzANBgNVBAoMBlZNd2FyZTENMAsGA1UECwwEQ0FQVjEWMBQGA1UEAwwNMTkyLjE2
OC4xLjIyNDAeFw0yMTA5MTMxODIyNDZaFw0zMTA5MTExODIyNDZaMG4xCzAJBgNV
BAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRIwEAYDVQQHDAlQYWxvIEFsdG8x
DzANBgNVBAoMBlZNd2FyZTENMAsGA1UECwwEQ0FQVjEWMBQGA1UEAwwNMTkyLjE2
OC4xLjIyNDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM8D857n9w5S
JwOqFAPTzhBCaTOtUuYrBEcjzJzIa084vFtWJUdfPzX5kytTK1L7rK/xolMZghTr
46eTuihZY01GigQzBrDu+J/qKLlal76ACpy8SNG6FpWIWtEnyIzjwlTKNpRw3ryN
2+pAbj6q1ePpdPRgPMHOr/fq5VW0TywmdnC/CFMTvQUwbf5VEV3eJ9Vmcj6GkXM/
ByvXMfLtqPM545KoL7HGuh1MpR0XN6PSdEOp58FqSAjyPPa/uJoHcbIlQxwVNYw2
eoib7K5bLjM6HRNS0GOJOfboAeScoH78XJ52b4cm5VKbOwtn+7Ub0EDpT1Jx13M9
oivREe0FFSECAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC
AYYwHQYDVR0OBBYEFPVJccsonSSLpE9mTRtjCScpceO6MA0GCSqGSIb3DQEBBQUA
A4IBAQAjruMOjRQwL37y1FEb551LVlLtmA4kfJRY2+tVg2W0Ugem4PuainR5hUZm
1JOJyR4FkDU2y+94EfCMfSMqGd28oI+v7Dl/u30VgoJfzwahdojM3thOdbFAUdln
poK0FKu1EPqBdQ440Plle09KYeRmc929o5hezerPaquy8+EdYr9ZT1w4sUf/O+vJ
IfFO8owFs3fRDCw2gt0IxBuMCkXJ4Dr5EDNOT10B+FcXf+ke3zEHThkeFCtw7tTv
OnRS9jSuLKhhI9k8tedm+dP7jCP/frSLRn/K9y6d88PXLV/34ekZszNLH2mVclof
Sr//wlvmrEV/ykO3JMgQp4bu6ihn
-----END CERTIFICATE-----" `
       -WorkerDnsServer "192.168.1.30" `
       -PrimaryWorkloadNetworkSpecification ( New-WMNamespaceNetworkSpec `
          -Name "network-1" `
          -Gateway "192.168.2.1" `
          -Subnet "255.255.255.0" `
          -AddressRanges "192.168.2.2-192.168.2.126" `
          -DistributedPortGroup "DVPG-Workload-Network" `
       )
#
