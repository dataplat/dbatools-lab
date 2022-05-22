 <#
    This is the code from dbatools in a Month of Lunches chapter 23

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

    
Get-DbaTrace -SqlInstance sql01, sql02, sql03

        ###########
        
Get-DbaRegisteredServer | Get-DbaTrace


        ###########
        
Get-DbaRegisteredServer | Get-DbaTrace |
    Out-GridView -PassThru | Start-DbaTrace

        ###########
        
Get-DbaTrace -SqlInstance sql2014 | Where-Object Id -eq 1 |
    ConvertTo-DbaXESession -Name 'Converted Default Trace' |
    Start-DbaXESession


        ###########
        
Find-DbaCommand -Tag ExtendedEvent

        ###########
        
Get-DbaRegServer | Get-DbaXESession

        ###########
        
Get-DbaXESession -SqlInstance mssql1 -Session telemetry_xevents


        ###########
        
Get-DbaXESessionTemplate


        ###########
        
Get-DbaXESessionTemplate -Template 'Deprecated Feature Usage' |
    Import-DbaXESessionTemplate -SqlInstance mssql1 |
    Start-DbaXESession


        ###########
        
 Get-ChildItem 'C:\temp\Login Tracker.xml' |
     Import-DbaXESessionTemplate -SqlInstance mssql1


        ###########
        
Start-DbaXESession -SqlInstance mssql1 -Session "Query Timeouts"


        ###########
        
Stop-DbaXESession -SqlInstance mssql1 -Session "Query Timeouts"


        ###########
        
Start-DbaXESession -SqlInstance mssql1 -Session 'Query Timeouts'  -StopAt (Get-Date).AddMinutes(30)

        ###########
        
Watch-DbaXESession -SqlInstance mssql1 -Session QuickSessionStandard |
    Where-Object client_app_name -match dbatools


        ###########
        
Read-DbaXEFile -Path C:\temp\deadocks.xel

        ###########
        
$splatCopyXESession = @{
    Source = "mssql1"
    Destination = "mssql2", "mssql3"
    XeSession = "Login Tracker"
}
Copy-DbaXESession @splatCopyXESession

        ###########
        
