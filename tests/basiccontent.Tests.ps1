BeforeDiscovery {
    $files = Get-ChildItem *chapter*.adoc -Recurse | Select-Object FullName, Name
    $tests = foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -Verbose
        $reg = [regex]::matches($content, "PS>\s(?<code>[\s\S]*?(?=(\r\n?|\n){2,}))").Groups.Where( { $_.Name -eq 'code' })
        $codelines = $reg.Value 
        [PSCustomObject]@{
            FileName = $file.Name
            Code     = $codelines
        }
    }
}

Describe "Testing the chapter <_.Name>" -ForEach $files {
    $filename = $_.Name
    It "The code Should not have backticks"  -ForEach @($tests | Where-Object { $_.FileName -eq $filename }).Code {
        $_ | Should -Not -Match ([regex]::Escape('`'))
    }
}