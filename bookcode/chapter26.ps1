 <#
    This is the code from dbatools in a Month of Lunches chapter 26

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

    
Install-Module dbachecks -Scope CurrentUser

        ###########
        
Install-Module Pester -RequiredVersion 4.10.1 -Scope CurrentUser

        ###########
        
Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastFullBackup
    
        ###########
        
Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastFullBackup
    
        ###########
        
Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastGoodCheckDb, MaxMemory

        ###########
        
Get-DbcCheck | Select-Object Group, UniqueTag


        ###########
        
Get-DbcCheck -Tag LastFullBackup | Format-List


        ###########
        
(Get-DbcCheck -Tag LastFullBackup).config.Split(' ')
    
        ###########
        
Get-DbcConfig -Name policy.backup.fullmaxdays


        ###########
        
Set-DbcConfig -Name policy.backup.fullmaxdays -Value 7


        ###########
        
Set-DbcConfig -Name policy.backup.fullmaxdays -Value 7 
Set-DbcConfig -Name policy.backup.diffmaxhours -Value 24 
Set-DbcConfig -Name policy.backup.logmaxminutes -Value 240 

Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastBackup -Show Fails
    
        ###########
        
Set-DbcConfig -Name policy.backup.fullmaxdays -Value 7
Invoke-DbcCheck -SqlInstance dbatoolslab -Check LastFullBackup
    
        ###########
        
$splatInvokeCheck = @{
  SqlInstance = "dbatoolslab"
  Check = "LastBackup"
  Passthru = $true
}
Invoke-DbcCheck @splatInvokeCheck |
Convert-DbcResult -Label dbatoolsMol |
Write-DbcTable -SqlInstance dbatoolslab -Database DatabaseAdmin

        ###########
        
$splatInvokeCheck = @{
  SqlInstance = "dbatoolslab"
  Check = "LastBackup"
  Passthru = $true
}
Invoke-DbcCheck @splatInvokeCheck |
Convert-DbcResult -Label dbatoolsMol |
Write-DbcTable -SqlInstance dbatoolslab -Database DatabaseAdmin

        ###########
        
Start-DbcPowerBi -FromDatabase

        ###########
        
