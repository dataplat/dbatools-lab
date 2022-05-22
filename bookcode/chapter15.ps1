 <#
    This is the code from dbatools in a Month of Lunches chapter 15

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

    
Start-DbaMigration -Source sql01 -Destination sql02 -BackupRestore -SharedPath \\nas\sql\migration

        ###########
        
$copySplat = @{
    Source        = "sql01"               
    Destination   = "sql02"               
    Database      = "WideWorldImporters"  
    SharedPath    = "\\nas\sql\migration" 
    BackupRestore = $true                 
}
Copy-DbaDatabase @copySplat

        ###########
        
$copySplat = @{
    Source        = "sql01"
    Destination   = "sql02"
    AllDatabases  = $true
    SharedPath    = "\\nas\sql\migration"
    BackupRestore = $true
}
Copy-DbaDatabase @copySplat

        ###########
        
$copySplat = @{
    Source           = "sql01"
    Destination      = "sql02"
    Database         = "WideWorldImporters"
    SharedPath       = "\\nas\sql\migration"
    BackupRestore    = $true
    SetSourceOffline = $true
}
Copy-DbaDatabase @copySplat

        ###########
        
$copySplat = @{
    Source        = "sql01"              
    Destination   = "sql02"              
    Database      = "WideWorldImporters" 
    DetachAttach  = $true                
}
Copy-DbaDatabase @copySplat

        ###########
        
$copySplat = @{
    Source           = "sql01"
    Destination      = "sql02"
    Database         = "WideWorldImporters"
    DetachAttach     = $true
    Reattach         = $true
}
Copy-DbaDatabase @copySplat

        ###########
        
$copySplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Database        = "WideWorldImporters"
    SharedPath      = "\\nas\sql\migration"
    BackupRestore   = $true
    NoRecovery      = $true
    NoCopyOnly      = $true
}
Copy-DbaDatabase @copySplat

        ###########
        
$diffSplat = @{
    SqlInstance = "sql01"
    Database    = "WideWorldImporters"
    Path        = "\\nas\sql\migration"
    Type        = "Differential"
}
$diff = Backup-DbaDatabase @diffSplat

# Set the source database offline
$offlineSplat = @{
    SqlInstance = "sql01"
    Database    = "WideWorldImporters"
    Offline     = $true
    Force       = $true
}
Set-DbaDbState @offlineSplat

# restore the differential and bring the destination online
$restoreSplat = @{
    SqlInstance = "sql02"
    Database    = "WideWorldImporters"
    Path        = $diff.Path
    Continue    = $true
}
Restore-DbaDatabase @restoreSplat

        ###########
        
$tableSplat = @{
    SqlInstance = "sql01"
    Database    = "WideWorldImporters"
    Name        = "MigrationTestTable"
    ColumnMap   = @{
        Name      = "test"
        Type      = "varchar"
        MaxLength = 20
        Nullable  = $true
    }
}
New-DbaDbTable @tableSplat

        ###########
        
$params = @{
      Source      = "mssql1"
      Destination = "mssql2"
      Database    = "Northwind"
      SharedPath  = "\\nas\sql\shipping"
}
Invoke-DbaDbLogShipping @params

# Then cutover
Invoke-DbaDbLogShipRecovery -SqlInstance mssql2 -Database Northwind

        ###########
        
