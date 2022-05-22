 <#
    This is the code from dbatools in a Month of Lunches chapter 20

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

    
Get-Command -Module dbatools -Verb New, Set, Remove -Noun *Agent*


        ###########
        
New-DbaAgentJobCategory -SqlInstance SQL01 -Category PastaFactory


        ###########
        
$schedulesplat = @{
    FrequencyType = 'Daily'
    SqlInstance = 'SQL01'
    Schedule = 'Daily-Midnight'
    Force = $true
    StartTime = '000327'    
    FrequencyInterval = 'Everyday'
}
New-DbaAgentSchedule @schedulesplat

        ###########
        
$schedulesplat = @{
    FrequencyType = 'Monthly'
    SqlInstance = 'SQL01'
    Schedule = 'Monthly-1st-Midnight'
    Force = $true
    StartTime = '000248'
    FrequencyInterval = 1
}
New-DbaAgentSchedule @schedulesplat

        ###########
        
$schedulesplat = @{
    FrequencyType = 'Weekly'
    FrequencyInterval = 'Weekdays'
    SqlInstance = 'SQL01'
    Schedule = 'WorkingWeek-Every-15-Minute'
    Force = $true
    StartTime = '070036'
    EndTime = '180000'
    FrequencySubdayInterval = 15
    FrequencySubdayType = 'Minutes'
}
New-DbaAgentSchedule @schedulesplat

        ###########
        
$credential = Get-Credential -Message "Enter the Username and
Password for the credential"
# Create a new SQL credential
$credsplat = @{
    SqlInstance = 'SQL01'
    SecurePassword = $credential.Password
    Name = 'FactoryProcess'
    Identity = $credential.UserName
}
New-DbaCredential @credsplat

# Create a new Proxy
$proxysplat = @{
    SqlInstance = 'SQL01'
    ProxyCredential = 'FactoryProcess'
    Name = 'FactoryProcess'
    Description = 'Proxy account to run the Factory processing using the
ad\FactoryProcesss account'
    SubSystem = 'CmdExec'
}

New-DbaAgentProxy @proxysplat

        ###########
        
$operatorSplat = @{
    SqlInstance = 'SQL01'
    Operator = 'DBA Team'
    EmailAddress = 'operator@dbateam.com'
}
New-DbaAgentOperator @operatorsplat


        ###########
        
$jobsplat = @{
    SqlInstance = 'SQL01'
    Description = 'This Job processes all of the Italian factories sales
data in the FactorySales database and creates all of the aggregrations.
Contact G Sartori for questions.'
    Category = 'PastaFactory'
    EmailOperator = 'DBA Team'
    Job = 'Factory Data Processing'
    Schedule = 'WorkingWeek-Every-3-Hours'
    EventLogLevel = 'OnFailure'
    EmailLevel = 'OnFailure'
    OwnerLogin = 'ad\FactoryProcesss'
}
New-DbaAgentJob @jobsplat


        ###########
        
$stepcommand = 'EXEC Process_Factory_Sales @Factory="Pasta"'
$stepsplat = @{
    StepId = 1
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Pasta Factory Data'
    OnSuccessAction = 'GoToNextStep'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

$stepcommand = 'EXEC Process_Factory_Sales @Factory="Pizza"'
$stepsplat = @{
    StepId = 2
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Pizza Factory Data'
    OnSuccessAction = 'GoToNextStep'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

$stepcommand = 'EXEC Process_Factory_Sales @Factory="Sausage"'
$stepsplat = @{
    StepId = 3
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Sausage Factory Data'
    OnSuccessAction = 'GoToNextStep'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

$stepcommand = 'EXEC Process_Factory_Sales @Factory="Sauce"'
$stepsplat = @{
    StepId = 4
    Subsystem = 'TransactSql'
    SqlInstance = 'SQL01'
    StepName = ' Process Sauce Factory Data'
    OnSuccessAction = 'QuitWithSuccess'
    Job = 'Factory Data Processing'
    Command = $stepcommand
    OnFailAction = 'QuitWithFailure'
    Database = 'FactorySales'
}
New-DbaAgentJobStep @stepsplat

        ###########
        
$splatGetJobStep = @{
    SqlInstance = "SQL01"
    Job = 'Factory Data Processing'
}
Get-DbaAgentJobStep @splatGetJobStep | Format-Table


        ###########
        
$jobname = 'Copy logins from model'
$jobsplat = @{
    SqlInstance = 'SQL02'
    Category = 'DBA-Model'
    Description = 'Copies logins from the model instance to this instance'
    OwnerLogin = 'ad\DBA'
    Job = $jobname
    EmailOperator = 'DBA Team'
    Schedule = 'Daily-Midnight'
    EventLogLevel = 'OnFailure'
    EmailLevel = 'OnFailure'
    Force = $true
}
New-DbaAgentJob @jobsplat

$command = 'powershell.exe -File C:\AgentScripts\CopyFromModel.ps1'
$stepsplat = @{
    SqlInstance = 'SQL02'
    Subsystem = 'CmdExec'
    Command = $command
    StepName = 'Copy Logins'
    Job = $jobname
    ProxyName = 'PowerShell Proxy'
    Flag = 'AppendAllCmdExecOutputToJobHistory' 
}
New-DbaAgentJobStep @stepsplat

        ###########
        
$splatGetJob = @{
    SqlInstance = "SQL02", "SQL2017N20"
    Job = 'Factory Data Processing'
}
Get-DbaAgentJob @splatGetJob | Start-DbaAgentJob


        ###########
        
 Get-DbaRegisteredServer | Get-DbaRunningJob


        ###########
        
 Get-DbaRunningJob -SqlInstance SQL02, SQL2017N20

        ###########
        
$splatGetJobHist = @{
    SqlInstance = "SQL02"
    Job = 'Copy logins from model'
}
Get-DbaAgentJobHistory @splatGetJobHist


        ###########
        
