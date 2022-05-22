<#
This is the code from dbatools in a Month of Lunches

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


<#
    This is the code from dbatools in a Month of Lunches chapter 02
#>


Invoke-Command -ComputerName spsql01 -ScriptBlock { $Env:COMPUTERNAME }

        ###########

$Env:PSModulePath -Split ";"

        ###########

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

        ###########

Import-Module dbatools

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 03
#>


Install-DbaInstance -Version 2019 -SqlInstance dbatoolslab
 -Feature Engine -Path Z:\2019 -AuthenticationMode Mixed

        ###########

Install-DbaInstance -Version 2017

        ###########

Connect-DbaInstance -SqlInstance dbatoolslab

        ###########

Find-DbaInstance -ComputerName localhost

ComputerName InstanceName Port  Availability Confidence ScanTypes

        ###########

Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017
 -Path C:\dbatoolslab\Backup\WideWorldImporters-Full.bak
Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017
 -Path C:\dbatoolslab\Backup\AdventureWorks2017-Full.bak

        ###########

$pw = (Get-Credential wejustneedthepassword).Password
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw
 -Login WWI_ReadOnly
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw
 -Login WWI_ReadWrite
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw
 -Login WWI_Owner

# Create database users
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_ReadOnly
 -Database WideWorldImporters -Confirm:$false
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_ReadWrite
 -Database WideWorldImporters -Confirm:$false
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_Owner
 -Database WideWorldImporters -Confirm:$false

# Add database role members
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017
 -Database WideWorldImporters -User WWI_Readonly -Role db_datareader
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017
 -Database WideWorldImporters -User WWI_ReadWrite -Role db_datawriter
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017
 -Database WideWorldImporters -User WWI_Owner -Role db_owner

# Create some SQL Server Agent jobs
$job = New-DbaAgentJob -SqlInstance dbatoolslab\sql2017
 -Job 'dbatools lab job'
 -Description 'Creating a test job for our lab'
New-DbaAgentJobStep -SqlInstance dbatoolslab\sql2017 -Job $Job.Name
 -StepName 'Step 1: Select statement'
 -Subsystem TransactSQL -Command 'Select 1'

# add second job
$job = New-DbaAgentJob -SqlInstance dbatoolslab\sql2017
 -Job 'dbatools lab - where am I'
 -Description 'Creating test2 job for our lab'
New-DbaAgentJobStep -SqlInstance dbatoolslab\sql2017 -Job $Job.Name
 -StepName 'Step 1: Select servername'
 -Subsystem TransactSQL -Command 'Select @@ServerName'

        ###########

Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017
 -Name RemoteDacConnectionsEnabled -Value 1
Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017
 -Name CostThresholdForParallelism -Value 10

        ###########

# create a shared network
docker network create localnet

# Expose engines and setup shared path for migrations
docker run -p 1433:1433  --volume shared:/shared:z --name mssql1
 --hostname mssql1 --network localnet -d dbatools/sqlinstance
docker run -p 14333:1433 --volume shared:/shared:z --name mssql
 --hostname mssql2 --network localnet -d dbatools/sqlinstance2

        ###########

docker ps

        ###########

Connect-DbaInstance -SqlInstance localhost -SqlCredential sqladmin

# Connect to SQL Server in a container listening on non standard port
$cred = Get-Credential sqladmin
Connect-DbaInstance -SqlInstance localhost:14333 -SqlCredential $cred

        ###########

New-DbaClientAlias -ServerName localhost -Alias mssql1
Connect-DbaInstance -SqlInstance mssql1 -SqlCredential sqladmin


        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 04
#>


Get-Help Test-DbaConnection -Detailed

        ###########

Test-DbaConnection -SqlInstance $Env:ComputerName

        ###########

Get-DbaDatabase -SqlInstance SQLDEV01

        ###########

Connect-DbaInstance -SqlInstance PRODSQL01\SHAREPOINT

        ###########

Connect-DbaInstance -SqlInstance PRODSQL01, PRODSQL02, PRODSQL03\ShoeFactory

        ###########

"PRODSQL01", "PRODSQL02", "PRODSQL03\ShoeFactory" | Connect-DbaInstance

        ###########

$instances = "PRODSQL01", "PRODSQL02", "PRODSQL03\ShoeFactory"
Connect-DbaInstance -SqlInstance $instances

        ###########

$instances = "PRODSQL01", "PRODSQL02", "PRODSQL03\ShoeFactory"
$instances | Connect-DbaInstance

        ###########

$instances = (Invoke-DbaQuery -SqlInstance ConfigInstance
 -Database DbaConfig -Query "SELECT InstanceName FROM
 Config.Instances C JOIN Project.People P ON C.InstanceID =
 P.InstanceID WHERE P.Name = 'Shawn Melton'").InstanceName
$instances | Connect-DbaInstance

        ###########

$instances = Invoke-DbaQuery -SqlInstance ConfigInstance
  -Database DbaConfig -Query "SELECT InstanceName FROM
 Config.Instances C JOIN Project.People P ON C.InstanceID =
 P.InstanceID WHERE P.Name = 'Shawn Melton'" | Select-Object
 -ExpandProperty InstanceName
$instances | Connect-DbaInstance

        ###########

Connect-DbaInstance -SqlInstance "sqldev04,57689"

        ###########

Connect-DbaInstance -SqlInstance sqldev04:57689

        ###########

Connect-DbaInstance -SqlInstance CORPSQL01 -SqlCredential devadmin

        ###########

Connect-DbaInstance -SqlInstance CORPSQL01 -SqlCredential devadmin


        ###########

$cred = Get-Credential
# Connect to the local machine using the credential
Connect-DbaInstance -SqlInstance $Env:ComputerName -SqlCredential $cred

        ###########

$cred = Get-Credential


        ###########

Connect-DbaInstance -SqlInstance $Env:ComputerName -SqlCredential $cred

Name    Product              Version   Platform IsAzure IsClustered ConnectedAs

        ###########

$query = "EXEC GetPasswordFromPasswordStore @UserName='AD\dbatools'"
$securepassword = ConvertTo-SecureString (Invoke-DbaQuery -SqlInstance
 VerySecure -Database NoPasswordsHere -Query $query) -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential (
 "AD\dbatools", $securepassword)
Test-DbaConnection -SqlInstance $Env:ComputerName -SqlCredential $cred

        ###########

Connect-DbaInstance -SqlInstance SQLDEV01 -SqlCredential ad\sander.stad

        ###########

$server = Connect-DbaInstance -SqlInstance dbatools.database.windows
 .net -SqlCredential dbatools@mycorp.onmicrosoft.com -Database inventory
# Use server connection to query the database using our query command,
 Invoke-DbaQuery
Invoke-DbaQuery -SqlInstance $server -Database inventory -Query
 "select name from instances"

        ###########

Connect-DbaInstance -SqlInstance dbatools.database.windows.net
 -SqlCredential 52c1fbca-24ed-4353-bbf1-6dd52f535027 -Tenant
 ec46e088-2707-4b0a-ab0d-dee0b52fc5c8 -Database inventory

Name                                Product Version   Platform IsAzure IsClustered ConnectedAs

        ###########

$appcred = Get-Credential 52c1fbca-24ed-4353-bbf1-6dd52f535027

# Establish a connection
$server = Connect-DbaInstance -SqlInstance dbatools.database.windows
 .net -Database inventory -SqlCredential $appcred -Tenant
 6b73c0ef-114d-43ad-94c9-85a4a82cde8b

# Now that the connection is established, use it to perform a query
Invoke-DbaQuery -SqlInstance $server -Database dbatools -Query
 "SELECT Name FROM sys.objects"

Name

        ###########

Get-Help Get-DbaService

Synopsis
Gets the SQL Server related services on a computer.

Description
Gets the SQL Server related services on one or more computers.

Requires Local Admin rights on destination computer(s).

Syntax
Get-DbaService [[-ComputerName] <DbaInstanceParameter[]>] [-InstanceName <String[]>] [-Credential <PSCredential>] [-Type <String[]>] [-AdvancedProperties] [-EnableException] [<CommonParameters>]
Get-DbaService [[-ComputerName] <DbaInstanceParameter[]>] [-Credential <PSCredential>] [-ServiceName <String[]>] [-AdvancedProperties] [-EnableException] [<CommonParameters>]

        ###########

Get-DbaService -ComputerName CORPSQL

ComputerName : CORPSQL
ServiceName  : MsDtsServer140
ServiceType  : SSIS
InstanceName :
DisplayName  : SQL Server Integration Services 14.0
StartName    : NT Service\MsDtsServer140
State        : Stopped
StartMode    : Manual

ComputerName : CORPSQL
ServiceName  : MSSQLSERVER
ServiceType  : Engine
InstanceName : MSSQLSERVER
DisplayName  : SQL Server (MSSQLSERVER)
StartName    : NT Service\MSSQLSERVER
State        : Stopped
StartMode    : Manual

ComputerName : CORPSQL
ServiceName  : SQLBrowser
ServiceType  : Browser
InstanceName :
DisplayName  : SQL Server Browser
StartName    : NT AUTHORITY\LOCALSERVICE
State        : Stopped
StartMode    : Manual

ComputerName : CORPSQL
ServiceName  : SQLSERVERAGENT
ServiceType  : Agent
InstanceName : MSSQLSERVER
DisplayName  : SQL Server Agent (MSSQLSERVER)
StartName    : NT Service\SQLSERVERAGENT
State        : Stopped
StartMode    : Manual

        ###########

Get-DbaService -ComputerName SQL01, SQL02

# Computer Names piped to a command
"SQL01", "SQL02" | Get-DbaService

# Computer Names stored in a variable
$servers = "SQL01", "SQL02"
Get-DbaService -ComputerName $servers

# Computer Names stored in a variable and piped to a command
$servers = "SQL01", "SQL02"
$servers | Get-DbaService

        ###########

Get-DbaService -ComputerName CORPSQL -Credential AD\wdurkin


        ###########

$cred = Get-Credential


        ###########

Get-DbaService -ComputerName CORPSQL -Credential $cred

        ###########

Get-DbaService -ComputerName CORPSQL -Type Engine

        ###########

Get-DbaService -ComputerName CORPSQL -InstanceName BOLTON

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 05
#>


Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem


        ###########

Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
        Select Name, Size, LastFullBackup


        ###########

Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackup | clip

        ###########

Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackup |
Export-Csv -Path Databaseinfo.csv -NoTypeInformation

Get-Content DatabaseInfo.csv

        ###########

Get-ChildItem -Path E:\csvs\top.csv |
Import-DbaCsv -SqlInstance SQLDEV01 -Database tempdb -Table top


        ###########

Get-ChildItem E:\csv\top*.csv |
Import-DbaCsv -SqlInstance SQLDEV01 -Database tempdb -AutoCreateTable


        ###########

Import-Csv -Path E:\csv\top-tracks.csv |
Select Rank, Plays, Artist, Title


        ###########

Import-Csv -Path .\Databaseinfo.csv |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb
 -Table Databases -AutoCreateTable

        ###########

$csv = Import-Csv \\server\bigdataset.csv
Write-DbaDataTable -SqlInstance sql2014
 -InputObject $csv -Database mydb

        ###########

$query = "Select * from Databases"
Invoke-DbaQuery -SqlInstance SQLDEV01 -Database tempdb -Query $query

        ###########

Remove-DbaDbTable SqlInstance SQL01 -Database tempdb -Table databases

        ###########

Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackUp |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb
 -Table Databases -AutoCreateTable

        ###########

$query = "Select * from Databases"
Invoke-DbaQuery -SqlInstance SQLDEV01 -Query $query
 -Database tempdb

        ###########

(Get-DbaDbTable -SqlInstance SQLDEV01
 -Database tempdb -Table Databases).Columns |
Select-Object  Parent,Name, Datatype


        ###########

Import-Csv -Path .\Databaseinfo.csv | Get-Member
Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackup | Get-Member

        ###########

Import-Csv -Path .\Databaseinfo.csv |
Write-DbaDataTable -SqlInstance SQLDEV01
 -Database tempdb -Table Databases

        ###########

Import-Csv -Path .\Databaseinfo.csv |
Write-DbaDataTable -SqlInstance SQLDEV01
 -Database tempdb -Table Databases
Invoke-DbaQuery -SqlInstance SQLDEV01
 -Query "select * from Databases" -Database tempdb


        ###########

Get-Process | Select -Last 10 |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb
 -Table processes -AutoCreateTable

        ###########

(Get-DbaDbTable -SqlInstance SQLDEV01 -Database tempdb
 -Table processes).Columns | Select-Object  Parent,Name, Datatype


        ###########

Connect-AzAccount


        ###########

Get-AzVM -Status | Write-DbaDataTable -SqlInstance SQLDEV01
 -Database tempdb -Table AzureVMs -AutoCreateTable

        ###########

$query = "SELECT [Name]
        ,[Location]
        ,[PowerState]
        ,[StatusCode]
        FROM [AzureVMs]"
Invoke-DbaQuery -SqlInstance SQLDEV01
 -Query $query -Database tempdb


        ###########

$copyDbaDbTableDataSplat = @{
    SqlInstance = "SQLDEV01"
    Database = "WideWorldImporters"
    Table = '[Purchasing].[PurchaseOrders]'
    Destination = "SQLDEV02,15591"
    DestinationDatabase = 'WIP'
    DestinationTable = 'dbo.PurchaseOrders'
    AutoCreateTable = $true
}
Copy-DbaDbTableData @copyDbaDbTableDataSplat

SourceInstance      : SQLDEV01
SourceDatabase      : WideWorldImporters
SourceSchema        : Purchasing
SourceTable         : PurchaseOrders
DestinationInstance : SQLDEV02,15591
DestinationDatabase : WIP
DestinationSchema   : dbo
DestinationTable    : PurchaseOrders
RowsCopied          : 2074
Elapsed             : 77.01 ms

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 06
#>


Find-DbaInstance -ComputerName dbatoolslab

        ###########

Get-Content -Path C:\temp\serverlist.txt | Find-DbaInstance

# Pipe in computers from Active Directory
Get-ADComputer -Filter "*" | Find-DbaInstance

        ###########

Find-DbaInstance -DiscoveryType DataSourceEnumeration
 -ScanType Browser

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

<#
    This is the code from dbatools in a Month of Lunches chapter 07
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

<#
    This is the code from dbatools in a Month of Lunches chapter 08
#>


Get-DbaRegServer | Invoke-DbaQuery -Query "SELECT @@VERSION"

        ###########

Get-DbaRegServer


        ###########

Get-DbaRegServer -Name sql01 | Get-DbaDatabase |
Backup-DbaDatabase


        ###########

$cred = Get-Credential sqladmin
Get-DbaRegserver -SqlInstance dbainstance |
Backup-DbaDatabase -SqlCredential $cred

        ###########

Get-DbaRegServer -SqlInstance dbainstance


        ###########

Import-Csv -Path C:\temp\regservers.csv

ServerName Name               Description    Group

        ###########

Import-Csv -Path C:\temp\regservers.csv |
Import-DbaRegServer -SqlInstance sql2016


        ###########

Get-DbaRegServer -SqlInstance sql2016 -Group Test\Dev


        ###########

Get-DbaRegServer -SqlInstance sql2016 -ExcludeGroup Test\Dev


        ###########

Get-DbaRegServer -SqlInstance dbainstance -IncludeLocal

        ###########

Add-DbaRegServer -ServerName sql2017

        ###########

$splatRegServer = @{
    SqlInstance = "sqldb01"
    Group = "OnPrem"
    ServerName = "sql01"
}
Add-DbaRegServer @splatRegServer

        ###########

$splatRegServer = @{
    SqlInstance = "sqldb01"
    Group = "OnPrem\Accounting"
    ServerName = "sql01"
}
Add-DbaRegServer @splatRegServer

        ###########

$splatConnect = @{
    SqlInstance = "dockersql1,14333"
    SqlCredential = "sqladmin"
}
Connect-DbaInstance @splatConnect | Add-DbaRegServer
 -Description = "Container for AG tests"

        ###########

Copy-DbaRegServer -Source sql2008 -Destination sql01

# Export CMS list to an XML file
$splatExportRegServer = @{
    SqlInstance = "sql2008"
    Path = "C:\temp"
    OutVariable = file
}
Export-DbaRegServer @splatExportRegServer

# Import CMS list from an XML file
Import-DbaRegServer -SqlInstance sql01 -Path $file

        ###########

Move-DbaRegServer -Name 'Web SQL Cluster' -Group HR\Prod

        ###########

Get-DbaRegServer | Where Name -match HR |
Move-DbaRegServer -Group HR\Prod

        ###########

Remove-DbaRegServer -ServerName sql01

        ###########

Get-DbaRegServer -ServerName sql2016, sql01 |
Remove-DbaRegServer -Confirm:$false

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 09
#>


$splatGetErrorLog = @{
    SqlInstance = "SQL01"
    After = (Get-Date).AddMinutes(-5)
}
Get-DbaErrorLog @splatGetErrorLog | Select LogDate, Source, Text

        ###########

New-DbaLogin -SqlInstance SQL01 -Login Factory

        ###########

$servers = Get-DbaRegisteredServer
New-DbaLogin -SqlInstance $servers -Login ad\factoryauditors

        ###########

$servers = Get-DbaRegisteredServer
$cred = Get-Credential factoryuser1
$splatNewLogin = @{
    SqlInstance = $servers
    Login = $cred.UserName
    SecurePassword = $cred.Password
}
 New-DbaLogin @splatNewLogin

        ###########

Get-DbaDbUser -SqlInstance SQL01 -Database WideWorldImporters | Select Name

        ###########

Get-DbaDbUser -SqlInstance SQL01 -Database WideWorldImporters | Select Name

        ###########

Repair-DbaDbOrphanUser -SqlInstance SQL01"

        ###########

try {
    # Since this is running as an Agent job, use $ENV:ComputerName
    # to get the hostname of the server the job runs on
    $splatGetAgReplica = @{
        SqlInstance = $ENV:ComputerName
        EnableException = $true
    }
    $replicas = (Get-DbaAgReplica $splatGetAgReplica).Name

}
catch {
    # Ensure SQL Agent shows a failed job
    Write-Error -Message $_ -ErrorAction Stop
}

foreach ($replica in $replicas) {
    Write-Output "For this replica $replica"
    $replicastocopy = $replicas | Where-Object { $_ -ne $replica }
    foreach ($replicatocopy in $replicastocopy) {
      Write-Output "We will copy logins from $replica to $replicatocopy"

      $splatCopyLogin = @{
          Source = $replica
          Destination = $replicatocopy
          ExcludeSystemLogins = $true
          EnableException = $true
      }

      try {
        $output =  Copy-DbaLogin @splatCopyLogin
      } catch {
        $error[0..5] | Format-List -Force | Out-String
        # Ensure SQL Agent shows a failed job
        Write-Error -Message $_ -ErrorAction Stop
      }
        if ($output.Status -contains 'Failed') {
            $error[0..5] | Format-List -Force | Out-String
            # Ensure SQL Agent shows a failed job
            Write-Error -Message "At least one login failed.
            [CA]See log for details." -ErrorAction Stop
        }
    }
}

        ###########

Export-DbaLogin -SqlInstance SQL01"

        ###########

git init



        ###########

$date = Get-Date
$path = "$home\sourcerepo\SqlPermission"
$file = "Factory.sql"
Export-DbaLogin -SqlInstance SQL01"

        ###########

Set-Location $path
git add $file
git commit -m "The Factory users update for $date"

        ###########

Get-DbaUserPermission -SqlInstance SQL01 -Database WideWorldImporters |
Select SqlInstance, Object, Type, Member, RoleSecurableClass | Format-Table"

        ###########

$splatExportExcel = @{
 Path = "C:\temp\FactoryPermissions.xlsx"
 WorksheetName = "User Permissions"
 AutoSize = $true
 FreezeTopRow = $true
 AutoFilter = $true
 PassThru = $true
}

$excel = Get-DbaUserPermission -SqlInstance SQL01
 -Database WideWorldImporters | Export-Excel @splatExportExcel

$rulesparam = @{
 Address = $excel.Workbook.Worksheets["User Permissions"].Dimension.Address
 WorkSheet = $excel.Workbook.Worksheets["User Permissions"]
 RuleType = "Expression"
}

Add-ConditionalFormatting @rulesparam
 -ConditionValue 'NOT(ISERROR(FIND("sysadmin",$G1)))'
 -BackgroundColor Yellow -StopIfTrue

Add-ConditionalFormatting @rulesparam
 -ConditionValue 'NOT(ISERROR(FIND("db_owner",$G1)))'
 -BackgroundColor Yellow -StopIfTrue

Add-ConditionalFormatting @rulesparam
 -ConditionValue 'NOT(ISERROR(FIND("SERVER LOGINS",$E1)))'
 -BackgroundColor PaleGreen

Add-ConditionalFormatting @rulesparam
 -ConditionValue 'NOT(ISERROR(FIND("SERVER SECURABLES",$E1)))'
 -BackgroundColor PowderBlue

Add-ConditionalFormatting @rulesparam
 -ConditionValue 'NOT(ISERROR(FIND("DB ROLE MEMBERS",$E1)))'
 -BackgroundColor GoldenRod

Add-ConditionalFormatting @rulesparam
 -ConditionValue 'NOT(ISERROR(FIND("DB SECURABLES",$E1)))'
 -BackgroundColor BurlyWood

Close-ExcelPackage $excel

        ###########

Find-DbaLoginInGroup -SqlInstance SQL01 -Login "ad\bmiller"

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 10
#>


Backup-DbaDatabase -SqlInstance sql01

        ###########

Backup-DbaDatabase -SqlInstance sql01 -Path \\nas\sqlbackups


        ###########

Backup-DbaDatabase -SqlInstance sql01 -Database pubs -BackupFileName NUL

        ###########

$bigdbs = Get-DbaDatabase -SqlInstance sql01 | Where Name -match factory
$bigdbs | Backup-DbaDatabase -Path \\nas\sqlbackups -OutputScriptOnly

        ###########

$splatCredential = @{
	SqlInstance = "sql01"
	Name = "https://acmecorp.blob.core.windows.net/backups"
	Identity = "SHARED ACCESS SIGNATURE"
	SecurePassword = (Get-Credential).Password
}
New-DbaCredential @splatCredential

$splatBackup = @{
	SqlInstance = "sql01"
	AzureBaseUrl = "https://acmecorp.blob.core.windows.net/backups/"
	Database = "mydb"
	BackupFileName = "mydb.bak"
	WithFormat = $true
}
Backup-DbaDatabase @splatBackup

        ###########

$splatCredential = @{
	SqlInstance = "sql01"
	Name = "AzureAccessKey"
	Identity = "acmecorp"
	SecurePassword = (Get-Credential).Password
}
New-DbaCredential @splatCredential

$splatBackup = @{
	SqlInstance = "sql01"
	AzureCredential = "AzureAccessKey"
	AzureBaseUrl = "https://acmecorp.blob.core.windows.net/backups/"
	Database = "mydb"
}
Backup-DbaDatabase @splatBackup

        ###########

Backup-DbaDatabase -SqlInstance localhost:14433 -SqlCredential sqladmin
  -BackupDirectory /tmp

        ###########

Backup-DbaDatabase -SqlInstance localhost:14433 -SqlCredential sqladmin
  -BackupDirectory /shared/backups

        ###########

Read-DbaBackupHeader -SqlInstance sql01 -Path
 \\nas\sql\backups\mydb.bak

        ###########

Get-DbaBackupInformation -SqlInstance sql01 -Path
 \\nas\sql\backups\sql01

        ###########

Get-DbaDbBackupHistory -SqlInstance sql01 -Database pubs

        ###########

Get-DbaDbBackupHistory -SqlInstance sql01 -Last

        ###########

Find-DbaBackup -Path \\nas\sql\backups -BackupFileExtension bak
 -RetentionPeriod 90d | Remove-Item -Verbose

        ###########

Find-DbaBackup -Path \\nas\sql\backups -BackupFileExtension trn
 -RetentionPeriod 90d | Remove-Item -Verbose

        ###########

$query = "CREATE TABLE dbo.lastbackuptests (
	SourceServer nvarchar(255),
	TestServer nvarchar(255),
	[Database] nvarchar(128),
	FileExists bit,
	Size bigint,
	RestoreResult nvarchar(4000),
	DbccResult nvarchar(4000),
	RestoreStart datetime,
	RestoreEnd datetime,
	RestoreElapsed nvarchar(128),
	DbccStart datetime,
	DbccEnd datetime,
	DbccElapsed nvarchar(128),
	BackupDates nvarchar(4000),
	BackupFiles nvarchar(4000))"
Invoke-DbaQuery -SqlInstance sqltest -Database dbatools -Query $query

$splatTestBackups = @{
	SqlInstance = "sql01", "sql02"
	Destination = "sqltest"
	DataDirectory = "R:\"
	LogDirectory = "L:\"
}
Test-DbaLastBackup @splatTestBackups | Write-DbaDataTable -SqlInstance
sqltest -Table dbatools.dbo.lastbackuptests

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 11
#>


Restore-DbaDatabase -SqlInstance sql01 -Path S:\backups\pubs.bak


        ###########

Get-ChildItem \\nas\backups\mydb.bak |
Restore-DbaDatabase -SqlInstance sql01

        ###########

New-Item -Path 'C:\temp\sql' -Type Directory -Force
$splatGetDatabase = @{
	SqlInstance = "sql01"
	ExcludeDatabase = "tempdb", "master", "msdb"
}
$dbs = Get-DbaDatabase @splatGetDatabase
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Full
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Diff
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Log
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Log
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Log

# See files, set the variable to $files, restore all files
Get-ChildItem -Path C:\temp\sql -OutVariable files
$files | Restore-DbaDatabase -SqlInstance sql01 -WithReplace

        ###########

$splatRestoreDatabase = @{
	SqlInstance = "sql01"
	Path = "C:\temp\sql\full.bak"
	WithReplace = $true
	OutputScriptOnly = $true
}
Restore-DbaDatabase @splatRestoreDatabase

        ###########

$splatRestoreDb = @{
	SqlInstance = "sql01"
	Path = "\\nas\sql01\mydb01.bak"
	DestinationDataDirectory = "D:\data"
	DestinationLogDirectory = "L:\log"
}
Restore-DbaDatabase @splatRestoreDb

        ###########

$splatRestoreDb = @{
	SqlInstance = "sql01"
	NoRecovery = $true
}
Restore-DbaDatabase @splatRestoreDb -Path C:\temp\sql\full.bak
Restore-DbaDatabase @splatRestoreDb -Path C:\temp\sql\diff.bak

        ###########

$splatRestoreDbFinal = @{
	SqlInstance = "sql01"
	Path = "C:\temp\sql\trans.trn"
	Continue = $true
}
Restore-DbaDatabase @splatRestoreDbFinal

        ###########

$splatRestoreDbRename = @{
	SqlInstance = "sql01"
	Path = "C:\temp\sql\pubs.bak"
	DatabaseName = "Pestering"
	ReplaceDbNameInFile = $true
}
Restore-DbaDatabase @splatRestoreDbRename

        ###########

$splatRestoreDbContinue = @{
	SqlInstance = "sql01"
	Path = "\\nas\sql\sql01\mydb"
	RestoreTime = (Get-Date "2019-05-02 21:12:27")
}
Restore-DbaDatabase @splatRestoreDbContinue

        ###########

$splatRestoreDb = @{
	SqlInstance = "sql01"
	Database = "pubs"
	FilePath = "C:\temp\full.bak"
}
Backup-DbaDatabase @splatRestoreDb

# Restore to the point right before the delete was executed
$splatRestoreDbMark = @{
	SqlInstance = "sql01"
	Path = "C:\temp\full.bak"
	StopMark = "DeleteCandidates"
	StopBefore = $true
	WithReplace = $true
}
Restore-DbaDatabase @splatRestoreDbMark

        ###########

$corruption = Get-DbaSuspectPage -SqlInstance sql01 -Database pubs
$splatRestoreDbPage = @{
	SqlInstance = "sql01"
	Path = "\\nas\backups\sql\pubs.bak"
	PageRestore = $corruption
	PageRestoreTailFolder = "c:\temp"
}
Restore-DbaDatabase @splatRestoreDbPage

        ###########

$splatRestoreDbFromAzure = @{
	SqlInstance = "sql01"
	Path = "https://acmecorp.blob.core.windows.net/backups/mydb.bak"
}
Restore-DbaDatabase @splatRestoreDbFromAzure

        ###########

$stripe = "https://acmecorp.blob.core.windows.net/backups/mydb-1.bak",
"https://acmecorp.blob.core.windows.net/backups/mydb-2.bak",
"https://acmecorp.blob.core.windows.net/backups/mydb-3.bak"
$stripe | Restore-DbaDatabase -SqlInstance sql01

        ###########

$splatRestoreDbFromAzureAK = @{
	SqlInstance = "sql01"
	Path = "https://acmecorp.blob.core.windows.net/backups/mydb.bak"
	AzureCredential = "AzureAccessKey"
}
Restore-DbaDatabase @splatRestoreDbFromAzureAK

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 12
#>


New-DbaDbSnapshot -SqlInstance mssql1 -Database AdventureWorks

        ###########

Get-DbaProcess -SqlInstance mssql1 -Database AdventureWorks |
    Stop-DbaProcess
$splatRestoreSnapshot = @{
    SqlInstance = "mssql1"
    Snapshot = "AdventureWorks_20210530_071605"
}
Restore-DbaDbSnapshot @splatRestoreSnapshot

        ###########

Get-DbaDbSnapshot -SqlInstance mssql1 -Database AdventureWorks |
    Remove-DbaDbSnapshot

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 13
#>


Install-DbaInstance -Path E:\ -Version 2017

        ###########

$sqlserver = Get-ADComputer -Identity sql01
$shareserver = Get-ADComputer -Identity fs01
Set-ADComputer -Identity $shareserver
 -PrincipalsAllowedToDelegateToAccount $sqlserver
# Wait 15 minutes or execute the following, which clears system tickets
Invoke-Command -ComputerName sql01
 -ScriptBlock { KLIST PURGE -LI 0x3e7 }

        ###########

Install-DbaInstance -SqlInstance sql01 -Path \\fs01\share\sqlinstall
 -Version 2017

        ###########

$cred = Get-Credential ad\sql01engine
Get-DbaService -ComputerName sql01 | Out-GridView -Passthru |
    Update-DbaServiceAccount -ServiceCredential $cred

        ###########

Get-Help -Name Install-DbaInstance -Detailed |
Select -ExpandProperty Parameters

        ###########

$config = @{
    SQLSYSADMINACCOUNTS = "AD\SQL Prod Admins"
    SQLUSERDBDATADIR    = "S:\Mounts\Data\MSSQL14.MSSQLSERVER\MSSQL\Data"
    SQLUSERDBLOGDIR     = "S:\Mounts\Log\MSSQL14.MSSQLSERVER\MSSQL\Data"
    SQLTEMPDBDIR        = "S:\Mounts\Tempdb\MSSQL14.MSSQLSERVER\MSSQL\Data"
    SQLBACKUPDIR        = "\\nas\sqlprod\backups"
    TCPENABLED          = "1"
    NPENABLED           = "0"
    SQLSVCACCOUNT       = "NT AUTHORITY\SYSTEM"
    AGTSVCACCOUNT       = "NT AUTHORITY\SYSTEM"
    UPDATEENABLED       = "True"
    UPDATESOURCE        = "\\nas\sql\2017\update"
}
$splatInstallInst = @{
    SqlInstance = "sql01"
    Path = "E:\"
    Version = "2017"
    Feature = "Engine"
    Configuration = $config
}
Install-DbaInstance @splatInstallInst

        ###########

$config = @{
    SQLSYSADMINACCOUNTS = "ADTEST\SQL Test Admins"
    SQLUSERDBDATADIR    = "T:\Mounts\Data\MSSQL14.MSSQLSERVER\MSSQL\Data"
    SQLUSERDBLOGDIR     = "T:\Mounts\Log\MSSQL14.MSSQLSERVER\MSSQL\Data"
    SQLTEMPDBDIR        = "T:\Mounts\Tempdb\MSSQL14.MSSQLSERVER\MSSQL\Data"
    SQLBACKUPDIR        = "\\nas\sqltest\backups"
    TCPENABLED          = "1"
    NPENABLED           = "0"
}
$splatInstallInst = @{
    SqlInstance = "sqltest01"
    Path = "E:\"
    Version = "2017"
    Feature = "Engine"
    Configuration = $config
}
Install-DbaInstance @splatInstallInst

        ###########

$splatInstallInst = @{
    SqlInstance = "sql01"
    Path = "E:\"
    Version = "2017"
    ConfigurationFile = "\\nas\sqlconfigs\sharepointprod.ini"
}
Install-DbaInstance @splatInstallInst

        ###########

#Note the dollar sign here on $installparams
$installparams = @{
    Version             = 2017
    Feature             = "Engine"
    InstancePath        = "T:\Mounts\Data"
    DataPath            = "T:\Mounts\Data\MSSQL14.MSSQLSERVER\MSSQL\Data"
    LogPath             = "T:\Mounts\Log\MSSQL14.MSSQLSERVER\MSSQL\Data"
    TempPath            = "T:\Mounts\Tempdb\MSSQL14.MSSQLSERVER\MSSQL\Data"
    BackupPath          = "\\nas\sqltest\backups"
    AdminAccount        = "ADTESTDEV\SQL Test Admins"
    PerformVolumeMaintenanceTasks = $true
    Verbose             = $true
    Confirm             = $false
}
#Note the at sign here @installparams
Install-DbaInstance @installparams

        ###########

#Get all computer names from a text file
$servers = Get-Content -Path C:\temp\servers.txt
$splatUpdateInst = @{
    ComputerName = $servers
    Path = "\\nas\share\sqlserver2017-kb4498951-x64_b143d28a48204eb6.exe"
}
Update-DbaInstance @splatUpdateInst

        ###########

$splatUpdateInst = @{
    ComputerName = "sqlcluster"
    Version = "2017"
    Type = "CumulativeUpdate"
    Path = "C:\temp\sqlserver2017-kb4498951-x64_b143d28a48204eb6.exe"
    InstanceName = "sqlexpress"
}
Update-DbaInstance @splatUpdateInst

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 14
#>


Export-DbaInstance -SqlInstance sql01 -Path \\nas\backups\sql01

        ###########

Get-ChildItem .\sql01-11112019080741\



        ###########

$options = New-DbaScriptingOption
$options | Select *

        ###########

$options = New-DbaScriptingOption
$options.IncludeIfNotExists = $true

        ###########

$splatExportInstance = @{
    SqlInstance = "sql01"
    Path = "C:\git\ExportInstance"
    Exclude = "ResourceGovernor"
}
Export-DbaInstance @splatExportInstance

        ###########

Get-DbaAgentJob -SqlInstance sql01 | Select-Object -First 1 |
Export-DbaScript


        ###########

Get-DbaDbStoredProcedure -SqlInstance sql01 -Database master |
Where-Object Name -eq sp_MScleanupmergepublisher |
Export-DbaScript -Passthru

        ###########

Get-DbaAgentJob -SqlInstance sql01 | Select-Object -First 1 |
Export-DbaScript | clip

        ###########

$options = New-DbaScriptingOption
$options.includeifnotexists = $true
$splatExportScript = @{
    FilePath = "C:\git\export\sql01\audit.sql"
    ScriptingOptionsObject = $options
}
Get-DbaInstanceAudit -SqlInstance sql01 |
Export-DbaScript @splatExportScript


        ###########

$splatExportScript = @{
    FilePath = "C:\git\export\sql01\auditspec.sql"
    ScriptingOptionsObject = $options
}
Get-DbaInstanceAuditSpecification -SqlInstance sql01 |
Export-DbaScript @splatExportScript


        ###########

Get-DbaAgentJob -SqlInstance sql01 | Get-Member


        ###########

Get-DbaSpConfigure -SqlInstance sql01 | Get-Member


        ###########

$splatExportSpConf = @{
    SqlInstance = "sql01"
    FilePath = "C:\git\ExportInstance\spconfigure.sql"
}
Export-DbaSpConfigure @splatExportSpConf

        ###########

$splatExportSpConf = @{
    SqlInstance = "sql01,15591"
    SqlCredential = "sqladmin"
    Path = "C:\git\ExportInstance\spconfigure.sql"
}
Import-DbaSpConfigure @splatExportSpConf

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 15
#>


Start-DbaMigration -Source sql01 -Destination sql02 -BackupRestore
 -SharedPath \\nas\sql\migration

        ###########

$copySplat = @{
    Source        = "sql01"
    Destination   = "sql02"
    Database      = "WideWorldImporters"
    SharedPath    = "\\nas\sql\migration"
    BackupRestore = $true
}
Copy-DbaDatabase @copySplat

        ###########

$copySplat = @{
    Source        = "sql01"
    Destination   = "sql02"
    AllDatabases  = $true
    SharedPath    = "\\nas\sql\migration"
    BackupRestore = $true
}
Copy-DbaDatabase @copySplat

        ###########

$copySplat = @{
    Source           = "sql01"
    Destination      = "sql02"
    Database         = "WideWorldImporters"
    SharedPath       = "\\nas\sql\migration"
    BackupRestore    = $true
    SetSourceOffline = $true
}
Copy-DbaDatabase @copySplat

        ###########

$copySplat = @{
    Source        = "sql01"
    Destination   = "sql02"
    Database      = "WideWorldImporters"
    DetachAttach  = $true
}
Copy-DbaDatabase @copySplat

        ###########

$copySplat = @{
    Source           = "sql01"
    Destination      = "sql02"
    Database         = "WideWorldImporters"
    DetachAttach     = $true
    Reattach         = $true
}
Copy-DbaDatabase @copySplat

        ###########

$copySplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Database        = "WideWorldImporters"
    SharedPath      = "\\nas\sql\migration"
    BackupRestore   = $true
    NoRecovery      = $true
    NoCopyOnly      = $true
}
Copy-DbaDatabase @copySplat

        ###########

$diffSplat = @{
    SqlInstance = "sql01"
    Database    = "WideWorldImporters"
    Path        = "\\nas\sql\migration"
    Type        = "Differential"
}
$diff = Backup-DbaDatabase @diffSplat

# Set the source database offline
$offlineSplat = @{
    SqlInstance = "sql01"
    Database    = "WideWorldImporters"
    Offline     = $true
    Force       = $true
}
Set-DbaDbState @offlineSplat

# restore the differential and bring the destination online
$restoreSplat = @{
    SqlInstance = "sql02"
    Database    = "WideWorldImporters"
    Path        = $diff.Path
    Continue    = $true
}
Restore-DbaDatabase @restoreSplat

        ###########

$tableSplat = @{
    SqlInstance = "sql01"
    Database    = "WideWorldImporters"
    Name        = "MigrationTestTable"
    ColumnMap   = @{
        Name      = "test"
        Type      = "varchar"
        MaxLength = 20
        Nullable  = $true
    }
}
New-DbaDbTable @tableSplat

        ###########

$params = @{
      Source      = "mssql1"
      Destination = "mssql2"
      Database    = "Northwind"
      SharedPath  = "\\nas\sql\shipping"
}
Invoke-DbaDbLogShipping @params

# Then cutover
Invoke-DbaDbLogShipRecovery -SqlInstance mssql2 -Database Northwind

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 16
#>


$copyLoginSplat = @{
    Source      = "sql01"
    Destination = "sql02"
    Login       = "WWI_Owner","WWI_ReadWrite","WWI_ReadOnly",
    [CA]"ad\JaneReeves"
}
Copy-DbaLogin @copyLoginSplat


        ###########

$dbSplat = @{
        SqlInstance     = "sql02"
        ExcludeSystem   = $true
        OutVariable     = "databases"
    }
Get-DbaDatabase @dbSplat

$databases

        ###########

$copyLoginSplat = @{
        Source              = "sql01"
        Destination         = "sql02"
        ExcludeSystemLogins = $true
    }
Copy-DbaLogin @copyLoginSplat


        ###########

$copyLoginSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    ExcludeLogin    = "ad\JaneReeves"
}
Copy-DbaLogin @copyLoginSplat

        ###########

Get-DbaAgentJob -SqlInstance sql01 |
 select-Object SqlInstance, Name, Category


        ###########

$copyJobSplat = @{
        Source          = "sql01"
        Destination     = "sql02"
        Job             = 'dbatools lab job','dbatools lab job - where am I'
        DisableOnSource = $true
    }
    Copy-DbaAgentJob @copyJobSplat


        ###########

$copyJobOperatorSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Operator        = 'dba'
}
Copy-DbaAgentOperator @copyJobOperatorSplat


        ###########

$copyJobSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Job             = 'dbatools lab job','dbatools lab job - where am I'
    DisableOnSource = $true
}
Copy-DbaAgentJob @copyJobSplat


        ###########

$copyMessageSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    CustomError     = 50005
}
Copy-DbaCustomError @copyMessageSplat


        ###########

$copyAlertSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Alert           = 'FactoryApp - Custom Alert'
}
Copy-DbaAgentAlert @copyAlertSplat


        ###########

Get-DbaAgentJob -SqlInstance sql01 |
        Out-GridView -Passthru |
        Copy-DbaAgentJob -Destination dbatoolslab

        ###########

$copyLinkedServerSplat = @{
    Source      = "sql01"
    Destination = "sql02"
}
Copy-DbaLinkedServer @copyLinkedServerSplat


        ###########

Get-Command -Module dbatools -Verb Copy

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 17
#>


$params = @{
        SourceSqlInstance = "dbatoolslab\sql2017"
        DestinationSqlInstance = "dbatoolslab"
        Database = "AdventureWorks"
        SharedPath= "\\dbatoolslab\logship"
    }
Invoke-DbaDbLogShipping @params


        ###########

$params = @{
        SourceSqlInstance = "dbatoolslab\sql2017"
        DestinationSqlInstance = "dbatoolslab"
        Database = "AdventureWorks","WideWorldImporters"
        SharedPath= "\\dbatoolslab\logship"
    }
Invoke-DbaDbLogShipping @params

        ###########

Get-DbaDbLogShipError -SqlInstance dbatoolslab\sql2017, dbatoolslab |
Select-Object SqlInstance, LogTime, Message



        ###########

$logShipSplat = @{
    SqlInstance = "dbatoolslab"
    Database    = "AdventureWorks"
}
Invoke-DbaDbLogShipRecovery @logShipSplat


        ###########

$logShipSplat = @{
    SqlInstance = "dbatoolslab"
    Database    = "AdventureWorks","WideWorldImporters"
}
Invoke-DbaDbLogShipRecovery @logShipSplat

        ###########

Get-Command *wsfc* -Module dbatools


        ###########

Get-DbaWsfcNode -ComputerName sql1


        ###########

Get-DbaWsfcResource -ComputerName sql1 |
Select-Object ClusterName, Name, State, Type, OwnerGroup, OwnerNode |
Format-Table


        ###########

$agSplat = @{
        Primary     = "sql1"
        Secondary   = "sql2"
        Name        = "agpoc01"
        Database    = "AdventureWorks"
        ClusterType = "Wsfc"
        SharedPath  = "\\sql1\backup"
    }
New-DbaAvailabilityGroup @agsplat


        ###########

$sql1 = Connect-DbaInstance -SqlInstance = "sql01,15592"
 -SqlCredential sa
$sql1


        ###########

Get-DbaAvailabilityGroup -SqlInstance $sql1


        ###########

Get-DbaAgReplica -SqlInstance $sql1 | Select-Object SqlInstance,
AvailabilityGroup, Name, Role, AvailabilityMode, FailoverMode


        ###########

Get-DbaAgDatabase -SqlInstance $sql1

        ###########

Invoke-DbaAgFailover -SqlInstance $sql2 -AvailabilityGroup ACME_01

        ###########

Suspend-DbaAgDbDataMovement -SqlInstance $sql1
 -AvailabilityGroup ACME_01

        ###########

Resume-DbaAgDbDataMovement -SqlInstance $sql1
 -AvailabilityGroup ACME_01

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 18
#>


$PSDefaultParameterValues["Get-DbaDatabase:SqlInstance"] = "sql01"

        ###########

$PSDefaultParameterValues['*-Dba*:EnableException'] = $true

        ###########

$splatSetAgent = @{
  SqlInstance = "sql1"
  MaximumHistoryRows = 10000
  MaximumJobHistoryRows = 100
}
Set-DbaAgentServer @splatSetAgent

        ###########

$date = Get-Date -Format FileDateTime
Start-Transcript -Path "\\loggingserver\sql01\filelist-$date.txt"
Get-ChildItem -Path C:\
Stop-Transcript

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 19
#>


Get-DbaAgentJob -SqlInstance sql01


        ###########

Get-DbaAgentJob -SqlInstance SQL01 -Database dbachecks



        ###########

Get-DbaAgentAlert -SqlInstance SQL01


        ###########

$NotRaised = Get-Date -Date '01-01-0001 00:00:00'
Get-DbaAgentAlert -SqlInstance SQL01 |
Where-Object LastRaised -ne $NotRaised


        ###########

Get-DbaAgentOperator -SqlInstance SQL01


        ###########

$instances = "SQL01","SQL02","SQL03","SQL04","SQL05"
Find-DbaAgentJob -SqlInstance $instances -JobName *FTP*


        ###########

$splatFindAgentJob = @{
    SqlInstance = 'SQL01','SQL02','SQL03','SQL04','SQL05'
    JobName = "*Integrity*"
    IsNotScheduled = $true
}
Find-DbaAgentJob @splatFindAgentJob


        ###########

Find-DbaAgentJob -SqlInstance $instances -JobName *ftp* |
Select SqlInstance, JobName, LastRunDate, LastRunOutcome


        ###########

$midnight = [datetime]::Today
Find-DbaAgentJob -SqlInstance $instances -JobName *ftp* |
Get-DbaAgentJobHistory -StartDate $midnight


        ###########

$threeDaysAgo = [datetime]::Today.AddDays(-3)
Find-DbaAgentJob -SqlInstance sql01 |
Get-DbaAgentJobHistory -StartDate $threeDaysAgo |
ConvertTo-DbaTimeline |
Out-File -FilePath c:\temp\jobs.html -Encoding ASCII

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 20
#>


Get-Command -Module dbatools -Verb New, Set, Remove -Noun *Agent*


        ###########

New-DbaAgentJobCategory -SqlInstance SQL01 -Category PastaFactory


        ###########

$schedulesplat = @{
    FrequencyType = 'Daily'
    SqlInstance = 'SQL01'
    Schedule = 'Daily-Midnight'
    Force = $true
    StartTime = '000327'
    FrequencyInterval = 'Everyday'
}
New-DbaAgentSchedule @schedulesplat

        ###########

$schedulesplat = @{
    FrequencyType = 'Monthly'
    SqlInstance = 'SQL01'
    Schedule = 'Monthly-1st-Midnight'
    Force = $true
    StartTime = '000248'
    FrequencyInterval = 1
}
New-DbaAgentSchedule @schedulesplat

        ###########

$schedulesplat = @{
    FrequencyType = 'Weekly'
    FrequencyInterval = 'Weekdays'
    SqlInstance = 'SQL01'
    Schedule = 'WorkingWeek-Every-15-Minute'
    Force = $true
    StartTime = '070036'
    EndTime = '180000'
    FrequencySubdayInterval = 15
    FrequencySubdayType = 'Minutes'
}
New-DbaAgentSchedule @schedulesplat

        ###########

$credential = Get-Credential -Message "Enter the Username and
Password for the credential"
# Create a new SQL credential
$credsplat = @{
    SqlInstance = 'SQL01'
    SecurePassword = $credential.Password
    Name = 'FactoryProcess'
    Identity = $credential.UserName
}
New-DbaCredential @credsplat

# Create a new Proxy
$proxysplat = @{
    SqlInstance = 'SQL01'
    ProxyCredential = 'FactoryProcess'
    Name = 'FactoryProcess'
    Description = 'Proxy account to run the Factory processing using the
ad\FactoryProcesss account'
    SubSystem = 'CmdExec'
}

New-DbaAgentProxy @proxysplat

        ###########

$operatorSplat = @{
    SqlInstance = 'SQL01'
    Operator = 'DBA Team'
    EmailAddress = 'operator@dbateam.com'
}
New-DbaAgentOperator @operatorsplat


        ###########

$jobsplat = @{
    SqlInstance = 'SQL01'
    Description = 'This Job processes all of the Italian factories sales
data in the FactorySales database and creates all of the aggregrations.
Contact G Sartori for questions.'
    Category = 'PastaFactory'
    EmailOperator = 'DBA Team'
    Job = 'Factory Data Processing'
    Schedule = 'WorkingWeek-Every-3-Hours'
    EventLogLevel = 'OnFailure'
    EmailLevel = 'OnFailure'
    OwnerLogin = 'ad\FactoryProcesss'
}
New-DbaAgentJob @jobsplat


        ###########

$stepcommand = 'EXEC Process_Factory_Sales @Factory="Pasta"'
$stepsplat = @{
    StepId = 1
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Pasta Factory Data'
    OnSuccessAction = 'GoToNextStep'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

$stepcommand = 'EXEC Process_Factory_Sales @Factory="Pizza"'
$stepsplat = @{
    StepId = 2
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Pizza Factory Data'
    OnSuccessAction = 'GoToNextStep'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

$stepcommand = 'EXEC Process_Factory_Sales @Factory="Sausage"'
$stepsplat = @{
    StepId = 3
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Sausage Factory Data'
    OnSuccessAction = 'GoToNextStep'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

$stepcommand = 'EXEC Process_Factory_Sales @Factory="Sauce"'
$stepsplat = @{
    StepId = 4
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Sauce Factory Data'
    OnSuccessAction = 'QuitWithSuccess'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

        ###########

$splatGetJobStep = @{
    SqlInstance = "SQL01"
    Job = 'Factory Data Processing'
}
Get-DbaAgentJobStep @splatGetJobStep | Format-Table


        ###########

$jobname = 'Copy logins from model'
$jobsplat = @{
    SqlInstance = 'SQL02'
    Category = 'DBA-Model'
    Description = 'Copies logins from the model instance to this instance'
    OwnerLogin = 'ad\DBA'
    Job = $jobname
    EmailOperator = 'DBA Team'
    Schedule = 'Daily-Midnight'
    EventLogLevel = 'OnFailure'
    EmailLevel = 'OnFailure'
    Force = $true
}
New-DbaAgentJob @jobsplat

$command = 'powershell.exe -File C:\AgentScripts\CopyFromModel.ps1'
$stepsplat = @{
    SqlInstance = 'SQL02'
    Subsystem = 'CmdExec'
    Command = $command
    StepName = 'Copy Logins'
    Job = $jobname
    ProxyName = 'PowerShell Proxy'
    Flag = 'AppendAllCmdExecOutputToJobHistory'
}
New-DbaAgentJobStep @stepsplat

        ###########

$splatGetJob = @{
    SqlInstance = "SQL02", "SQL2017N20"
    Job = 'Factory Data Processing'
}
Get-DbaAgentJob @splatGetJob | Start-DbaAgentJob


        ###########

 Get-DbaRegisteredServer | Get-DbaRunningJob


        ###########

 Get-DbaRunningJob -SqlInstance SQL02, SQL2017N20

        ###########

$splatGetJobHist = @{
    SqlInstance = "SQL02"
    Job = 'Copy logins from model'
}
Get-DbaAgentJobHistory @splatGetJobHist


        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 21
#>


# Generate a random datetime value for the year 2021
$splatGetRandValueDT = @{
  Datatype = "datetime"
  Min = "2021-01-01"
  Max = "2021-12-31 23:59:59"
}
Get-DbaRandomizedValue @splatGetRandValueDT

# Generate a random IP value
$splatGetRandValueIP = @{
  RandomizerType = "Internet"
  RandomizerSubType = "IP"
}
Get-DbaRandomizedValue @splatGetRandValueIP

        ###########

Invoke-DbaDbPiiScan -SqlInstance mssql1 -Database AdventureWorks


        ###########

Invoke-DbaDbPiiScan -SqlInstance mssql1 -Database AdventureWorks


        ###########

Invoke-DbaDbPiiScan -SqlInstance mssql1 -Database AdventureWorks
 -SampleCount 200

        ###########

New-DbaDbMaskingConfig -SqlInstance mssql1 -Database AdventureWorks
 -Table Address -Column City, PostalCode -Path D:\temp

        ###########

Invoke-DbaDbDataMasking -SqlInstance mssql1 -Database dbatools
 -FilePath "D:\temp\mssql1.AdventureWorks.DataMaskingConfig.json"

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 22
#>


$splatExportDacPac = @{
  SqlInstance = $ProductionFactoryInstance
  Database = "Factory"
  FilePath = "C:\temp\ProdFactory_20201230.dacpac"
}
Export-DbaDacPackage @splatExportDacPac

        ###########

$splatExportDacPac = @{
  SqlInstance = $ProductionFactoryInstance
  Database    = "Factory"
  Path        = "C:\temp\ProdFactory_20201230.dacpac"
}
Export-DbaDacPackage @splatExportDacPac

        ###########

$splatPublishDacPac = @{
  SqlInstance = $developercontainer
  Database = "FactoryIssue"
  Path     = "C:\temp\ProdFactory_20201230.dacpac"
}
Publish-DbaDacPackage @splatPublishDacPac

        ###########

$dacoptions  = New-DbaDacOption -Type DACPAC -Action Publish
$dacoptions.DeployOptions.ExcludeObjectTypes = "Users","RoleMembership"
 ,"Logins"
$splatPublishDacPacNoUsers = @{
  SqlInstance = $developercontainer
  Database = "FactoryIssue"
  FilePath = "C:\temp\ProdFactory_20201230.dacpac"
  DacOption = $dacoptions
}
Publish-DbaDacPackage @splatPublishDacPacNoUsers

        ###########

$splatNewDacProfile = @{
  SqlInstance = "sql01"
  Database = "Factory"
  Path = "c:\temp"
  PublishOptions = @{
      IgnoreUserLoginMappings = $true
      IgnorePermissions = $true
      ExcludeObjectTypes = 'Users;RoleMembership;Logins'
      ExcludeLogins = $true
      ExcludeUsers = $true
      IgnoreUserSettingsObjects = $true
  }
}
New-DbaDacProfile @splatNewDacProfile

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 23
#>


Get-DbaTrace -SqlInstance sql01, sql02, sql03

        ###########

Get-DbaRegisteredServer | Get-DbaTrace


        ###########

Get-DbaRegisteredServer | Get-DbaTrace |
    Out-GridView -PassThru | Start-DbaTrace

        ###########

Get-DbaTrace -SqlInstance sql2014 | Where-Object Id -eq 1 |
    ConvertTo-DbaXESession -Name 'Converted Default Trace' |
    Start-DbaXESession


        ###########

Find-DbaCommand -Tag ExtendedEvent

        ###########

Get-DbaRegServer | Get-DbaXESession

        ###########

Get-DbaXESession -SqlInstance mssql1 -Session telemetry_xevents


        ###########

Get-DbaXESessionTemplate


        ###########

Get-DbaXESessionTemplate -Template 'Deprecated Feature Usage' |
    Import-DbaXESessionTemplate -SqlInstance mssql1 |
    Start-DbaXESession


        ###########

 Get-ChildItem 'C:\temp\Login Tracker.xml' |
     Import-DbaXESessionTemplate -SqlInstance mssql1


        ###########

Start-DbaXESession -SqlInstance mssql1 -Session "Query Timeouts"


        ###########

Stop-DbaXESession -SqlInstance mssql1 -Session "Query Timeouts"


        ###########

Start-DbaXESession -SqlInstance mssql1 -Session 'Query Timeouts'
 -StopAt (Get-Date).AddMinutes(30)

        ###########

Watch-DbaXESession -SqlInstance mssql1 -Session QuickSessionStandard |
    Where-Object client_app_name -match dbatools


        ###########

Read-DbaXEFile -Path C:\temp\deadocks.xel

        ###########

$splatCopyXESession = @{
    Source = "mssql1"
    Destination = "mssql2", "mssql3"
    XeSession = "Login Tracker"
}
Copy-DbaXESession @splatCopyXESession

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 24
#>


$splatCert = @{
    ComputerName = "sql1"
    Dns = "sql1.ad.local", "sql1"
}
New-DbaComputerCertificate $splatCert


        ###########

$splatCSR = @{
    ComputerName = "sql1"
    Dns = "sql1.ad.local", "sql1"
}
New-DbaComputerCertificateSigningRequest $splatCSR


        ###########

Get-DbaComputerCertificate -ComputerName sql1


        ###########

$splatSetCertificate = @{
    SqlInstance = "sql1"
    Thumbprint = "1245FB1ACBCA44D3EE9640F81B6BA14A92F3D6E2"
}
Set-DbaNetworkCertificate @splatSetCertificate

        ###########

Get-DbaComputerCertificate | Out-GridView -PassThru |
    Set-DbaNetworkCertificate -SqlInstance sql1

        ###########

Enable-DbaForceNetworkEncryption -SqlInstance sql1

        ###########

Set-DbaExtendedProtection -SqlInstance sql1 -Value Required

        ###########

Test-DbaSpn -ComputerName sql1


        ###########

Test-DbaSpn -ComputerName sql1 |
    Where-Object isSet -eq $false  |
    Set-DbaSpn

        ###########

Enable-DbaHideInstance -SqlInstance sql1

        ###########

Connect-DbaInstance -SqlInstance sql01:12345
# This also works but note you must use single or double quotes
Connect-DbaInstance -SqlInstance "sql01,12345"
# Or use a colon without quotes and we'll translate it for you
Connect-DbaInstance -SqlInstance sql01:12345

        ###########

$masterkeypass = (Get-Credential nobody).Password
$certbackuppass = (Get-Credential nobody).Password
$splatEncrypt = @{
        SqlInstance             = "sql1"
        MasterKeySecurePassword = $masterkeypass
        BackupSecurePassword    = $certbackuppass
        BackupPath              = "/tmp"
        AllUserDatabases        = $true
    }
Start-DbaDbEncryption @splatEncrypt

        ###########

$masterkeypass = (Get-Credential nobody).Password
$certbackuppass = (Get-Credential nobdody).Password
$splatdbEncrypt = @{
        MasterKeySecurePassword = $masterkeypass
        BackupSecurePassword    = $certbackuppass
        BackupPath              = "/tmp"
    }
Get-DbaDatabase -SqlInstance sql1 -Database db1, db2, db3 |
    Start-DbaDbEncryption @splatdbEncrypt

        ###########

Stop-DbaDbEncryption -SqlInstance sql1

        ###########

Disable-DbaDbEncryption -SqlInstance sql1 -Database db1, db2, db3

        ###########

$securepass = (Get-Credential doesntmatter).Password
$params = @{
    SqlInstance = "sql1"
    Database = "master"
    SecurePassword = $securepass
}
New-DbaDbMasterKey @params
Backup-DbaDbMasterKey @params

        ###########

$splatCert = @{
    SqlInstance = "sql1"
    Database = "master"
}
New-DbaDbCertificate @splatCert -Name BackupCert

# Just add to the previous splat!
$splatCert.EncryptionPassword = $securepass
Backup-DbaDbCertificate @splatCert -Certificate BackupCert

        ###########

$backupparam = @{
    SqlInstance = "sql1"
    Database = "master"
    FilePath = "c:\backups"
    EncryptionAlgorithm = "AES192"
    EncryptionCertificate = "BackupCert"
}

Backup-DbaDatabase @backupparam

        ###########

$splatReadBackup = @{
    SqlInstance = "sql1"
    FilePath = "C:\backups\myEncryptedDatabaseBackup.bak"
}
Test-DbaBackupEncypted @splatReadBackup


        ###########

$splatReadBackup = @{
    SqlInstance = "sql1"
    FilePath = "S:\backups\myDatabaseBackup.bak"
}
Test-DbaBackupEncypted @splatReadBackup


        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 25
#>


Get-DbaSpConfigure -SqlInstance mssql1 -Name DefaultBackupCompression

Set-DbaSpConfigure -SqlInstance mssql1 -Name DefaultBackupCompression
 -Value 1

        ###########

Get-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks

        ###########

Get-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks


        ###########

$splatProperties = @{
    Property =
        @{N="Data Compression Type"; E={$_.Name}},
        @{N="Number Of Objects"; E={$_.Count}},
        @{l='SizeMB'; e={'{0:n0}' -f (($_.Group.SizeCurrent |
        Measure-Object -Sum).Sum/1MB)}}
}

Get-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks |
    Group-Object DataCompression |
    Select-Object @splatProperties

        ###########

Get-DbaDbCompression -SqlInstance mssql1 -ExcludeDatabase TestDatabase

        ###########

Test-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks

        ###########

Set-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks

        ###########

$splatTestCompression = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
}
$compressObjects = Test-DbaDbCompression @splatTestCompression

## Review the results in $compressObjects
$splatSetCompression = @{
    SqlInstance = "mssql1"
    InputObject = $compressObjects
}
Set-DbaDbCompression @splatSetCompression

        ###########

$splatSetCompressionPage = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
    CompressionType = "PAGE"
}
Set-DbaDbCompression @splatSetCompressionPage

$splatSetCompressionRow = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
    Table = "Employee"
    CompressionType = "ROW"
}
Set-DbaDbCompression @splatSetCompressionRow

        ###########

$splatSetCompressionPage = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
    CompressionType = "NONE"
}
Set-DbaDbCompression @splatSetCompressionPage

        ###########

Set-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks
  -MaxRunTime 60 -PercentCompression 25

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 26
#>


Install-Module dbachecks -Scope CurrentUser

        ###########

Install-Module Pester -RequiredVersion 4.10.1 -Scope CurrentUser

        ###########

Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastFullBackup

        ###########

Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastFullBackup

        ###########

Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastGoodCheckDb, MaxMemory

        ###########

Get-DbcCheck | Select-Object Group, UniqueTag


        ###########

Get-DbcCheck -Tag LastFullBackup | Format-List


        ###########

(Get-DbcCheck -Tag LastFullBackup).config.Split(' ')

        ###########

Get-DbcConfig -Name policy.backup.fullmaxdays


        ###########

Set-DbcConfig -Name policy.backup.fullmaxdays -Value 7


        ###########

Set-DbcConfig -Name policy.backup.fullmaxdays -Value 7
Set-DbcConfig -Name policy.backup.diffmaxhours -Value 24
Set-DbcConfig -Name policy.backup.logmaxminutes -Value 240

Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastBackup -Show Fails

        ###########

Set-DbcConfig -Name policy.backup.fullmaxdays -Value 7
Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastFullBackup

        ###########

$splatInvokeCheck = @{
  SqlInstance = "dbatoolslab"
  Check = "LastBackup"
  Passthru = $true
}
Invoke-DbcCheck @splatInvokeCheck |
Convert-DbcResult -Label dbatoolsMol |
Write-DbcTable -SqlInstance dbatoolslab -Database DatabaseAdmin

        ###########

$splatInvokeCheck = @{
  SqlInstance = "dbatoolslab"
  Check = "LastBackup"
  Passthru = $true
}
Invoke-DbcCheck @splatInvokeCheck |
Convert-DbcResult -Label dbatoolsMol |
Write-DbcTable -SqlInstance dbatoolslab -Database DatabaseAdmin

        ###########

Start-DbcPowerBi -FromDatabase

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 27
#>


$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  SqlCredential = "me@mydomain.onmicrosoft.com"
}
$server = Connect-DbaInstance @params
Invoke-DbaQuery -SqlInstance $server -Query "select 1 as test"

        ###########

$params = @{
  Type = "RenewableServicePrincipal"
  Tenant = "mytenant.onmicrosoft.com"
  Credential = "ee590f55-9b2b-55d4-8bca-38ab123db670"
}
$token = New-DbaAzAccessToken @params
$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  AccessToken = $token
}
$server = Connect-DbaInstance @params
Invoke-DbaQuery -SqlInstance $server -Query "select 1 as test"

        ###########

$azureAccount = Connect-AzAccount
$azureToken = Get-AzAccessToken -ResourceUrl
 https://database.windows.net

$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  AccessToken = $azuretoken
}

$server = Connect-DbaInstance @params
Invoke-DbaQuery -SqlInstance $server -Query "select 1 as test"

        ###########

$params = @{
  Type = "RenewableServicePrincipal"
  Tenant = "mytenant.onmicrosoft.com"
  Credential = "ee590f55-9b2b-55d4-8bca-38ab123db670"
}
$token = New-DbaAzAccessToken @params
$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  AccessToken = $token
}
$server = Connect-DbaInstance @params
$params = @{
  SqlInstance = $server
  Database = "mydb"
  Path = "C:\temp\customers.csv"
  AutoCreateTable = $true
}
Import-DbaCsv @params
$params = @{
  SqlInstance = $server
  Database = "mydb"
  Query = "select * from customers"
}
Invoke-DbaQuery @params

        ###########

<#
    This is the code from dbatools in a Month of Lunches chapter 28
#>


Get-DbatoolsConfig -Module Logging |
Select-Object FullName, Description


        ###########

Get-DbatoolsConfig -FullName logging.maxlogfileage



        ###########

Get-DbatoolsConfigValue -FullName sql.connection.timeout

        ###########

Get-DbatoolsConfig | Reset-DbatoolsConfig

        ###########

Get-DbatoolsConfigValue -FullName path.dbatoolslogpath -OutVariable dir
Get-ChildItem $dir


        ###########

