 <#
    This is the code from dbatools in a Month of Lunches chapter 07

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

    
cd "C:\Program Files\Microsoft SQL Server\140\Setup Bootstrap\SQL2017"
.\setup.exe /Action=RunDiscovery

        ###########
        
Get-DbaFeature -ComputerName $sqlinstances

        ###########
        
Get-DbaBuildReference -SqlInstance SQLDEV01


        ###########
        
Get-DbaBuildReference -Update

        ###########
        
Test-DbaBuild -SqlInstance SQLDEV01 -Latest

        ###########
        
Get-DbaComputerSystem -ComputerName SQLDEV01


        ###########
        
Get-DbaOperatingSystem -ComputerName SQL2016N1.ad.local


        ###########
        
Get-DbaDatabase -SqlInstance SQLDEV01

        ###########
        
$splatDatabase = @{
    SqlInstance = "SQLDEV01"
    Database = "WideWorldImporters", "AdventureWorks"
}
Get-DbaDatabase @splatDatabase

        ###########
        
Get-DbaDatabase -SqlInstance SQLDEV01 -NoFullBackup

        ###########
        
$date = (Get-Date).AddDays(-30)
Get-DbaDatabase -SqlInstance SQLDEV01 -NoFullBackupSince $date

        ###########
        
$splatInvokeQuery = @{
    SqlInstance = "ConfigInstance"
    Database = "Instances"
    Query = "SELECT InstanceName FROM Config"
}
$SqlInstances = (Invoke-DbaQuery @splatInvokeQuery).InstanceName
# Find databases owned by the user
Get-DbaDatabase -SqlInstance $instances -User ad\g.sartori

        ###########
        
Find-DbaUserObject -SqlInstance sql2017, sql2005



        ###########
        
$sqlconfiginstance = "ConfigInstance"

# A comma delimited list of Host names
$sqlhosts = "SQLDEV01", "sql1"

# A comma-delimted list of SQL Server instances
$sqlinstances = "SQLDEV01","sql1","SQLDEV01\SHAREPOINT", "sql1\DW"

# Create DBAEstate database if not existing
New-DbaDatabase -SqlInstance $sqlconfiginstance -Name DBAEstate

# Put information about the SQL hosts into the DBAEstate database
$splatWriteDataTable = @{
    SqlInstance = $sqlconfiginstance
    Database = "DBAEstate"
    AutoCreateTable = $true
}
Get-DbaFeature -ComputerName $sqlhosts |
Write-DbaDataTable @splatWriteDataTable -Table Features

Get-DbaBuildReference -SqlInstance $sqlinstances |
Write-DbaDataTable @splatWriteDataTable -Table SQLBuilds

Get-DbaComputerSystem -ComputerName $sqlhosts |
Write-DbaDataTable @splatWriteDataTable -Table ComputerSystem

Get-DbaOperatingSystem -ComputerName $sqlhosts |
Write-DbaDataTable @splatWriteDataTable -Table OperatingSystem

Get-DbaDatabase -SqlInstance $sqlinstances |
Write-DbaDataTable @splatWriteDataTable -Table Database

Find-DbaUserObject -SqlInstance $sqlinstances |
Write-DbaDataTable @splatWriteDataTable -Table UserObject

        ###########
        
