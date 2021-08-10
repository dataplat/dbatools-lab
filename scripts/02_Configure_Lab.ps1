<######################################
dbatools-lab - 02_Configure_Lab.ps1
#######################################
This script will configure our SQL Server instances
 - Restore the AdventureWorks and WideWorldImporters databases to the 2017 named instance
 - Create a few SQL Logins and SQL Agent jobs
 - Change a couple of sp_configure settings
#>

# Read in our configuration file - any values to be changed are in here.
    $config = Import-PowerShellDataFile -Path .\Config\Config.psd1

# Restore WideWorldImporters & AdventureWorks2017 to 2017 instance
    Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017 -Path (Join-Path $config.BackupPath 'WideWorldImporters-Full.bak')
    Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017 -Path (Join-Path $config.BackupPath 'AdventureWorks2017-Full.bak')

# Create some SQL Logins
    $loginSplat = @{
        SqlInstance = 'dbatoolslab\sql2017'
        Password    = (ConvertTo-SecureString -String 'N0t@SecureP@ssw0rd!' -Force -AsPlainText)
    }
    New-DbaLogin @loginSplat -Login WWI_ReadOnly
    New-DbaLogin @loginSplat -Login WWI_ReadWrite
    New-DbaLogin @loginSplat -Login WWI_Owner

    $userSplat = @{
        SqlInstance = 'dbatoolslab\sql2017'
        Database    = 'WideWorldImporters'
        Confirm     = $false
    }
    New-DbaDbUser @userSplat -Login WWI_ReadOnly
    New-DbaDbUser @userSplat -Login WWI_ReadWrite
    New-DbaDbUser @userSplat -Login WWI_Owner

    Add-DbaDbRoleMember @userSplat -User WWI_Readonly -Role db_datareader 
    Add-DbaDbRoleMember @userSplat -User WWI_ReadWrite -Role db_datawriter
    Add-DbaDbRoleMember @userSplat -User WWI_Owner -Role db_owner

# Create some SQL Agent Jobs
    $jobSplat = @{
        SqlInstance = 'dbatoolslab\sql2017'
        Job         = 'dbatools lab job'

    }
    New-DbaAgentJob @jobSplat -Description 'Creating a test job for our lab'
    New-DbaAgentJobStep @jobSplat -StepName 'Step 1: Select statement' -Subsystem TransactSQL -Command 'Select 1'

    $jobSplat = @{
        SqlInstance = 'dbatoolslab\sql2017'
        Job         = 'dbatools lab - where am I'

    }
    New-DbaAgentJob @jobSplat -Description 'Creating another test job for our lab'
    New-DbaAgentJobStep @jobSplat -StepName 'Step 1: Select servername' -Subsystem TransactSQL -Command 'Select @@ServerName'

# Change a couple of sp_configure settings
    Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017 -Name RemoteDacConnectionsEnabled -Value 1
    Set-DbaSpConfigure -SqlInstance dbatoolslab\sql2017 -Name CostThresholdForParallelism -Value 10