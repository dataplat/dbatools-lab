 <#
    This is the code from dbatools in a Month of Lunches chapter 06

    You will have to pay attention to the names of instances and databases.

    You running this script/function/code means you will not blame the author(s) if this breaks your stuff. 
    This script/function is provided AS IS without warranty of any kind. Author(s) disclaim all implied warranties 
    including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
    The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. 
    In no event shall author(s) be held liable for any damages whatsoever (including, without limitation, damages 
    for loss of business profits, business interruption, loss of business information, or other pecuniary loss) 
    arising out of the use of or inability to use the script or documentation.

    Chrissy Rob Jess Claudio
    #>

    
Find-DbaInstance -ComputerName dbatoolslab

        ###########
        
Get-Content -Path C:\temp\serverlist.txt | Find-DbaInstance

# Pipe in computers from Active Directory
Get-ADComputer -Filter "*" | Find-DbaInstance

        ###########
        
Find-DbaInstance -DiscoveryType DataSourceEnumeration -ScanType Browser

ComputerName InstanceName Port  Availability Confidence ScanTypes

        ###########
        
[System.Data.Sql.SqlDataSourceEnumerator]::Instance.GetDataSources()

        ###########
        
Find-DbaInstance -DiscoveryType Domain

        ###########
        
$splatFindInstance = @{
        DiscoveryType = "Domain"
        DomainController = "dc.devad.local"
        Credential = "devad\admin"
}
Find-DbaInstance @splatFindInstance

        ###########
        
Find-DbaInstance -DiscoveryType IPRange

        ###########
        
Find-DbaInstance -DiscoveryType IPRange -IpAddress 172.20.0.77

# Specify a range
Find-DbaInstance -DiscoveryType IPRange -IpAddress 172.20.0.1/24

        ###########
        
Find-DbaInstance -ComputerName SQLDEV01 | Select *


        ###########
        
Find-DbaInstance -ComputerName SQLDEV01 |
        Select -ExpandProperty DnsResolution


        ###########
        
Find-DbaInstance -ComputerName SQLDEV01 |
        Select -ExpandProperty Services


        ###########
        
