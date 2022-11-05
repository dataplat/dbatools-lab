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

    
Install-DbaInstance -Version 2019 -SqlInstance dbatoolslab
    
        ###########
        
Install-DbaInstance -Version 2017
    
        ###########
        
Connect-DbaInstance -SqlInstance dbatoolslab

        ###########
        
Find-DbaInstance -ComputerName localhost

ComputerName InstanceName Port  Availability Confidence ScanTypes

        ###########
        
Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017
Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017

        ###########
        
$pw = (Get-Credential wejustneedthepassword).Password
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw
New-DbaLogin -SqlInstance dbatoolslab\sql2017 -Password $pw

# Create database users
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_ReadOnly
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_ReadWrite
New-DbaDbUser -SqlInstance dbatoolslab\sql2017 -Login WWI_Owner

# Add database role members
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017
Add-DbaDbRoleMember -SqlInstance dbatoolslab\sql2017

# Create some SQL Server Agent jobs
$job = New-DbaAgentJob -SqlInstance dbatoolslab\sql2017
New-DbaAgentJobStep -SqlInstance dbatoolslab\sql2017 -Job $Job.Name

# add second job
$job = New-DbaAgentJob -SqlInstance dbatoolslab\sql2017
New-DbaAgentJobStep -SqlInstance dbatoolslab\sql2017 -Job $Job.Name

        ###########
        
Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017
Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017

        ###########
        
# create a shared network
docker network create localnet

# Expose engines and setup shared path for migrations
docker run -p 1433:1433  --volume shared:/shared:z --name mssql1
docker run -p 14333:1433 --volume shared:/shared:z --name mssql2

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
        