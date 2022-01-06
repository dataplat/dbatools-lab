BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
    $tests = foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -Verbose
        $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
        $codelines = $reg.Value -replace 'PS> ', '' -replace '\[CA\]', '' -replace '----', '' -replace '(-SqlInstance\s\w*)', '-SqlInstance ''localhost,15592''' -replace '(-Database\s\w*)', '-Database AdventureWorks2017' -replace '(SqlInstance\s=\s"\w*")', 'SqlInstance = "localhost,15592"' -replace  '\\sql2017' , '' -replace  '\\SHAREPOINT' , '' -replace 'C:\\dbatoolslab\\Backup\\', '/var/opt/mssql/backups/' -replace '(SqlInstance\s=\s"dbatoolslab")', 'SqlInstance = "localhost,15592"'
        [PSCustomObject]@{
            FileName = $file.Name
            Code     = $codelines
        }
    }
}

Describe "Checking the file <_.Name> code works as intended" -ForEach $files[0..3] {
    $filename = $_.Name

    It "The code <_> should not error"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }).Code[0..5] {
        $code = $_
        # some code that should not be run on containers or on linux or are asking for input
        $exclusions = @(
            'Invoke-Command -ComputerName spsql01',
            '$Env:PSModulePath -Split',
            'Install-DbaInstance',
            'Get-Credential',
            'Test-DbaConnection',
            'Error occurred while establishing connection to SQLDEV01'
        )
        If (($exclusions | ForEach-Object { $code.contains($_) }) -contains $true) {
            $code = 'Write-Host "We cant run this code here!"'
        }
        $scriptblock = [scriptblock]::Create("
        `$secStringPassword = ConvertTo-SecureString -String 'dbatools.IO' -AsPlainText -Force;
        `$sqlcred = New-Object System.Management.Automation.PSCredential ('sqladmin', `$secStringPassword);
        `$PSDefaultParameterValues = @{'*dba*:SqlCredential' = `$sqlcred;'*:WarningAction' = 'Stop'}; $code")
        # $scriptblock = [scriptblock]::Create("`$PSDefaultParameterValues = @{'*:WarningAction' = 'Stop'}; $code")
        $scriptblock | Should -Not -Throw -Because "$scriptblock  - should not throw"
    }
} 