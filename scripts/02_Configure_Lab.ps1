<######################################
dbatools-lab - 02_Configure_Lab.ps1
#######################################
This script will configure our SQL Server instances
 - Restore the WideWorldImporters database to the 2017 named instance
 - TODO Create stuff?

#>

# Read in our configuration file - any values to be changed are in here.
$config = Import-PowerShellDataFile -Path .\Config\Config.psd1

# Restore WideWorldImporters backup to 2017 instance
Restore-DbaDatabase -SqlInstance dbatoolslab\sql2017 -Path (Join-Path $config.BackupPath 'WideWorldImporters.bak')