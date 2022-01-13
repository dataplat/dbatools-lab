BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
    $tests = foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -Verbose
        $content = $content -replace ([Regex]::Escape('PS> Restore-DbaDbSnapshot @splatRestoreSnapshot')), 'PS> Restore-DbaDbSnapshot @splatRestoreSnapshot 
' -replace ([Regex]::Escape('PS> $databases <2>')),'PS> $databases
' -replace ([Regex]::Escape('WARNING')),'
WARNING' -replace ([Regex]::Escape('----')),'
----' -replace ([Regex]::Escape('PS> $Env:PSModulePath -Split ";"')),'PS> $Env:PSModulePath -Split ";"
' -replace ([Regex]::Escape('PS> docker ps')),'PS> docker ps
' -replace ([Regex]::Escape('
PS> Add-DbaDbRoleMember @userSplat -User WWI_Readonly -Role db_datareader')),'PS> Add-DbaDbRoleMember @userSplat -User WWI_Readonly -Role db_datareader' -replace ([Regex]::Escape('PS> Import-DbaSpConfigure @splatExportSpConf')),'PS> Import-DbaSpConfigure @splatExportSpConf
' -replace 'PS> \$diff = Backup-DbaDatabase @diffSplat
', 'PS> $diff = Backup-DbaDatabase @diffSplat' -replace 'PS> Set-DbaDbState @offlineSplat
', 'PS> Set-DbaDbState @offlineSplat' -replace '
PS> New-DbaDbUser @userSplat -Login WWI_ReadOnly', 'PS> New-DbaDbUser @userSplat -Login WWI_ReadOnly' -replace '
PS> New-DbaLogin @loginSplat -Login WWI_ReadOnly','PS> New-DbaLogin @loginSplat -Login WWI_ReadOnly'

        $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
        $codelines = $reg.Value -replace '<\d>','' -replace ([Regex]::Escape('Test-DbaConnection -SqlInstance $Env:ComputerName')),'Test-DbaConnection -SqlInstance ''localhost,15592''' -replace 'PageRestoreTailFolder = "c:\\temp"','PageRestoreTailFolder = "/var/opt/mssql/backups"' -replace '\\\\nas\\sql01\\mydb01.bak','/var/opt/mssql/backups/pubs.bak' -replace 'PS> ', '' -replace '(\n)\[CA\]', ' ' -replace '(\n)\s+\[CA\]', ' ' -replace '----', '' -replace '(-SqlInstance\s\w*)', '-SqlInstance ''localhost,15592''' -replace '(-Database\s\w*)', '-Database AdventureWorks2017' -replace '(Database\s+=\s"\w*")', 'Database = "AdventureWorks2017"' -replace '(SqlInstance\s+=\s"\w*")', 'SqlInstance = ''localhost,15592''' -replace  '\\sql2017' , '' -replace  '\\SHAREPOINT' , '' -replace '\\\\nas\\sql\\backups\\sql01', '/var/opt/mssql/backups'  -replace '\\\\nas\\sql\\sql01\\mydb', '/var/opt/mssql/backups' -replace 'C:\\dbatoolslab\\Backup\\', '/var/opt/mssql/backups/' -replace '\\\\nas\\sqlbackups', '/var/opt/mssql/backups' -replace '\\\\nas\\sql\\backups', '/var/opt/mssql/backups' -replace '(SqlInstance\s+=\s"dbatoolslab")', 'SqlInstance = ''localhost,15592''' -replace '"PRODSQL01", "PRODSQL02", "PRODSQL03\\ShoeFactory"', '''localhost,15592'',''localhost,15593''' -replace 'PRODSQL02, PRODSQL03\\ShoeFactory', '"localhost,15593"' -replace 'sql2005', '"localhost,15593"' -replace '(\n)-Table',' -Table' -replace '''localhost,15592''$instances', '$instances' -replace 'clip','Select *' -replace 'SQLDEV02,15591',"'localhost,15593'" -replace '"sql01"',"'localhost,15593'" -replace 'sql01',"'localhost,15593'" -replace 'sql2008',"'localhost,15592'" -replace 'DestinationDatabase = ''WIP''','DestinationDatabase = ''tempdb'''  -replace '(\n)-Database',' -Database' -replace '//JP','#//JP' -replace '(\n)        FROM \[AzureVMs\]',' FROM AzureVMs' -replace '(\n)        ,\[StatusCode\]',', StatusCode ' -replace '(\n)        ,\[PowerState\]', ', PowerState ' -replace '(\n)        ,\[Location\]',', Location ' -replace '''localhost,15592''\$sqlconfiginstance', '''localhost,15592'' ' -replace 'Path "C:\\temp"', 'Path = "/tmp/"'  -replace 'Find-DbaBackup -Path /var/opt/mssql/backups','Find-DbaBackup -Path /tmp/backups' -replace '(\n\tSourceServer)', 'SourceServer' -replace '(\n\tTestServer)','TestServer' -replace '(\n\t\[Database\])' , 'Database' -replace '(\n\tFileExists)' , 'FileExists' -replace '(\n\tSize)' , 'Size' -replace '(\n\tRestoreResult)' , 'RestoreResult' -replace '(\n\tDbccResult)' , 'DbccResult' -replace '(\n\tRestoreStart)' , 'RestoreStart' -replace '(\n\tRestoreEnd)' , 'RestoreEnd' -replace '(\n\tRestoreElapsed)' , 'RestoreElapsed' -replace '(\n\tDbccStart)' , 'DbccStart' -replace '(\n\tDbccEnd)' , 'DbccEnd' -replace '(\n\tDbccElapsed)' , 'DbccElapsed' -replace '(\n\tBackupDates)' , 'BackupDates' -replace '(\n\tBackupFiles)' , 'BackupFiles' -replace '-Path S:\\backups\\pubs.bak', '-Path /var/opt/mssql/backups/pubs.bak  -WithReplace -Confirm:$false' -replace 'C:\\temp\\sql\\full.bak','/var/opt/mssql/backups/pubs.bak' -replace 'C:\\temp\\full.bak','/var/opt/mssql/backups/pubs.bak' -replace 'C:\\temp\\sql\\trans.trn','/var/opt/mssql/backups/pubs.trn' -replace 'C:\\temp\\sql' , '/var/opt/mssql/backups'  -replace 'New-Item -Path ''/var/opt/mssql/backups''','# New-Item -Path ''/var/opt/mssql/backups''' -replace 'ExcludeDatabase = "AdventureWorks2017"', 'ExcludeDatabase = "tempdb", "NorthWind", "AdventureWorks2017","WideWorldImporters"'  -replace 'diff.bak','pubsdiff.bak' -replace 'trans.trn','pubs.trn'  -replace 'splatRestoreDbContinue','splatRestoreDb' -replace 'DestinationDataDirectory = "D:\\data"','WithReplace = $true;DestinationDataDirectory = "/var/opt/mssql/data"' -replace 'DestinationLogDirectory = "L:\\log"','DestinationLogDirectory = "/var/opt/mssql/data"' -replace 'NoRecovery = ','WithReplace = $true;NoRecovery = ' -replace ([regex]::Escape('Restore-DbaDatabase @splatRestoreDb -Path /var/opt/mssql/backups\pubsdiff.bak')),'Restore-DbaDatabase @splatRestoreDb -Path /var/opt/mssql/backups\pubsdiff.bak -Continue' -replace ([regex]::Escape('RestoreTime = (Get-Date "2019-05-02 21:12:27")')),'RestoreTime = (Get-Date "2019-05-02 21:12:27") ; Continue = $true;WarningAction = ''SilentlyContinue''' -replace ([regex]::Escape('Path = "C:\temp')), 'Path = "/var/opt/mssql/backups' -replace 'from Databases', 'from sys.tables' -replace 'Get-DbaBuildReference','Get-DbaBuildReference -WarningAction SilentlyContinue'
        $codelines = $codelines -replace '\s+Database = "AdventureWorks2017"
\s+Path = "/var/opt/mssql/backups/pubs.bak"
}
Backup-DbaDatabase @splatRestoreDb','
Database = "pubs"
          FilePath = "/var/opt/mssql/backups/pubs.bak"
    }
    Backup-DbaDatabase @splatRestoreDb' -replace ([Regex]::Escape('-Path \\nas\backups\''localhost,15593''')),'-Path /tmp/backups/container' -replace ([Regex]::Escape('C:\git\ExportInstance')),'/tmp/backups/container' -replace ([Regex]::Escape('SqlInstance = "''localhost,15593'',15591"')),'SqlInstance = "localhost,15593"' -replace ([Regex]::Escape('
SqlCredential = "sqladmin"')),'' -replace ([Regex]::Escape('Export-DbaInstance -SqlInstance ''localhost,15592'' -Path /tmp/backups/container')),'Export-DbaInstance -SqlInstance ''localhost,15592'' -Path /tmp/backups/container -Exclude Credentials,LinkedServers,ReplicationSettings' -replace ([Regex]::Escape('Exclude = "ResourceGovernor"')),'Exclude = ''ResourceGovernor'',''Credentials'',''LinkedServers'',''ReplicationSettings''' -replace ([regex]::Escape('    FilePath = "/tmp/backups/container\spconfigure.sql"
}
Import-DbaSpConfigure @splatExportSpConf')),'    Path = "/tmp/backups/container\spconfigure.sql"
}
Import-DbaSpConfigure @splatExportSpConf -WarningAction SilentlyContinue' -replace 'Source\s+= "dbatoolslab"','Source      = "localhost,15592"' -replace 'Destination\s+= "dbatoolslab"','Destination      = "localhost,15593"'-replace '-Destination dbatoolslab','-Destination ''localhost,15593''' -replace ([Regex]::Escape('SharedPath  = "\\dbatoolslab\Backup"')),'SharedPath  = "/var/opt/mssql/backups/shared"' -replace 'Path\s+= "C:\\dbatoolslab\\Backup"','Path  = "/var/opt/mssql/backups"' -replace 'Out-GridView -Passthru', 'Select -first 2 ' -replace  '\$restoreSplat = @{
\s+SqlInstance = ''localhost,15592''' , '$restoreSplat = @{
SqlInstance = ''localhost,15593''
WarningAction = ''SilentlyContinue'''  -replace  '\$tableSplat = @{
    SqlInstance = ''localhost,15592''' , '$tableSplat = @{
        SqlInstance = ''localhost,15593''' -replace '"dockersql1,14333"','''localhost,15593''' -replace 'Path = "/var/opt/mssql/backups"
\s+OutVariable = file', 'Path = "/tmp/"
  OutVariable = file' -replace 'Copy-DbaDatabase @copySplat','Copy-DbaDatabase @copySplat -WarningAction SilentlyContinue'

        [PSCustomObject]@{
            FileName = $file.Name
            Code     = $codelines
        }
    }
}

Describe "Checking the file <_.Name> code works as intended" -ForEach $files[16] {
    $filename = $_.Name

    It "The code <_> should not error"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }).Code {
        $code = $_
        # some code that should not be run on containers or on linux or are asking for input
        $exclusions = @(
            'Invoke-Command -ComputerName',
            'Install-DbaInstance',
            'Get-Credential',
            'Test-DbaConnection',
            '-SqlCredential sa',
            'Config.Instances',
            'sqldev04',
            '57689',
            'devadmin',
            'sqladmin',
            'ad\sander.stad',
            'windows.net',
            'Connect-DbaInstance -SqlInstance ''localhost,15592''$instances',
            '''localhost,15592''$server',
            'Get-DbaService',
            'ComputerName -SqlCredential $cred',
            'csv',
            'SQL01',
            'Invoke-DbaQuery -SqlInstance ''localhost,15592'' -Database AdventureWorks2017 -Query $query',
            'Connect-AzAccount',
            'Get-AzVM',
            'AzureVMs',
            'query = "SELECT \[Name\]',
            'd1f7bc2b6077',
            'Copy-DbaDbTableData',
            'serverlist.txt',
            'Get-ADComputer',
            'Find-DbaInstance -DiscoveryType',
            'Find-DbaInstance @splatFindInstance',
            'System.Data.Sql.SqlDataSourceEnumerator',
            'cd "C:\Program',
            'Get-DbaFeature',
            'Get-DbaComputerSystem',
            'Get-DbaOperatingSystem',
            'NoFullBackup',
            'SELECT InstanceName',
            'Write-DbaDataTable',
            'Import-DbaRegServer',
            'Get-DbaErrorLog',
            'Get-DbaAgReplica',
            'Export-DbaLogin',
            'Excel',
            'Find-DbaLoginInGroup',
            'WorkSheet',
            'Add-ConditionalFormatting',
            'Read-DbaBackupHeader',
            'Get-DbaDbBackupHistory',
            'Get-ChildItem \\nas\backups\mydb.bak',
            'OutVariable files',
            'Get-DbaSuspectPage',
            'Update-DbaInstance',
            '11112019080741',
            'DetachAttach  = $true',
            'Copy-DbaLinkedServer',
            'Remove-DbaDbTable',
            'ad\factoryauditors',
            '-Login Factory',
            'DbaDbLogShip',
            'Wsfc',
            'DbaAg',
            'Get-DbaAvailabilityGroup'

        )
        #find if it matches and write it out so we see it in the output and know it was looked at
        If (($exclusions | ForEach-Object { $code.contains($_) }) -contains $true) {
            $code = 'Write-Host "We cant run this code here! It is in the exclusion list {0}"' -f $code[0..30] -join ''
        }
        $scriptblock = [scriptblock]::Create("
        `$secStringPassword = ConvertTo-SecureString -String 'dbatools.IO' -AsPlainText -Force;
        `$sqlcred = New-Object System.Management.Automation.PSCredential ('sqladmin', `$secStringPassword);
        `$PSDefaultParameterValues = @{'*dba*:SqlCredential' = `$sqlcred;'*:WarningAction' = 'Stop';'*dba*:DestinationSqlCredential' = `$sqlcred;'*dba*:SourceSqlCredential' = `$sqlcred;}; $code")
        # $scriptblock = [scriptblock]::Create("`$PSDefaultParameterValues = @{'*:WarningAction' = 'Stop'}; $code")
         $scriptblock | Should -Not -Throw -Because "$scriptblock  - should not throw"
        # $true | Should -BeTrue
    }
} 