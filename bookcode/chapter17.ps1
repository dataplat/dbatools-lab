 <#
    This is the code from dbatools in a Month of Lunches chapter 17

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
        SourceSqlInstance = "dbatoolslab\sql2017"
        DestinationSqlInstance = "dbatoolslab"
        Database = "AdventureWorks"
        SharedPath= "\\dbatoolslab\logship" 
    }
Invoke-DbaDbLogShipping @params


        ###########
        
$params = @{
        SourceSqlInstance = "dbatoolslab\sql2017"
        DestinationSqlInstance = "dbatoolslab"
        Database = "AdventureWorks","WideWorldImporters"
        SharedPath= "\\dbatoolslab\logship"
    }
Invoke-DbaDbLogShipping @params

        ###########
        
Get-DbaDbLogShipError -SqlInstance dbatoolslab\sql2017, dbatoolslab |
Select-Object SqlInstance, LogTime, Message



        ###########
        
$logShipSplat = @{
    SqlInstance = "dbatoolslab"
    Database    = "AdventureWorks"
}
Invoke-DbaDbLogShipRecovery @logShipSplat


        ###########
        
$logShipSplat = @{
    SqlInstance = "dbatoolslab"
    Database    = "AdventureWorks","WideWorldImporters"
}
Invoke-DbaDbLogShipRecovery @logShipSplat

        ###########
        
Get-Command *wsfc* -Module dbatools


        ###########
        
Get-DbaWsfcNode -ComputerName sql1


        ###########
        
Get-DbaWsfcResource -ComputerName sql1 |
Select-Object ClusterName, Name, State, Type, OwnerGroup, OwnerNode |
Format-Table


        ###########
        
$agSplat = @{
        Primary     = "sql1" 
        Secondary   = "sql2" 
        Name        = "agpoc01" 
        Database    = "AdventureWorks" 
        ClusterType = "Wsfc" 
        SharedPath  = "\\sql1\backup" 
    }
New-DbaAvailabilityGroup @agsplat


        ###########
        
$sql1 = Connect-DbaInstance -SqlInstance = "sql01,15592" -SqlCredential sa
$sql1


        ###########
        
Get-DbaAvailabilityGroup -SqlInstance $sql1


        ###########
        
Get-DbaAgReplica -SqlInstance $sql1 | Select-Object SqlInstance,
AvailabilityGroup, Name, Role, AvailabilityMode, FailoverMode


        ###########
        
Get-DbaAgDatabase -SqlInstance $sql1

        ###########
        
Invoke-DbaAgFailover -SqlInstance $sql2 -AvailabilityGroup ACME_01

        ###########
        
Suspend-DbaAgDbDataMovement -SqlInstance $sql1 -AvailabilityGroup ACME_01

        ###########
        
Resume-DbaAgDbDataMovement -SqlInstance $sql1 -AvailabilityGroup ACME_01

        ###########
        
