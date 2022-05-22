 <#
    This is the code from dbatools in a Month of Lunches chapter 04

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
        
$instances = (Invoke-DbaQuery -SqlInstance ConfigInstance  -Database DbaConfig -Query "SELECT InstanceName FROM  Config.Instances C JOIN Project.People P ON C.InstanceID =  P.InstanceID WHERE P.Name = 'Shawn Melton'").InstanceName
$instances | Connect-DbaInstance

        ###########
        
$instances = Invoke-DbaQuery -SqlInstance ConfigInstance  -Database DbaConfig -Query "SELECT InstanceName FROM  Config.Instances C JOIN Project.People P ON C.InstanceID =  P.InstanceID WHERE P.Name = 'Shawn Melton'" | Select-Object  -ExpandProperty InstanceName
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
$securepassword = ConvertTo-SecureString (Invoke-DbaQuery -SqlInstance VerySecure -Database NoPasswordsHere -Query $query) -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ( "AD\dbatools", $securepassword)
Test-DbaConnection -SqlInstance $Env:ComputerName -SqlCredential $cred

        ###########
        
Connect-DbaInstance -SqlInstance SQLDEV01 -SqlCredential ad\sander.stad

        ###########
        
$server = Connect-DbaInstance -SqlInstance dbatools.database.windows .net -SqlCredential dbatools@mycorp.onmicrosoft.com -Database inventory
# Use server connection to query the database using our query command,  Invoke-DbaQuery
Invoke-DbaQuery -SqlInstance $server -Database inventory -Query  "select name from instances"

        ###########
        
Connect-DbaInstance -SqlInstance dbatools.database.windows.net  -SqlCredential 52c1fbca-24ed-4353-bbf1-6dd52f535027 -Tenant  ec46e088-2707-4b0a-ab0d-dee0b52fc5c8 -Database inventory

Name                                Product Version   Platform IsAzure IsClustered ConnectedAs

        ###########
        
$appcred = Get-Credential 52c1fbca-24ed-4353-bbf1-6dd52f535027

# Establish a connection
$server = Connect-DbaInstance -SqlInstance dbatools.database.windows .net -Database inventory -SqlCredential $appcred -Tenant  6b73c0ef-114d-43ad-94c9-85a4a82cde8b

# Now that the connection is established, use it to perform a query
Invoke-DbaQuery -SqlInstance $server -Database dbatools -Query  "SELECT Name FROM sys.objects"

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
        
