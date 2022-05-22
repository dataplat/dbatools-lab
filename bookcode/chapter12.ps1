 <#
    This is the code from dbatools in a Month of Lunches chapter 12

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

    
New-DbaDbSnapshot -SqlInstance mssql1 -Database AdventureWorks

        ###########
        
Get-DbaProcess -SqlInstance mssql1 -Database AdventureWorks |
    Stop-DbaProcess
$splatRestoreSnapshot = @{
    SqlInstance = "mssql1"
    Snapshot = "AdventureWorks_20210530_071605" 
}
Restore-DbaDbSnapshot @splatRestoreSnapshot

        ###########
        
Get-DbaDbSnapshot -SqlInstance mssql1 -Database AdventureWorks |
    Remove-DbaDbSnapshot

        ###########
        
