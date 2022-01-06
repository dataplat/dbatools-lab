BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
    $tests = foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -Verbose
        $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
        $codelines = $reg.Value -replace 'PS> ', '' -replace '(\n)\[CA\]', ' ' -replace '----', '' -replace '(-SqlInstance\s\w*)', '-SqlInstance ''localhost,15592''' -replace '(-Database\s\w*)', '-Database AdventureWorks2017' -replace '(Database\s=\s"\w*")', 'Database = "AdventureWorks2017"' -replace '(SqlInstance\s=\s"\w*")', 'SqlInstance = "localhost,15592"' -replace  '\\sql2017' , '' -replace  '\\SHAREPOINT' , '' -replace 'C:\\dbatoolslab\\Backup\\', '/var/opt/mssql/backups/' -replace '(SqlInstance\s=\s"dbatoolslab")', 'SqlInstance = "localhost,15592"' -replace '"PRODSQL01", "PRODSQL02", "PRODSQL03\\ShoeFactory"', '"localhost,15592","localhost,15593"' -replace 'PRODSQL02, PRODSQL03\\ShoeFactory', '"localhost,15593"' -replace 'sql2005', '"localhost,15593"' -replace '(\n)-Table',' -Table' -replace '''localhost,15592''$instances', '$instances' -replace 'clip','Select *' -replace 'SQLDEV02,15591','localhost,15593' -replace 'DestinationDatabase = ''WIP''','DestinationDatabase = ''tempdb'''  -replace '(\n)-Database',' -Database' -replace '//JP','#//JP' -replace '(\n)        FROM \[AzureVMs\]',' FROM AzureVMs' -replace '(\n)        ,\[StatusCode\]',', StatusCode ' -replace '(\n)        ,\[PowerState\]', ', PowerState ' -replace '(\n)        ,\[Location\]',', Location ' -replace '''localhost,15592''\$sqlconfiginstance', '''localhost,15592'' '
        [PSCustomObject]@{
            FileName = $file.Name
            Code     = $codelines
        }
    }
}

Describe "Checking the file <_.Name> code works as intended" -ForEach $files[7] {
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
            'Write-DbaDataTable'

        )
        #find if it matches and write it out so we see it in the output and know it was looked at
        If (($exclusions | ForEach-Object { $code.contains($_) }) -contains $true) {
            $code = 'Write-Host "We cant run this code here! It is in the exclusion list {0}"' -f $_
        }
        $scriptblock = [scriptblock]::Create("
        `$secStringPassword = ConvertTo-SecureString -String 'dbatools.IO' -AsPlainText -Force;
        `$sqlcred = New-Object System.Management.Automation.PSCredential ('sqladmin', `$secStringPassword);
        `$PSDefaultParameterValues = @{'*dba*:SqlCredential' = `$sqlcred;'*:WarningAction' = 'Stop';'*dba*:DestinationSqlCredential' = `$sqlcred;}; $code")
        # $scriptblock = [scriptblock]::Create("`$PSDefaultParameterValues = @{'*:WarningAction' = 'Stop'}; $code")
         $scriptblock | Should -Not -Throw -Because "$scriptblock  - should not throw"
        # $true | Should -BeTrue
    }
} 