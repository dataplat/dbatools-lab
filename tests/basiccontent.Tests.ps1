BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name

    $tests = foreach ($file in $files) {
        # What we are doing here is the preparation for the regex to get all of the code by reading the file and replacing a few of the line breaks
        $content = Get-Content $file.FullName -Raw -Verbose
        $content = $content -replace ([Regex]::Escape('PS> Restore-DbaDbSnapshot @splatRestoreSnapshot')), 'PS> Restore-DbaDbSnapshot @splatRestoreSnapshot 
' -replace ([Regex]::Escape('PS> $databases <2>')), 'PS> $databases
' -replace ([Regex]::Escape('WARNING')), '
WARNING' -replace ([Regex]::Escape('----')), '
----' -replace ([Regex]::Escape('PS> $Env:PSModulePath -Split ";"')), 'PS> $Env:PSModulePath -Split ";"
' -replace ([Regex]::Escape('PS> docker ps')), 'PS> docker ps
' -replace ([Regex]::Escape('
PS> Add-DbaDbRoleMember @userSplat -User WWI_Readonly -Role db_datareader')), 'PS> Add-DbaDbRoleMember @userSplat -User WWI_Readonly -Role db_datareader' -replace ([Regex]::Escape('PS> Import-DbaSpConfigure @splatExportSpConf')), 'PS> Import-DbaSpConfigure @splatExportSpConf
' -replace 'PS> \$diff = Backup-DbaDatabase @diffSplat
', 'PS> $diff = Backup-DbaDatabase @diffSplat' -replace 'PS> Set-DbaDbState @offlineSplat
', 'PS> Set-DbaDbState @offlineSplat' -replace '
PS> New-DbaDbUser @userSplat -Login WWI_ReadOnly', 'PS> New-DbaDbUser @userSplat -Login WWI_ReadOnly' -replace '
PS> New-DbaLogin @loginSplat -Login WWI_ReadOnly', 'PS> New-DbaLogin @loginSplat -Login WWI_ReadOnly' -replace '
PS> Backup-DbaDatabase @backupparam', 'PS> Backup-DbaDatabase @backupparam' -replace 'New-DbaLogin -SqlInstance SQL01 -Login Factory', 'New-DbaLogin -SqlInstance SQL01 -Login Factory
' -replace '
}
catch {', '}
catch {' -replace '
foreach \(\$replica', 'foreach ($replica' -replace 'replicatocopy"
', 'replicatocopy"' -replace '}

\s+try {', '}
try {' -replace '
PS> \$excel ', 'PS> $excel ' -replace '
PS> Add-ConditionalFormatting', 'PS> Add-ConditionalFormatting' -replace 'Windows PowerShell credential request', '

Windows PowerShell credential request' -replace 'Destination "mssql2", "mssql3"', 'Destination = "mssql2", "mssql3"' -replace '
PS> Get-DbaDbCompression', 'PS> Get-DbaDbCompression' -replace 'azuretoken
}
', 'azuretoken
}' -replace '
PS> Get-DbaBuildReference -SqlInstance \$sqlinstances ', 'PS> Get-DbaBuildReference -SqlInstance $sqlinstances ' -replace '
PS> Get-DbaComputerSystem -ComputerName \$sqlhosts ', 'PS> Get-DbaComputerSystem -ComputerName $sqlhosts ' -replace '
PS> Get-DbaOperatingSystem -ComputerName \$sqlhosts ', 'PS> Get-DbaOperatingSystem -ComputerName $sqlhosts ' -replace '
PS> Get-DbaDatabase -SqlInstance \$sqlinstances ', 'PS> Get-DbaDatabase -SqlInstance $sqlinstances ' -replace '
PS> Find-DbaUserObject -SqlInstance \$sqlinstances ', 'PS> Find-DbaUserObject -SqlInstance $sqlinstances ' -replace '
PS> New-DbaAgentProxy @proxysplat', 'PS> New-DbaAgentProxy @proxysplat' -replace 'Query "select \* from customers"', 'Query = "select * from customers"'

        # Once the prep is done, we get all of the code by matching everything between 'PS> ' and 2 new lines and calling it code
        $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })

        # Nw we play an amazing and awesome game of replace so that the code will run successfully on the GitHub runner in pwsh, against containers
        # In general the following things are done with these replaces
        # - Anything -SqlInstance, SqlInstance = including Source and destination ones are replaced to be localhost, 15592 or 15593
        # - Also any other nefarious sql01 or devsql or other things we add are replaced as well
        # - Also any rogue quotes as we need localhost, 15592 or 15593 in single quotes
        # - Any database references are replaced with pubs (for now) in the same way
        # - Filepaths
        #      - Any internal to the instance file paths are set to /var/opt/mssql/backups
        #      - Any external to the instance file paths are set to /tmp/ or to $TestDrive (Pesters tmp directory)
        #      - Except for sometimes when we need to do different things because of the way we have named things in the book or because PEster goes weird or containers or stuff
        #      - set values for backup files to the ones we precreated in the pipeline
        #      - Change data and log directories to linux paths
        # - Confirmations or interactivity
        #      - Apart from the things we really cant do which are added to the exclusions (see below)
        #      - Adding -Confirm:$false where it can be useful
        #      - Changing Out-GridView or clip to Select *
        # - Logins - Change any owner logins etc to sqladmin as it is easier than setting them all up
        # - Warning Action set to SilentlyContinue for some commands - In General a warning will cause a test failure (because I wanted to see them when building this and Enable Exception makes that much harder to parse)
        #                                                              but sometimes we need to add SilentlyContinue because we dont care about out of date build cache or that we need to restart to apply SpCOnfigure changes
        # - Exclusions
        #        - Exclude Copy Settings that are not valid on Linux or Containers
        #        - Exclude Databases for some of the backup and restore tasks
        # - Credentials get removed so we dont get prompted or get replaced with the default one we use
        # - State
        #        - Return the databases to online for later chapters!!
        #        

        $codelines = $reg.Value -replace '<\d>', '' -replace '(\n)\[CA\]', ' ' -replace '(\n)\s+\[CA\]', ' ' -replace '----', ''
        # once all of the replacements are done we create an object which has the filename and the code for testing and also the name of the code without the silly double quotes that make it break
        foreach ($codeline in $codelines | Where-Object { $_ -ne '' }) {
            [PSCustomObject]@{
                FileName = $file.Name
                Code     = $codeline
                CodeName = ($codeline[0..30] -join '' -replace '"', ' ')
            }
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

        function Test-PowerShellCode {
            param
            (
                [string]
                $Code
            )
            # Thank you Tobias the Wonderful - https://powershell.one/powershell-internals/parsing-and-tokenization/abstract-syntax-tree
            try {
                # try and convert string to scriptblock:
                $null = [ScriptBlock]::Create($Code)
                return $true
            }
            catch {
                # the parser is invoked implicitly and returns
                # syntax errors as exceptions:
                $_.Exception.InnerException.Errors
            }
        }
    }
    $filename = $_.Name
    It "The code <_.CodeName> should not have backticks"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }) {
        $_.Code | Should -Not -Match ([regex]::Escape('`'))
    }
    It "The code <_.CodeName> should be valid - (as good as we can check anyway)" -ForEach @($tests | Where-Object { $_.FileName -eq $filename }) {
        Test-Syntax -Code $_.Code  | SHould -BeTrue
    }
    It "The code <_.CodeName> should be valid with Tobias Checks" -ForEach @($tests | Where-Object { $_.FileName -eq $filename }) {
        Test-PowerShellCode -Code $_.Code | SHould -BeTrue
    }
    It "The code <_.CodeName> splats should match"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }) {
        $code = $_.Code
        $scriptblock = [scriptblock]::Create("$code")
        $ast = $scriptblock.Ast
        $variableexpressions = $ast.FindAll( { $args[0] -is [System.Management.Automation.Language.VariableExpressionAst] }, $true)

        foreach ($splatted in ($variableexpressions | Where Splatted )) {
            $splatted.VariablePath.UserPath -in ($variableexpressions | Where Splatted -eq $false).VariablePath.UserPath | Should -BeTrue -Because "$Code splats are not right"
        } 
    }
}