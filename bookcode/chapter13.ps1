 <#
    This is the code from dbatools in a Month of Lunches chapter 13

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

    
Install-DbaInstance -Path E:\ -Version 2017
    
        ###########
        
$sqlserver = Get-ADComputer -Identity sql01
$shareserver = Get-ADComputer -Identity fs01
Set-ADComputer -Identity $shareserver -PrincipalsAllowedToDelegateToAccount $sqlserver
# Wait 15 minutes or execute the following, which clears system tickets
Invoke-Command -ComputerName sql01 -ScriptBlock { KLIST PURGE -LI 0x3e7 }

        ###########
        
Install-DbaInstance -SqlInstance sql01 -Path \\fs01\share\sqlinstall -Version 2017
    
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
        
