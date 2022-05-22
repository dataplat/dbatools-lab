 <#
    This is the code from dbatools in a Month of Lunches chapter 21

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

    
# Generate a random datetime value for the year 2021
$splatGetRandValueDT = @{
  Datatype = "datetime"
  Min = "2021-01-01"
  Max = "2021-12-31 23:59:59"
}
Get-DbaRandomizedValue @splatGetRandValueDT

# Generate a random IP value
$splatGetRandValueIP = @{
  RandomizerType = "Internet"
  RandomizerSubType = "IP"
}
Get-DbaRandomizedValue @splatGetRandValueIP

        ###########
        
Invoke-DbaDbPiiScan -SqlInstance mssql1 -Database AdventureWorks


        ###########
        
Invoke-DbaDbPiiScan -SqlInstance mssql1 -Database AdventureWorks


        ###########
        
Invoke-DbaDbPiiScan -SqlInstance mssql1 -Database AdventureWorks -SampleCount 200

        ###########
        
New-DbaDbMaskingConfig -SqlInstance mssql1 -Database AdventureWorks -Table Address -Column City, PostalCode -Path D:\temp

        ###########
        
Invoke-DbaDbDataMasking -SqlInstance mssql1 -Database dbatools -FilePath "D:\temp\mssql1.AdventureWorks.DataMaskingConfig.json"

        ###########
        
