 <#
    This is the code from dbatools in a Month of Lunches chapter 22

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

    
$splatExportDacPac = @{
  SqlInstance = $ProductionFactoryInstance
  Database = "Factory"
  FilePath = "C:\temp\ProdFactory_20201230.dacpac"
}
Export-DbaDacPackage @splatExportDacPac
    
        ###########
        
$splatExportDacPac = @{
  SqlInstance = $ProductionFactoryInstance
  Database    = "Factory"
  Path        = "C:\temp\ProdFactory_20201230.dacpac"
}
Export-DbaDacPackage @splatExportDacPac
    
        ###########
        
$splatPublishDacPac = @{
  SqlInstance = $developercontainer
  Database = "FactoryIssue"
  Path     = "C:\temp\ProdFactory_20201230.dacpac"
}
Publish-DbaDacPackage @splatPublishDacPac

        ###########
        
$dacoptions  = New-DbaDacOption -Type DACPAC -Action Publish
$dacoptions.DeployOptions.ExcludeObjectTypes = "Users","RoleMembership" ,"Logins"
$splatPublishDacPacNoUsers = @{
  SqlInstance = $developercontainer
  Database = "FactoryIssue"
  FilePath = "C:\temp\ProdFactory_20201230.dacpac"
  DacOption = $dacoptions
}
Publish-DbaDacPackage @splatPublishDacPacNoUsers

        ###########
        
$splatNewDacProfile = @{
  SqlInstance = "sql01"
  Database = "Factory"
  Path = "c:\temp"
  PublishOptions = @{
      IgnoreUserLoginMappings = $true
      IgnorePermissions = $true
      ExcludeObjectTypes = 'Users;RoleMembership;Logins'
      ExcludeLogins = $true
      ExcludeUsers = $true
      IgnoreUserSettingsObjects = $true
  }
}
New-DbaDacProfile @splatNewDacProfile
    
        ###########
        
