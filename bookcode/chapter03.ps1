 <#
    This is the code from dbatools in a Month of Lunches chapter 03

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

    
Install-DbaInstance -Version 2019 -SqlInstance dbatoolslab -Feature Engine -Path Z:\2019 -AuthenticationMode Mixed
    
        ###########
        
Install-DbaInstance -Version 2017
    
        ###########
        
Connect-DbaInstance -SqlInstance dbatoolslab

        ###########
        
Find-DbaInstance -ComputerName localhost

ComputerName InstanceName Port  Availability Confidence ScanTypes

        ###########
        
Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017 -Path C:\dbatoolslab\Backup\WideWorldImporters-Full.bak
Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017 -Path C:\dbatoolslab\Backup\AdventureWorks2017-Full.bak

        ###########
        
$pw = (Get-Credential wejustneedthepassword).Password
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw -Login WWI_ReadOnly
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw -Login WWI_ReadWrite
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw -Login WWI_Owner

# Create database users
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_ReadOnly -Database WideWorldImporters -Confirm:$false
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_ReadWrite -Database WideWorldImporters -Confirm:$false
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_Owner -Database WideWorldImporters -Confirm:$false

# Add database role members
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017 -Database WideWorldImporters -User WWI_Readonly -Role db_datareader
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017 -Database WideWorldImporters -User WWI_ReadWrite -Role db_datawriter
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017 -Database WideWorldImporters -User WWI_Owner -Role db_owner

# Create some SQL Server Agent jobs
$job = New-DbaAgentJob -SqlInstance dbatoolslab\sql2017 -Job 'dbatools lab job' -Description 'Creating a test job for our lab'
New-DbaAgentJobStep -SqlInstance dbatoolslab\sql2017 -Job $Job.Name -StepName 'Step 1: Select statement' -Subsystem TransactSQL -Command 'Select 1'

# add second job
$job = New-DbaAgentJob -SqlInstance dbatoolslab\sql2017 -Job 'dbatools lab - where am I' -Description 'Creating test2 job for our lab'
New-DbaAgentJobStep -SqlInstance dbatoolslab\sql2017 -Job $Job.Name -StepName 'Step 1: Select servername' -Subsystem TransactSQL -Command 'Select @@ServerName'

        ###########
        
Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017 -Name RemoteDacConnectionsEnabled -Value 1
Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017 -Name CostThresholdForParallelism -Value 10

        ###########
        
# create a shared network
docker network create localnet

# Expose engines and setup shared path for migrations
docker run -p 1433:1433  --volume shared:/shared:z --name mssql1 --hostname mssql1 --network localnet -d dbatools/sqlinstance
docker run -p 14333:1433 --volume shared:/shared:z --name mssql2 --hostname mssql2 --network localnet -d dbatools/sqlinstance2

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
        
