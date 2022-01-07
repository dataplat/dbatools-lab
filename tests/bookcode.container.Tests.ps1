BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
    $tests = foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -Verbose
        $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
        $codelines = $reg.Value -replace 'PS> ', '' -replace '(\n)\[CA\]', ' ' -replace '----', '' -replace '(-SqlInstance\s\w*)', '-SqlInstance ''localhost,15592''' -replace '(-Database\s\w*)', '-Database AdventureWorks2017' -replace '(Database\s=\s"\w*")', 'Database = "AdventureWorks2017"' -replace '(SqlInstance\s=\s"\w*")', 'SqlInstance = "localhost,15592"' -replace  '\\sql2017' , '' -replace  '\\SHAREPOINT' , '' -replace '\\\\nas\\sql\\backups\\sql01', '/var/opt/mssql/backups'  -replace '\\\\nas\\sql\\sql01\\mydb', '/var/opt/mssql/backups' -replace 'C:\\dbatoolslab\\Backup\\', '/var/opt/mssql/backups' -replace '\\\\nas\\sqlbackups', '/var/opt/mssql/backups' -replace '\\\\nas\\sql\\backups', '/var/opt/mssql/backups' -replace '(SqlInstance\s=\s"dbatoolslab")', 'SqlInstance = "localhost,15592"' -replace '"PRODSQL01", "PRODSQL02", "PRODSQL03\\ShoeFactory"', '"localhost,15592","localhost,15593"' -replace 'PRODSQL02, PRODSQL03\\ShoeFactory', '"localhost,15593"' -replace 'sql2005', '"localhost,15593"' -replace '(\n)-Table',' -Table' -replace '''localhost,15592''$instances', '$instances' -replace 'clip','Select *' -replace 'SQLDEV02,15591',"'localhost,15593'" -replace 'sql01',"'localhost,15593'" -replace 'sql2008',"'localhost,15592'" -replace 'DestinationDatabase = ''WIP''','DestinationDatabase = ''tempdb'''  -replace '(\n)-Database',' -Database' -replace '//JP','#//JP' -replace '(\n)        FROM \[AzureVMs\]',' FROM AzureVMs' -replace '(\n)        ,\[StatusCode\]',', StatusCode ' -replace '(\n)        ,\[PowerState\]', ', PowerState ' -replace '(\n)        ,\[Location\]',', Location ' -replace '''localhost,15592''\$sqlconfiginstance', '''localhost,15592'' ' -replace 'Path "C:\\temp"', 'Path = "/tmp/"' -replace 'Find-DbaBackup -Path /var/opt/mssql/backups','Find-DbaBackup -Path /tmp/backups' -replace '(\n\tSourceServer)', 'SourceServer' -replace '(\n\tTestServer)','TestServer' -replace '(\n\t\[Database\])' , 'Database' -replace '(\n\tFileExists)' , 'FileExists' -replace '(\n\tSize)' , 'Size' -replace '(\n\tRestoreResult)' , 'RestoreResult' -replace '(\n\tDbccResult)' , 'DbccResult' -replace '(\n\tRestoreStart)' , 'RestoreStart' -replace '(\n\tRestoreEnd)' , 'RestoreEnd' -replace '(\n\tRestoreElapsed)' , 'RestoreElapsed' -replace '(\n\tDbccStart)' , 'DbccStart' -replace '(\n\tDbccEnd)' , 'DbccEnd' -replace '(\n\tDbccElapsed)' , 'DbccElapsed' -replace '(\n\tBackupDates)' , 'BackupDates' -replace '(\n\tBackupFiles)' , 'BackupFiles' -replace '-Path S:\\backups\\pubs.bak', '-Path /var/opt/mssql/backups/pubs.bak  -WithReplace -Confirm:$false' -replace 'C:\\temp\\sql' , '/var/opt/mssql/backups' -replace 'Path "C:\\temp\\sql\\full.bak"','/var/opt/mssql/backups/pubs.bak' -replace 'Path "C:\\temp\\sql\\trans.trn"','/var/opt/mssql/backups/pubs.trn'
        [PSCustomObject]@{
            FileName = $file.Name
            Code     = $codelines
        }
    }
}

Describe "Checking the file <_.Name> code works as intended" -ForEach $files[10] {
    $filename = $_.Name

    It "The code <_> should not error"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }).Code {
        $code = $_
        # some code that should not be run on containers or on linux or are asking for input
        $exclusions = @(
            'Invoke-Command -ComputerName spsql01',
            '$Env:PSModulePath -Split',
            'Install-DbaInstance',
            'Get-Credential',
            'Test-DbaConnection',
            'Error occurred while establishing connection to SQLDEV01',
            '09bfeb88ac58',
            'Add-DbaDbRoleMember @userSplat',
            '-SqlCredential sa',
            'Config.Instances',
            'sqldev04',
            '57689',
            'devadmin',
            'sqladmin',
            'ad\sander.stad',
            'database.windows.net',
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
            'New-DbaLogin',
            'Get-DbaErrorLog',
            'Get-DbaAgReplica',
            'Export-DbaLogin',
            'Excel',
            'Find-DbaLoginInGroup',
            'WorkSheet',
            'Add-ConditionalFormatting',
            'Read-DbaBackupHeader',
            'Get-DbaDbBackupHistory',
            'Get-ChildItem \\nas\backups\mydb.bak'

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