<######################################
dbatools-lab - 01_Install_Lab.ps1
#######################################
This script will install two instances of SQL Server:
- Default instance of SQL Server 2019 Developer edition
 - Named instance, sql2017l, of SQL Server 2017 Developer edition
#>

# Read in our configuration file - any values to be changed are in here.
$config = Import-PowerShellDataFile -Path .\Config\Config.psd1

# Install SQL Server 2019 as the default instance
Install-DbaInstance -Version 2019 -SqlInstance dbatoolslab -Feature Engine -Path (Join-Path $config.InstallMediaPath '2019') -AuthenticationMode Mixed

# Install SQL Server 2017 as a named instance
Install-DbaInstance -Version 2017 -SqlInstance dbatoolslab\sql2017 -Feature Engine -Path (Join-Path $config.InstallMediaPath '2017') -AuthenticationMode Mixed

# Add permissions for the engine service accounts to backup directory, you can get the accounts with
Get-DbaService -ComputerName dbatoolslab -Type Engine