 <#
    This is the code from dbatools in a Month of Lunches chapter 08

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

    
Get-DbaRegServer | Invoke-DbaQuery -Query "SELECT @@VERSION"

        ###########
        
Get-DbaRegServer


        ###########
        
Get-DbaRegServer -Name sql01 | Get-DbaDatabase |
Backup-DbaDatabase


        ###########
        
$cred = Get-Credential sqladmin
Get-DbaRegserver -SqlInstance dbainstance |
Backup-DbaDatabase -SqlCredential $cred

        ###########
        
Get-DbaRegServer -SqlInstance dbainstance


        ###########
        
Import-Csv -Path C:\temp\regservers.csv

ServerName Name               Description    Group

        ###########
        
Import-Csv -Path C:\temp\regservers.csv |
Import-DbaRegServer -SqlInstance sql2016


        ###########
        
Get-DbaRegServer -SqlInstance sql2016 -Group Test\Dev


        ###########
        
Get-DbaRegServer -SqlInstance sql2016 -ExcludeGroup Test\Dev


        ###########
        
Get-DbaRegServer -SqlInstance dbainstance -IncludeLocal

        ###########
        
Add-DbaRegServer -ServerName sql2017

        ###########
        
$splatRegServer = @{
    SqlInstance = "sqldb01"
    Group = "OnPrem"
    ServerName = "sql01"
}
Add-DbaRegServer @splatRegServer

        ###########
        
$splatRegServer = @{
    SqlInstance = "sqldb01"
    Group = "OnPrem\Accounting"
    ServerName = "sql01"
}
Add-DbaRegServer @splatRegServer

        ###########
        
$splatConnect = @{
    SqlInstance = "dockersql1,14333"
    SqlCredential = "sqladmin"
}
Connect-DbaInstance @splatConnect | Add-DbaRegServer -Description = "Container for AG tests"

        ###########
        
Copy-DbaRegServer -Source sql2008 -Destination sql01

# Export CMS list to an XML file
$splatExportRegServer = @{
    SqlInstance = "sql2008"
    Path = "C:\temp"
    OutVariable = file
}
Export-DbaRegServer @splatExportRegServer

# Import CMS list from an XML file
Import-DbaRegServer -SqlInstance sql01 -Path $file

        ###########
        
Move-DbaRegServer -Name 'Web SQL Cluster' -Group HR\Prod

        ###########
        
Get-DbaRegServer | Where Name -match HR |
Move-DbaRegServer -Group HR\Prod

        ###########
        
Remove-DbaRegServer -ServerName sql01

        ###########
        
Get-DbaRegServer -ServerName sql2016, sql01 |
Remove-DbaRegServer -Confirm:$false

        ###########
        
