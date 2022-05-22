 <#
    This is the code from dbatools in a Month of Lunches chapter 24

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

    
$splatCert = @{
    ComputerName = "sql1"
    Dns = "sql1.ad.local", "sql1"
}
New-DbaComputerCertificate $splatCert


        ###########
        
$splatCSR = @{
    ComputerName = "sql1"
    Dns = "sql1.ad.local", "sql1"
}
New-DbaComputerCertificateSigningRequest $splatCSR

    
        ###########
        
Get-DbaComputerCertificate -ComputerName sql1


        ###########
        
$splatSetCertificate = @{
    SqlInstance = "sql1"
    Thumbprint = "1245FB1ACBCA44D3EE9640F81B6BA14A92F3D6E2"
}
Set-DbaNetworkCertificate @splatSetCertificate

        ###########
        
Get-DbaComputerCertificate | Out-GridView -PassThru |
    Set-DbaNetworkCertificate -SqlInstance sql1

        ###########
        
Enable-DbaForceNetworkEncryption -SqlInstance sql1

        ###########
        
Set-DbaExtendedProtection -SqlInstance sql1 -Value Required

        ###########
        
Test-DbaSpn -ComputerName sql1


        ###########
        
Test-DbaSpn -ComputerName sql1 |
    Where-Object isSet -eq $false  |
    Set-DbaSpn

        ###########
        
Enable-DbaHideInstance -SqlInstance sql1

        ###########
        
Connect-DbaInstance -SqlInstance sql01:12345
# This also works but note you must use single or double quotes
Connect-DbaInstance -SqlInstance "sql01,12345"
# Or use a colon without quotes and we'll translate it for you
Connect-DbaInstance -SqlInstance sql01:12345

        ###########
        
$masterkeypass = (Get-Credential nobody).Password
$certbackuppass = (Get-Credential nobody).Password
$splatEncrypt = @{
        SqlInstance             = "sql1"
        MasterKeySecurePassword = $masterkeypass
        BackupSecurePassword    = $certbackuppass
        BackupPath              = "/tmp"
        AllUserDatabases        = $true
    }
Start-DbaDbEncryption @splatEncrypt

        ###########
        
$masterkeypass = (Get-Credential nobody).Password
$certbackuppass = (Get-Credential nobdody).Password
$splatdbEncrypt = @{
        MasterKeySecurePassword = $masterkeypass
        BackupSecurePassword    = $certbackuppass
        BackupPath              = "/tmp"
    }
Get-DbaDatabase -SqlInstance sql1 -Database db1, db2, db3 |
    Start-DbaDbEncryption @splatdbEncrypt

        ###########
        
Stop-DbaDbEncryption -SqlInstance sql1

        ###########
        
Disable-DbaDbEncryption -SqlInstance sql1 -Database db1, db2, db3

        ###########
        
$securepass = (Get-Credential doesntmatter).Password
$params = @{
    SqlInstance = "sql1"
    Database = "master"
    SecurePassword = $securepass
}
New-DbaDbMasterKey @params
Backup-DbaDbMasterKey @params

        ###########
        
$splatCert = @{
    SqlInstance = "sql1"
    Database = "master"
}
New-DbaDbCertificate @splatCert -Name BackupCert

# Just add to the previous splat!
$splatCert.EncryptionPassword = $securepass
Backup-DbaDbCertificate @splatCert -Certificate BackupCert

        ###########
        
$backupparam = @{
    SqlInstance = "sql1"
    Database = "master"
    FilePath = "c:\backups"
    EncryptionAlgorithm = "AES192"
    EncryptionCertificate = "BackupCert"
}

Backup-DbaDatabase @backupparam

        ###########
        
$splatReadBackup = @{
    SqlInstance = "sql1"
    FilePath = "C:\backups\myEncryptedDatabaseBackup.bak"
}
Test-DbaBackupEncypted @splatReadBackup


        ###########
        
$splatReadBackup = @{
    SqlInstance = "sql1"
    FilePath = "S:\backups\myDatabaseBackup.bak"
}
Test-DbaBackupEncypted @splatReadBackup


        ###########
        
