 <#
    This is the code from dbatools in a Month of Lunches chapter 09

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

    
$splatGetErrorLog = @{
    SqlInstance = "SQL01"
    After = (Get-Date).AddMinutes(-5)
}
Get-DbaErrorLog @splatGetErrorLog | Select LogDate, Source, Text
    
        ###########
        
New-DbaLogin -SqlInstance SQL01 -Login Factory
    
        ###########
        
$servers = Get-DbaRegisteredServer
New-DbaLogin -SqlInstance $servers -Login ad\factoryauditors
    
        ###########
        
$servers = Get-DbaRegisteredServer
$cred = Get-Credential factoryuser1 
$splatNewLogin = @{
    SqlInstance = $servers
    Login = $cred.UserName
    SecurePassword = $cred.Password
}
 New-DbaLogin @splatNewLogin
    
        ###########
        
Get-DbaDbUser -SqlInstance SQL01 -Database WideWorldImporters | Select Name
    
        ###########
        
Get-DbaDbUser -SqlInstance SQL01 -Database WideWorldImporters | Select Name
    
        ###########
        
Repair-DbaDbOrphanUser -SqlInstance SQL01"
    
        ###########
        
try {
    # Since this is running as an Agent job, use $ENV:ComputerName
    # to get the hostname of the server the job runs on
    $splatGetAgReplica = @{
        SqlInstance = $ENV:ComputerName
        EnableException = $true
    }
    $replicas = (Get-DbaAgReplica $splatGetAgReplica).Name

}
catch {
    # Ensure SQL Agent shows a failed job
    Write-Error -Message $_ -ErrorAction Stop
}

foreach ($replica in $replicas) {
    Write-Output "For this replica $replica"
    $replicastocopy = $replicas | Where-Object { $_ -ne $replica }
    foreach ($replicatocopy in $replicastocopy) {
      Write-Output "We will copy logins from $replica to $replicatocopy"

      $splatCopyLogin = @{
          Source = $replica
          Destination = $replicatocopy
          ExcludeSystemLogins = $true
          EnableException = $true
      }

      try {
        $output =  Copy-DbaLogin @splatCopyLogin
      } catch {
        $error[0..5] | Format-List -Force | Out-String
        # Ensure SQL Agent shows a failed job
        Write-Error -Message $_ -ErrorAction Stop
      }
        if ($output.Status -contains 'Failed') {
            $error[0..5] | Format-List -Force | Out-String
            # Ensure SQL Agent shows a failed job
            Write-Error -Message "At least one login failed.
            [CA]See log for details." -ErrorAction Stop
        }
    }
}

        ###########
        
Export-DbaLogin -SqlInstance SQL01"
    
        ###########
        
git init



        ###########
        
$date = Get-Date
$path = "$home\sourcerepo\SqlPermission"
$file = "Factory.sql"
Export-DbaLogin -SqlInstance SQL01"
    
        ###########
        
Set-Location $path
git add $file
git commit -m "The Factory users update for $date"

        ###########
        
Get-DbaUserPermission -SqlInstance SQL01 -Database WideWorldImporters |
Select SqlInstance, Object, Type, Member, RoleSecurableClass | Format-Table"
    
        ###########
        
$splatExportExcel = @{
 Path = "C:\temp\FactoryPermissions.xlsx" 
 WorksheetName = "User Permissions"
 AutoSize = $true
 FreezeTopRow = $true
 AutoFilter = $true
 PassThru = $true 
}

$excel = Get-DbaUserPermission -SqlInstance SQL01 -Database WideWorldImporters | Export-Excel @splatExportExcel

$rulesparam = @{
 Address = $excel.Workbook.Worksheets["User Permissions"].Dimension.Address
 WorkSheet = $excel.Workbook.Worksheets["User Permissions"]
 RuleType = "Expression"
}

Add-ConditionalFormatting @rulesparam -ConditionValue 'NOT(ISERROR(FIND("sysadmin",$G1)))' -BackgroundColor Yellow -StopIfTrue

Add-ConditionalFormatting @rulesparam -ConditionValue 'NOT(ISERROR(FIND("db_owner",$G1)))' -BackgroundColor Yellow -StopIfTrue

Add-ConditionalFormatting @rulesparam -ConditionValue 'NOT(ISERROR(FIND("SERVER LOGINS",$E1)))' -BackgroundColor PaleGreen

Add-ConditionalFormatting @rulesparam -ConditionValue 'NOT(ISERROR(FIND("SERVER SECURABLES",$E1)))' -BackgroundColor PowderBlue

Add-ConditionalFormatting @rulesparam -ConditionValue 'NOT(ISERROR(FIND("DB ROLE MEMBERS",$E1)))' -BackgroundColor GoldenRod

Add-ConditionalFormatting @rulesparam -ConditionValue 'NOT(ISERROR(FIND("DB SECURABLES",$E1)))' -BackgroundColor BurlyWood

Close-ExcelPackage $excel 

        ###########
        
Find-DbaLoginInGroup -SqlInstance SQL01 -Login "ad\bmiller"
    
        ###########
        
