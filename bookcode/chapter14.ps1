 <#
    This is the code from dbatools in a Month of Lunches chapter 14

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

    
Export-DbaInstance -SqlInstance sql01 -Path \\nas\backups\sql01

        ###########
        
Get-ChildItem .\sql01-11112019080741\


    
        ###########
        
$options = New-DbaScriptingOption
$options | Select *
    
        ###########
        
$options = New-DbaScriptingOption
$options.IncludeIfNotExists = $true

        ###########
        
$splatExportInstance = @{
    SqlInstance = "sql01"
    Path = "C:\git\ExportInstance"
    Exclude = "ResourceGovernor"
}
Export-DbaInstance @splatExportInstance

        ###########
        
Get-DbaAgentJob -SqlInstance sql01 | Select-Object -First 1 |
Export-DbaScript

    
        ###########
        
Get-DbaDbStoredProcedure -SqlInstance sql01 -Database master |
Where-Object Name -eq sp_MScleanupmergepublisher |
Export-DbaScript -Passthru
    
        ###########
        
Get-DbaAgentJob -SqlInstance sql01 | Select-Object -First 1 |
Export-DbaScript | clip

        ###########
        
$options = New-DbaScriptingOption
$options.includeifnotexists = $true
$splatExportScript = @{
    FilePath = "C:\git\export\sql01\audit.sql"
    ScriptingOptionsObject = $options
}
Get-DbaInstanceAudit -SqlInstance sql01 |
Export-DbaScript @splatExportScript

    
        ###########
        
$splatExportScript = @{
    FilePath = "C:\git\export\sql01\auditspec.sql"
    ScriptingOptionsObject = $options
}
Get-DbaInstanceAuditSpecification -SqlInstance sql01 |
Export-DbaScript @splatExportScript

    
        ###########
        
Get-DbaAgentJob -SqlInstance sql01 | Get-Member


        ###########
        
Get-DbaSpConfigure -SqlInstance sql01 | Get-Member


        ###########
        
$splatExportSpConf = @{
    SqlInstance = "sql01"
    FilePath = "C:\git\ExportInstance\spconfigure.sql"
}
Export-DbaSpConfigure @splatExportSpConf

        ###########
        
$splatExportSpConf = @{
    SqlInstance = "sql01,15591"
    SqlCredential = "sqladmin"
    Path = "C:\git\ExportInstance\spconfigure.sql"
}
Import-DbaSpConfigure @splatExportSpConf
    
        ###########
        
