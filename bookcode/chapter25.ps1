 <#
    This is the code from dbatools in a Month of Lunches chapter 25

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

    
Get-DbaSpConfigure -SqlInstance mssql1 -Name DefaultBackupCompression

Set-DbaSpConfigure -SqlInstance mssql1 -Name DefaultBackupCompression -Value 1

        ###########
        
Get-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks

        ###########
        
Get-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks


        ###########
        
$splatProperties = @{
    Property =
        @{N="Data Compression Type"; E={$_.Name}},
        @{N="Number Of Objects"; E={$_.Count}},
        @{l='SizeMB'; e={'{0:n0}' -f (($_.Group.SizeCurrent |
        Measure-Object -Sum).Sum/1MB)}}
}

Get-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks |
    Group-Object DataCompression |
    Select-Object @splatProperties

        ###########
        
Get-DbaDbCompression -SqlInstance mssql1 -ExcludeDatabase TestDatabase

        ###########
        
Test-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks

        ###########
        
Set-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks

        ###########
        
$splatTestCompression = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
}
$compressObjects = Test-DbaDbCompression @splatTestCompression

## Review the results in $compressObjects
$splatSetCompression = @{
    SqlInstance = "mssql1"
    InputObject = $compressObjects
}
Set-DbaDbCompression @splatSetCompression

        ###########
        
$splatSetCompressionPage = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
    CompressionType = "PAGE"
}
Set-DbaDbCompression @splatSetCompressionPage

$splatSetCompressionRow = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
    Table = "Employee"
    CompressionType = "ROW"
}
Set-DbaDbCompression @splatSetCompressionRow

        ###########
        
$splatSetCompressionPage = @{
    SqlInstance = "mssql1"
    Database = "AdventureWorks"
    CompressionType = "NONE"
}
Set-DbaDbCompression @splatSetCompressionPage

        ###########
        
Set-DbaDbCompression -SqlInstance mssql1 -Database AdventureWorks  -MaxRunTime 60 -PercentCompression 25

        ###########
        
