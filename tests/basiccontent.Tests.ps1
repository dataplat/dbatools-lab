BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
    $tests = foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -Verbose
        $content = $content -replace ([Regex]::Escape('PS> Restore-DbaDbSnapshot @splatRestoreSnapshot')), 'PS> Restore-DbaDbSnapshot @splatRestoreSnapshot 
' -replace ([Regex]::Escape('PS> $databases <2>')), 'PS> $databases
'
        $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
        $codelines = $reg.Value 
        [PSCustomObject]@{
            FileName = $file.Name
            Code     = $codelines
        }
    }
}

Describe "Testing the chapter <_.Name>" -ForEach $files {
    BeforeAll {
        function Test-Syntax {
            # Thank you @iisresetme https://stackoverflow.com/questions/43213624/how-can-i-automatically-syntax-check-a-powershell-script-file/43214144#43214144
            [CmdletBinding(DefaultParameterSetName = 'File')]
            param(
                [Parameter(Mandatory = $true, ParameterSetName = 'File', Position = 0)]
                [string]$Path, 

                [Parameter(Mandatory = $true, ParameterSetName = 'String', Position = 0)]
                [string]$Code
            )

            $Errors = @()
            if ($PSCmdlet.ParameterSetName -eq 'String') {
                [void][System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$Errors)
            }
            else {
                [void][System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$null, [ref]$Errors)
            }

            $ouch = [bool]($Errors.Count -lt 1)

            if (-not $ouch) {
                return $errors
            }
            else {
                return $true
            }
        }
    }
    $filename = $_.Name
    It "The code should not have backticks"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }).Code {
        $_ | Should -Not -Match ([regex]::Escape('`'))
    }
    It "The code should be valid - (as good as we can check anyway)"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }).Code {
        Test-Syntax -Code $_ | SHould -BeTrue
    }
}