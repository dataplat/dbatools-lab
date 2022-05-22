 <#
    This is the code from dbatools in a Month of Lunches chapter 19

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

    
Get-DbaAgentJob -SqlInstance sql01


        ###########
        
Get-DbaAgentJob -SqlInstance SQL01 -Database dbachecks



        ###########
        
Get-DbaAgentAlert -SqlInstance SQL01


        ###########
        
$NotRaised = Get-Date -Date '01-01-0001 00:00:00'
Get-DbaAgentAlert -SqlInstance SQL01 |
Where-Object LastRaised -ne $NotRaised


        ###########
        
Get-DbaAgentOperator -SqlInstance SQL01


        ###########
        
$instances = "SQL01","SQL02","SQL03","SQL04","SQL05"
Find-DbaAgentJob -SqlInstance $instances -JobName *FTP*


        ###########
        
$splatFindAgentJob = @{
    SqlInstance = 'SQL01','SQL02','SQL03','SQL04','SQL05'
    JobName = "*Integrity*"
    IsNotScheduled = $true
}
Find-DbaAgentJob @splatFindAgentJob


        ###########
        
Find-DbaAgentJob -SqlInstance $instances -JobName *ftp* |
Select SqlInstance, JobName, LastRunDate, LastRunOutcome


        ###########
        
$midnight = [datetime]::Today
Find-DbaAgentJob -SqlInstance $instances -JobName *ftp* |
Get-DbaAgentJobHistory -StartDate $midnight


        ###########
        
$threeDaysAgo = [datetime]::Today.AddDays(-3)
Find-DbaAgentJob -SqlInstance sql01 |
Get-DbaAgentJobHistory -StartDate $threeDaysAgo |
ConvertTo-DbaTimeline |
Out-File -FilePath c:\temp\jobs.html -Encoding ASCII

        ###########
        
