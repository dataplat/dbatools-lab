BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
}

Describe "Checking the code works as intended in <_.Name>" -ForEach $files[0..4] {
    BeforeAll {
            $content = Get-Content $_.FullName -Raw -Verbose
            $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
            # $codelines = $reg.Value -replace 'PS> ', '' -replace '\[CA\]', '' -replace '----', '' -replace '(-SqlInstance\s\w*)', '-SqlInstance ''localhost,15592''' -replace '(-Database\s\w*)', '-Database AdventureWorks2017' -replace '(SqlInstance\s=\s"\w*")', 'SqlInstance = "localhost,15592"' -replace '\\sql2017' , '' -replace 'C:\\dbatoolslab\\Backup\\', ''
            # foreach ($line in $codelines) {
            #     [PSCustomObject]@{
            #         FileName = $file.Name
            #         Code     = $line
            #     }
            # }
    }

    It "Should have something <_.Name> <_.FullName>" {
        $_.Name | Should -Be $_.Name
    }
    It "Should have some content" {
        $content | Should -Not -Be ''
    }
    It "Should have some regex matches" {
        $reg | Should -Be ''
    }
}
# BeforeDiscovery {
#     $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
#     $tests = foreach ($file in $files) {
#         $content = Get-Content $file.FullName -Raw -Verbose
#         $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
#         $codelines = $reg.Value -replace 'PS> ', '' -replace '\[CA\]', '' -replace '----', '' -replace '(-SqlInstance\s\w*)', '-SqlInstance ''localhost,15592''' -replace '(-Database\s\w*)', '-Database AdventureWorks2017' -replace '(SqlInstance\s=\s"\w*")', 'SqlInstance = "localhost,15592"' -replace  '\\sql2017' , '' -replace 'C:\\dbatoolslab\\Backup\\', ''
#         foreach($line in $codelines){
#             [PSCustomObject]@{
#                 FileName = $file.Name
#                 Code     = $line
#             }
#         }
#     }
# }
# 
# Describe "Checking the code works as intended" {
# 
#     It "The file <_.FileName>'s code <_.Code> should not error"  -ForEach $tests[0..5] {
#         $code = $_.Code
#         # some code that should not be run
#         $exclusions = @(
#             'Invoke-Command -ComputerName spsql01',
#             '$Env:PSModulePath -Split',
#             'Install-DbaInstance',
#             'Get-Credential'
#         )
# 
#         If (($exclusions | ForEach-Object { $code.contains($_) }) -contains $true) {
#             $code = '$a'
#         }
#         # create a scriptblock with the credential, set it as a default param and set Warnings to fail the test also
#         $scriptblock = [scriptblock]::Create("
#         `$secStringPassword = ConvertTo-SecureString -String 'dbatools.IO' -AsPlainText -Force;
#         `$sqlcred = New-Object System.Management.Automation.PSCredential ('sqladmin', `$secStringPassword);
#         `$PSDefaultParameterValues = @{'*dba*:SqlCredential' = `$sqlcred;'*:WarningAction' = 'Stop'}; $code")
#         #$scriptblock = [scriptblock]::Create("`$PSDefaultParameterValues = @{'*:WarningAction' = 'Stop'}; $code")
#         $scriptblock | Should -Not -Throw -Because "$scriptblock  - should not throw"
#     }
# }