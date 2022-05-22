 <#
    This is the code from dbatools in a Month of Lunches chapter 05

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

    
Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem


        ###########
        
Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
        Select Name, Size, LastFullBackup


        ###########
        
Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackup | clip

        ###########
        
Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackup |
Export-Csv -Path Databaseinfo.csv -NoTypeInformation

Get-Content DatabaseInfo.csv
    
        ###########
        
Get-ChildItem -Path E:\csvs\top.csv |
Import-DbaCsv -SqlInstance SQLDEV01 -Database tempdb -Table top


        ###########
        
Get-ChildItem E:\csv\top*.csv |
Import-DbaCsv -SqlInstance SQLDEV01 -Database tempdb -AutoCreateTable


        ###########
        
Import-Csv -Path E:\csv\top-tracks.csv |
Select Rank, Plays, Artist, Title


        ###########
        
Import-Csv -Path .\Databaseinfo.csv |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb -Table Databases -AutoCreateTable

        ###########
        
$csv = Import-Csv \\server\bigdataset.csv
Write-DbaDataTable -SqlInstance sql2014 -InputObject $csv -Database mydb

        ###########
        
$query = "Select * from Databases"
Invoke-DbaQuery -SqlInstance SQLDEV01 -Database tempdb -Query $query

        ###########
        
Remove-DbaDbTable SqlInstance SQL01 -Database tempdb -Table databases

        ###########
        
Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackUp |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb -Table Databases -AutoCreateTable

        ###########
        
$query = "Select * from Databases"
Invoke-DbaQuery -SqlInstance SQLDEV01 -Query $query -Database tempdb

        ###########
        
(Get-DbaDbTable -SqlInstance SQLDEV01 -Database tempdb -Table Databases).Columns |
Select-Object  Parent,Name, Datatype


        ###########
        
Import-Csv -Path .\Databaseinfo.csv | Get-Member
Get-DbaDatabase -SqlInstance SQLDEV01 -ExcludeSystem |
Select Name, Size, LastFullBackup | Get-Member

        ###########
        
Import-Csv -Path .\Databaseinfo.csv |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb -Table Databases

        ###########
        
Import-Csv -Path .\Databaseinfo.csv |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb -Table Databases
Invoke-DbaQuery -SqlInstance SQLDEV01 -Query "select * from Databases" -Database tempdb


        ###########
        
Get-Process | Select -Last 10 |
Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb -Table processes -AutoCreateTable

        ###########
        
(Get-DbaDbTable -SqlInstance SQLDEV01 -Database tempdb -Table processes).Columns | Select-Object  Parent,Name, Datatype


        ###########
        
Connect-AzAccount


        ###########
        
Get-AzVM -Status | Write-DbaDataTable -SqlInstance SQLDEV01 -Database tempdb -Table AzureVMs -AutoCreateTable

        ###########
        
$query = "SELECT [Name]
        ,[Location]
        ,[PowerState]
        ,[StatusCode]
        FROM [AzureVMs]"
Invoke-DbaQuery -SqlInstance SQLDEV01 -Query $query -Database tempdb

 
        ###########
        
$copyDbaDbTableDataSplat = @{
    SqlInstance = "SQLDEV01"
    Database = "WideWorldImporters"
    Table = '[Purchasing].[PurchaseOrders]'
    Destination = "SQLDEV02,15591"
    DestinationDatabase = 'WIP'
    DestinationTable = 'dbo.PurchaseOrders'
    AutoCreateTable = $true
}
Copy-DbaDbTableData @copyDbaDbTableDataSplat

SourceInstance      : SQLDEV01
SourceDatabase      : WideWorldImporters
SourceSchema        : Purchasing
SourceTable         : PurchaseOrders
DestinationInstance : SQLDEV02,15591
DestinationDatabase : WIP
DestinationSchema   : dbo
DestinationTable    : PurchaseOrders
RowsCopied          : 2074
Elapsed             : 77.01 ms

        ###########
        
