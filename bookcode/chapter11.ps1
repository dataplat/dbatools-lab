 <#
    This is the code from dbatools in a Month of Lunches chapter 11

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

    
Restore-DbaDatabase -SqlInstance sql01 -Path S:\backups\pubs.bak


        ###########
        
Get-ChildItem \\nas\backups\mydb.bak |
Restore-DbaDatabase -SqlInstance sql01

        ###########
        
New-Item -Path 'C:\temp\sql' -Type Directory -Force
$splatGetDatabase = @{
	SqlInstance = "sql01"
	ExcludeDatabase = "tempdb", "master", "msdb"
}
$dbs = Get-DbaDatabase @splatGetDatabase
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Full
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Diff
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Log
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Log
$dbs | Backup-DbaDatabase -Path C:\temp\sql -Type Log

# See files, set the variable to $files, restore all files
Get-ChildItem -Path C:\temp\sql -OutVariable files
$files | Restore-DbaDatabase -SqlInstance sql01 -WithReplace

        ###########
        
$splatRestoreDatabase = @{
	SqlInstance = "sql01"
	Path = "C:\temp\sql\full.bak"
	WithReplace = $true
	OutputScriptOnly = $true
}
Restore-DbaDatabase @splatRestoreDatabase

        ###########
        
$splatRestoreDb = @{
	SqlInstance = "sql01"
	Path = "\\nas\sql01\mydb01.bak"
	DestinationDataDirectory = "D:\data"
	DestinationLogDirectory = "L:\log"
}
Restore-DbaDatabase @splatRestoreDb

        ###########
        
$splatRestoreDb = @{
	SqlInstance = "sql01"
	NoRecovery = $true
}
Restore-DbaDatabase @splatRestoreDb -Path C:\temp\sql\full.bak
Restore-DbaDatabase @splatRestoreDb -Path C:\temp\sql\diff.bak

        ###########
        
$splatRestoreDbFinal = @{
	SqlInstance = "sql01"
	Path = "C:\temp\sql\trans.trn"
	Continue = $true
}
Restore-DbaDatabase @splatRestoreDbFinal

        ###########
        
$splatRestoreDbRename = @{
	SqlInstance = "sql01"
	Path = "C:\temp\sql\pubs.bak"
	DatabaseName = "Pestering"
	ReplaceDbNameInFile = $true
}
Restore-DbaDatabase @splatRestoreDbRename

        ###########
        
$splatRestoreDbContinue = @{
	SqlInstance = "sql01"
	Path = "\\nas\sql\sql01\mydb"
	RestoreTime = (Get-Date "2019-05-02 21:12:27")
}
Restore-DbaDatabase @splatRestoreDbContinue

        ###########
        
$splatRestoreDb = @{
	SqlInstance = "sql01"
	Database = "pubs"
	FilePath = "C:\temp\full.bak"
}
Backup-DbaDatabase @splatRestoreDb

# Restore to the point right before the delete was executed
$splatRestoreDbMark = @{
	SqlInstance = "sql01"
	Path = "C:\temp\full.bak"
	StopMark = "DeleteCandidates"
	StopBefore = $true
	WithReplace = $true
}
Restore-DbaDatabase @splatRestoreDbMark

        ###########
        
$corruption = Get-DbaSuspectPage -SqlInstance sql01 -Database pubs
$splatRestoreDbPage = @{
	SqlInstance = "sql01"
	Path = "\\nas\backups\sql\pubs.bak"
	PageRestore = $corruption
	PageRestoreTailFolder = "c:\temp"
}
Restore-DbaDatabase @splatRestoreDbPage

        ###########
        
$splatRestoreDbFromAzure = @{
	SqlInstance = "sql01"
	Path = "https://acmecorp.blob.core.windows.net/backups/mydb.bak"
}
Restore-DbaDatabase @splatRestoreDbFromAzure

        ###########
        
$stripe = "https://acmecorp.blob.core.windows.net/backups/mydb-1.bak",
"https://acmecorp.blob.core.windows.net/backups/mydb-2.bak",
"https://acmecorp.blob.core.windows.net/backups/mydb-3.bak"
$stripe | Restore-DbaDatabase -SqlInstance sql01

        ###########
        
$splatRestoreDbFromAzureAK = @{
	SqlInstance = "sql01"
	Path = "https://acmecorp.blob.core.windows.net/backups/mydb.bak"
	AzureCredential = "AzureAccessKey"
}
Restore-DbaDatabase @splatRestoreDbFromAzureAK

        ###########
        
