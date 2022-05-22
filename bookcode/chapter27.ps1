 <#
    This is the code from dbatools in a Month of Lunches chapter 27

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

    
$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  SqlCredential = "me@mydomain.onmicrosoft.com"
}
$server = Connect-DbaInstance @params
Invoke-DbaQuery -SqlInstance $server -Query "select 1 as test"

        ###########
        
$params = @{
  Type = "RenewableServicePrincipal"
  Tenant = "mytenant.onmicrosoft.com"
  Credential = "ee590f55-9b2b-55d4-8bca-38ab123db670"
}
$token = New-DbaAzAccessToken @params
$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  AccessToken = $token
}
$server = Connect-DbaInstance @params
Invoke-DbaQuery -SqlInstance $server -Query "select 1 as test"

        ###########
        
$azureAccount = Connect-AzAccount
$azureToken = Get-AzAccessToken -ResourceUrl  https://database.windows.net

$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  AccessToken = $azuretoken
}

$server = Connect-DbaInstance @params
Invoke-DbaQuery -SqlInstance $server -Query "select 1 as test"

        ###########
        
$params = @{
  Type = "RenewableServicePrincipal"
  Tenant = "mytenant.onmicrosoft.com"
  Credential = "ee590f55-9b2b-55d4-8bca-38ab123db670"
}
$token = New-DbaAzAccessToken @params
$params = @{
  SqlInstance = "myserver.database.windows.net"
  Database = "mydb"
  AccessToken = $token
}
$server = Connect-DbaInstance @params
$params = @{
  SqlInstance = $server
  Database = "mydb"
  Path = "C:\temp\customers.csv"
  AutoCreateTable = $true
}
Import-DbaCsv @params
$params = @{
  SqlInstance = $server
  Database = "mydb"
  Query = "select * from customers"
}
Invoke-DbaQuery @params

        ###########
        
