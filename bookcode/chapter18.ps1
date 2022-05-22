 <#
    This is the code from dbatools in a Month of Lunches chapter 18

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

    
$PSDefaultParameterValues["Get-DbaDatabase:SqlInstance"] = "sql01"

        ###########
        
$PSDefaultParameterValues['*-Dba*:EnableException'] = $true

        ###########
        
$splatSetAgent = @{
  SqlInstance = "sql1"
  MaximumHistoryRows = 10000
  MaximumJobHistoryRows = 100
}
Set-DbaAgentServer @splatSetAgent

        ###########
        
$date = Get-Date -Format FileDateTime
Start-Transcript -Path "\\loggingserver\sql01\filelist-$date.txt"
Get-ChildItem -Path C:\
Stop-Transcript

        ###########
        
