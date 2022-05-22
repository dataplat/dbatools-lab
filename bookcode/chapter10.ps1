 <#
    This is the code from dbatools in a Month of Lunches chapter 10

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


Backup-DbaDatabase -SqlInstance sql01

        ###########

Backup-DbaDatabase -SqlInstance sql01 -Path \\nas\sqlbackups


        ###########

Backup-DbaDatabase -SqlInstance sql01 -Database pubs -BackupFileName NUL

        ###########

$bigdbs = Get-DbaDatabase -SqlInstance sql01 | Where Name -match factory
$bigdbs | Backup-DbaDatabase -Path \\nas\sqlbackups -OutputScriptOnly

        ###########

$splatCredential = @{
	SqlInstance = "sql01"
	Name = "https://acmecorp.blob.core.windows.net/backups"
	Identity = "SHARED ACCESS SIGNATURE"
	SecurePassword = (Get-Credential).Password
}
New-DbaCredential @splatCredential

$splatBackup = @{
	SqlInstance = "sql01"
	AzureBaseUrl = "https://acmecorp.blob.core.windows.net/backups/"
	Database = "mydb"
	BackupFileName = "mydb.bak"
	WithFormat = $true
}
Backup-DbaDatabase @splatBackup

        ###########

$splatCredential = @{
	SqlInstance = "sql01"
	Name = "AzureAccessKey"
	Identity = "acmecorp"
	SecurePassword = (Get-Credential).Password
}
New-DbaCredential @splatCredential

$splatBackup = @{
	SqlInstance = "sql01"
	AzureCredential = "AzureAccessKey"
	AzureBaseUrl = "https://acmecorp.blob.core.windows.net/backups/"
	Database = "mydb"
}
Backup-DbaDatabase @splatBackup

        ###########

Backup-DbaDatabase -SqlInstance localhost:14433 -SqlCredential sqladmin
  -BackupDirectory /tmp

        ###########

Backup-DbaDatabase -SqlInstance localhost:14433 -SqlCredential sqladmin
  -BackupDirectory /shared/backups

        ###########

Read-DbaBackupHeader -SqlInstance sql01 -Path
 \\nas\sql\backups\mydb.bak

        ###########

Get-DbaBackupInformation -SqlInstance sql01 -Path
 \\nas\sql\backups\sql01

        ###########

Get-DbaDbBackupHistory -SqlInstance sql01 -Database pubs

        ###########

Get-DbaDbBackupHistory -SqlInstance sql01 -Last

        ###########

Find-DbaBackup -Path \\nas\sql\backups -BackupFileExtension bak
 -RetentionPeriod 90d | Remove-Item -Verbose

        ###########

Find-DbaBackup -Path \\nas\sql\backups -BackupFileExtension trn
 -RetentionPeriod 90d | Remove-Item -Verbose

        ###########

$query = "CREATE TABLE dbo.lastbackuptests (
	SourceServer nvarchar(255),
	TestServer nvarchar(255),
	[Database] nvarchar(128),
	FileExists bit,
	Size bigint,
	RestoreResult nvarchar(4000),
	DbccResult nvarchar(4000),
	RestoreStart datetime,
	RestoreEnd datetime,
	RestoreElapsed nvarchar(128),
	DbccStart datetime,
	DbccEnd datetime,
	DbccElapsed nvarchar(128),
	BackupDates nvarchar(4000),
	BackupFiles nvarchar(4000))"
Invoke-DbaQuery -SqlInstance sqltest -Database dbatools -Query $query

$splatTestBackups = @{
	SqlInstance = "sql01", "sql02"
	Destination = "sqltest"
	DataDirectory = "R:\"
	LogDirectory = "L:\"
}
Test-DbaLastBackup @splatTestBackups | Write-DbaDataTable -SqlInstance
sqltest -Table dbatools.dbo.lastbackuptests

        ###########

